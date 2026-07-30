# MediSistema 🏥

Base de datos MySQL para la gestión integral de un centro de salud: médicos (titulares, interinos y sustitutos), empleados no médicos, pacientes, horarios de consulta, sustituciones y control de vacaciones.

## Modelo de datos

### Modelo lógico (Entidad–Relación)

> 📌 El diagrama también está disponible en drawSQL / MySQL Workbench (ver capturas en la carpeta `/diagrama`).

### Decisiones de diseño

| Decisión | Justificación |
|---|---|
| `medico.tipo` como `ENUM('Titular','Interino','Sustituto')` | Un médico tiene exactamente un tipo; el ENUM garantiza integridad de dominio sin necesidad de tabla auxiliar. |
| Tabla `sustitucion` con **dos FK hacia `medico`** | Una sustitución relaciona dos médicos con roles distintos (sustituto y sustituido). Es una relación reflexiva con atributos (fechas, motivo). Un `CHECK` impide que un médico se sustituya a sí mismo. |
| Tabla `vacacion` con dos FK opcionales y `CHECK` exclusivo | Unifica las vacaciones de médicos y empleados en una sola tabla. La restricción `chk_vacacion_titular` obliga a que cada registro pertenezca a un médico **o** a un empleado, nunca a ambos ni a ninguno. |
| `horario_consulta` como tabla propia (1:N) | Un médico puede tener varias franjas por día (turnos partidos), lo que permite calcular las horas semanales de forma exacta con `TIMESTAMPDIFF`. |
| `medico.id_supervisor` → `empleado` | Modela la supervisión administrativa de los médicos por parte del personal no médico (necesaria para la consulta 11). |
| FKs de `sustitucion` y `vacacion` con `RESTRICT` | MySQL 8 no permite combinar acciones en cascada con columnas usadas en un `CHECK` (error 3823). Además, `RESTRICT` protege el histórico: no se puede borrar un médico con sustituciones o vacaciones registradas. |
| Sustitución "activa" | Una sustitución está en curso cuando `CURDATE() BETWEEN fecha_inicio AND fecha_fin`. |

## Instalación y ejecución

**Requisitos**: MySQL 8.0+ (o MariaDB 10.5+).

```bash
# 1. Crear la estructura (base de datos, tablas, claves y restricciones)
mysql -u root -p < estructura.sql

# 2. Cargar los datos de prueba
mysql -u root -p < datos.sql

# 3. Conectarse y ejecutar las consultas
mysql -u root -p medisistema
```

También puede ejecutarse desde **MySQL Workbench**: abrir cada archivo (`File > Open SQL Script`) y ejecutarlo con ⚡ en orden: primero `estructura.sql`, después `datos.sql`.

> ⚠️ Los datos de prueba incluyen sustituciones "en curso" entre el **20/07/2026 y el 14/08/2026**, para que las consultas que usan `CURDATE()` devuelvan resultados en ese rango de fechas. Si se ejecutan fuera de ese rango, basta con actualizar las fechas de las sustituciones 2 y 4 en `datos.sql`.

### Funciones utilizadas en las consultas

Todas las consultas se apoyan en tres funciones básicas de MySQL:

- `DATEDIFF(fin, inicio) + 1` → días entre dos fechas, incluyendo ambos extremos.
- `TIMESTAMPDIFF(MINUTE, hora_inicio, hora_fin) / 60` → horas entre dos horas del día.
- `CURDATE()` → fecha actual, para saber si una sustitución está en curso.

---

# Consultas

1. **Número de pacientes atendidos por cada médico**

`LEFT JOIN` de médicos con pacientes para incluir también a los médicos sin pacientes (los sustitutos), agrupando por médico y contando.

```sql
SELECT m.nombre, m.apellidos, COUNT(p.id_paciente) AS pacientes
FROM medico m
LEFT JOIN paciente p ON p.id_medico = m.id_medico
GROUP BY m.id_medico
ORDER BY pacientes DESC;
```

2. **Total de días de vacaciones planificadas y disfrutadas por cada empleado**

Los días de cada período son `DATEDIFF(fin, inicio) + 1`. Al agrupar por empleado y por tipo de vacación, cada empleado tiene una fila con sus días planificados y otra con los disfrutados.

```sql
SELECT e.nombre, e.apellidos, v.tipo,
       SUM(DATEDIFF(v.fecha_fin, v.fecha_inicio) + 1) AS dias
FROM empleado e
JOIN vacacion v ON v.id_empleado = e.id_empleado
GROUP BY e.id_empleado, v.tipo
ORDER BY e.id_empleado;
```

3. **Médicos con mayor cantidad de horas de consulta en la semana**

Se suman los minutos de todas las franjas semanales de cada médico, se pasan a horas y se ordena de mayor a menor.

```sql
SELECT m.nombre, m.apellidos,
       SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60 AS horas_semana
FROM medico m
JOIN horario_consulta h ON h.id_medico = m.id_medico
GROUP BY m.id_medico
ORDER BY horas_semana DESC;
```

4. **Número de sustituciones realizadas por cada médico sustituto**

Se filtran los médicos de tipo `Sustituto` y se cuentan sus filas en `sustitucion` como sustituto. El `LEFT JOIN` muestra también a los sustitutos con cero sustituciones.

```sql
SELECT m.nombre, m.apellidos, COUNT(s.id_sustitucion) AS sustituciones
FROM medico m
LEFT JOIN sustitucion s ON s.id_medico_sustituto = m.id_medico
WHERE m.tipo = 'Sustituto'
GROUP BY m.id_medico
ORDER BY sustituciones DESC;
```

