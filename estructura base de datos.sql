-- MediSistema - Estructura de la Base de Datos
-- Sistema de gestión de médicos, empleados y pacientes de un centro de salud

DROP DATABASE IF EXISTS medisistema;
CREATE DATABASE medisistema CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medisistema;

-- Tabla: empleado
-- Personal no médico del centro de salud (ATS, auxiliares de enfermería,
-- celadores y administrativos).

CREATE TABLE empleado (
    id_empleado       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(50)  NOT NULL,
    apellidos         VARCHAR(100) NOT NULL,
    dni               CHAR(9)      NOT NULL,
    telefono          VARCHAR(15),
    email             VARCHAR(100),
    tipo              ENUM('ATS','Auxiliar de Enfermeria','Celador','Administrativo') NOT NULL,
    fecha_contratacion DATE        NOT NULL,
    PRIMARY KEY (id_empleado),
    UNIQUE KEY uq_empleado_dni (dni)
) ENGINE=InnoDB;

-- Tabla: medico
-- Personal médico. El campo `tipo` distingue entre titulares, interinos
-- y sustitutos. Cada médico puede estar supervisado administrativamente
-- por un empleado (id_supervisor).

CREATE TABLE medico (
    id_medico         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(50)  NOT NULL,
    apellidos         VARCHAR(100) NOT NULL,
    dni               CHAR(9)      NOT NULL,
    telefono          VARCHAR(15),
    email             VARCHAR(100),
    especialidad      VARCHAR(60)  NOT NULL,
    tipo              ENUM('Titular','Interino','Sustituto') NOT NULL,
    fecha_contratacion DATE        NOT NULL,
    id_supervisor     INT UNSIGNED NULL,
    PRIMARY KEY (id_medico),
    UNIQUE KEY uq_medico_dni (dni),
    CONSTRAINT fk_medico_supervisor
        FOREIGN KEY (id_supervisor) REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;


-- Tabla: paciente
-- Cada paciente tiene asignado un médico (relación N:1).

CREATE TABLE paciente (
    id_paciente       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(50)  NOT NULL,
    apellidos         VARCHAR(100) NOT NULL,
    dni               CHAR(9)      NOT NULL,
    fecha_nacimiento  DATE         NOT NULL,
    telefono          VARCHAR(15),
    direccion         VARCHAR(150),
    id_medico         INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_paciente),
    UNIQUE KEY uq_paciente_dni (dni),
    CONSTRAINT fk_paciente_medico
        FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla: horario_consulta
-- Franjas de consulta semanales de cada médico. Un médico puede tener
-- varias franjas por día (relación 1:N).

CREATE TABLE horario_consulta (
    id_horario        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_medico         INT UNSIGNED NOT NULL,
    dia_semana        ENUM('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo') NOT NULL,
    hora_inicio       TIME NOT NULL,
    hora_fin          TIME NOT NULL,
    PRIMARY KEY (id_horario),
    UNIQUE KEY uq_horario (id_medico, dia_semana, hora_inicio),
    CONSTRAINT fk_horario_medico
        FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_horario_valido CHECK (hora_fin > hora_inicio)
) ENGINE=InnoDB;

-- Tabla: sustitucion
-- Períodos en los que un médico sustituto cubre a otro médico.
-- Una sustitución está "activa" cuando la fecha actual está dentro
-- del rango [fecha_inicio, fecha_fin].

CREATE TABLE sustitucion (
    id_sustitucion       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_medico_sustituto  INT UNSIGNED NOT NULL,  -- médico que realiza la sustitución
    id_medico_sustituido INT UNSIGNED NOT NULL,  -- médico que es sustituido
    fecha_inicio         DATE NOT NULL,
    fecha_fin            DATE NOT NULL,
    motivo               VARCHAR(150),
    PRIMARY KEY (id_sustitucion),
    CONSTRAINT fk_sust_sustituto
        FOREIGN KEY (id_medico_sustituto) REFERENCES medico (id_medico)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_sust_sustituido
        FOREIGN KEY (id_medico_sustituido) REFERENCES medico (id_medico)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_sust_fechas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_sust_distintos CHECK (id_medico_sustituto <> id_medico_sustituido)
) ENGINE=InnoDB;

-- Tabla: vacacion
-- Vacaciones planificadas y disfrutadas de médicos y empleados.
-- Cada registro pertenece a un médico O a un empleado (exclusivo),
-- garantizado por la restricción chk_vacacion_titular.

CREATE TABLE vacacion (
    id_vacacion       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_medico         INT UNSIGNED NULL,
    id_empleado       INT UNSIGNED NULL,
    tipo              ENUM('Planificada','Disfrutada') NOT NULL,
    fecha_inicio      DATE NOT NULL,
    fecha_fin         DATE NOT NULL,
    PRIMARY KEY (id_vacacion),
    CONSTRAINT fk_vacacion_medico
        FOREIGN KEY (id_medico) REFERENCES medico (id_medico)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT fk_vacacion_empleado
        FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT chk_vacacion_fechas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_vacacion_titular CHECK (
        (id_medico IS NOT NULL AND id_empleado IS NULL) OR
        (id_medico IS NULL AND id_empleado IS NOT NULL)
    )
) ENGINE=InnoDB;

-- Índices adicionales para optimizar las consultas más frecuentes
CREATE INDEX idx_paciente_medico    ON paciente (id_medico);
CREATE INDEX idx_horario_dia        ON horario_consulta (dia_semana);
CREATE INDEX idx_sust_fechas        ON sustitucion (fecha_inicio, fecha_fin);
CREATE INDEX idx_vacacion_tipo      ON vacacion (tipo);