5. **Número de médicos que están actualmente en sustitución**

Cuenta cuántos médicos distintos están **siendo sustituidos** hoy: la fecha actual debe caer dentro del período de la sustitución.

```sql
SELECT COUNT(DISTINCT id_medico_sustituido) AS total
FROM sustitucion
WHERE CURDATE() BETWEEN fecha_inicio AND fecha_fin;
```

6. **Horas totales de consulta por médico por día de la semana**

Igual que la consulta 3 pero desglosando por `dia_semana`. Al ser un `ENUM`, MySQL ordena los días de forma natural (Lunes → Domingo).

```sql
SELECT m.nombre, h.dia_semana,
       SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60 AS horas
FROM medico m
JOIN horario_consulta h ON h.id_medico = m.id_medico
GROUP BY m.id_medico, h.dia_semana
ORDER BY m.id_medico, h.dia_semana;
```

7. **Médico con mayor cantidad de pacientes asignados**

Se cuentan los pacientes por médico, se ordena de mayor a menor y `LIMIT 1` se queda con el primero.

```sql
SELECT m.nombre, m.apellidos, COUNT(*) AS pacientes
FROM medico m
JOIN paciente p ON p.id_medico = m.id_medico
GROUP BY m.id_medico
ORDER BY pacientes DESC
LIMIT 1;
```

8. **Empleados con más de 10 días de vacaciones disfrutadas**

Se suman solo los períodos de tipo `Disfrutada` (filtro en el `WHERE`) y el `HAVING` deja únicamente a quienes superan los 10 días.

```sql
SELECT e.nombre, e.apellidos,
       SUM(DATEDIFF(v.fecha_fin, v.fecha_inicio) + 1) AS dias
FROM empleado e
JOIN vacacion v ON v.id_empleado = e.id_empleado
WHERE v.tipo = 'Disfrutada'
GROUP BY e.id_empleado
HAVING dias > 10;
```

9. **Médicos que actualmente están realizando una sustitución**

A diferencia de la consulta 5 (médicos sustituidos), aquí se listan los **sustitutos** cuya sustitución incluye la fecha de hoy.

```sql
SELECT m.nombre, m.apellidos, s.fecha_inicio, s.fecha_fin
FROM medico m
JOIN sustitucion s ON s.id_medico_sustituto = m.id_medico
WHERE CURDATE() BETWEEN s.fecha_inicio AND s.fecha_fin;
```

10. **Promedio de horas de consulta por médico por día de la semana**

Horas totales de la semana divididas entre el número de días distintos en los que el médico pasa consulta.

```sql
SELECT m.nombre, m.apellidos,
       ROUND(SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60
             / COUNT(DISTINCT h.dia_semana), 2) AS promedio_diario
FROM medico m
JOIN horario_consulta h ON h.id_medico = m.id_medico
GROUP BY m.id_medico;
```

11. **Empleados con mayor número de pacientes atendidos por los médicos bajo su supervisión**

Se encadena `empleado → medico (id_supervisor) → paciente`: por cada empleado se cuentan los pacientes de todos los médicos que supervisa.

```sql
SELECT e.nombre, e.apellidos, COUNT(p.id_paciente) AS pacientes
FROM empleado e
JOIN medico m ON m.id_supervisor = e.id_empleado
LEFT JOIN paciente p ON p.id_medico = m.id_medico
GROUP BY e.id_empleado
ORDER BY pacientes DESC;
```

12. **Médicos con más de 5 pacientes y total de horas de consulta en la semana**

Se cuentan los pacientes por médico y las horas semanales se obtienen con una subconsulta aparte, para que el `JOIN` con pacientes no multiplique las filas de horarios.

```sql
SELECT m.nombre, m.apellidos,
       COUNT(p.id_paciente) AS pacientes,
       (SELECT SUM(TIMESTAMPDIFF(MINUTE, hora_inicio, hora_fin)) / 60
        FROM horario_consulta h
        WHERE h.id_medico = m.id_medico) AS horas_semana
FROM medico m
JOIN paciente p ON p.id_medico = m.id_medico
GROUP BY m.id_medico
HAVING pacientes > 5;
```

13. **Total de días de vacaciones planificadas y disfrutadas por cada tipo de empleado**

Misma lógica que la consulta 2, pero agrupando por tipo de empleado (ATS, auxiliares, celadores y administrativos) en lugar de por empleado individual.

```sql
SELECT e.tipo AS tipo_empleado, v.tipo AS tipo_vacacion,
       SUM(DATEDIFF(v.fecha_fin, v.fecha_inicio) + 1) AS dias
FROM empleado e
JOIN vacacion v ON v.id_empleado = e.id_empleado
GROUP BY e.tipo, v.tipo
ORDER BY e.tipo;
```

14. **Total de pacientes por cada tipo de médico**

Agrupa por `medico.tipo` para comparar cuántos pacientes atienden titulares, interinos y sustitutos.

```sql
SELECT m.tipo, COUNT(p.id_paciente) AS pacientes
FROM medico m
LEFT JOIN paciente p ON p.id_medico = m.id_medico
GROUP BY m.tipo;
```


## Estructura del repositorio

```
├── estructura.sql   # DDL: base de datos, tablas, PK, FK y restricciones
├── datos.sql        # DML: datos de prueba realistas
├── consultas.sql    # Las 20 consultas listas para ejecutar
├── diagrama/        # Capturas del modelo (drawSQL / MySQL Workbench)
└── README.md        # Documentación y consultas resueltas
```
