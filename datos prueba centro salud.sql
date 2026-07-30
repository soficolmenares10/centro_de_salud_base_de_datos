
-- MediSistema - Datos de Prueba
-- Escenarios realistas para validar el funcionamiento del sistema

USE medisistema;

-- EMPLEADOS (personal no médico)

INSERT INTO empleado (id_empleado, nombre, apellidos, dni, telefono, email, tipo, fecha_contratacion) VALUES
(1, 'Rosa',   'Jimenez Soto',      '11111111A', '600111111', 'rosa.jimenez@medisistema.es',   'Administrativo',         '2015-03-02'),
(2, 'Luis',   'Ortega Pardo',      '22222222B', '600222222', 'luis.ortega@medisistema.es',    'Administrativo',         '2017-09-11'),
(3, 'Ana',    'Castillo Rey',      '33333333C', '600333333', 'ana.castillo@medisistema.es',   'ATS',                    '2016-01-18'),
(4, 'Miguel', 'Vega Luna',         '44444444D', '600444444', 'miguel.vega@medisistema.es',    'ATS',                    '2019-06-03'),
(5, 'Isabel', 'Ramos Cano',        '55555555E', '600555555', 'isabel.ramos@medisistema.es',   'Auxiliar de Enfermeria', '2018-02-12'),
(6, 'Tomas',  'Gil Marin',         '66666666F', '600666666', 'tomas.gil@medisistema.es',      'Auxiliar de Enfermeria', '2020-10-05'),
(7, 'Nuria',  'Blanco Sanz',       '77777777G', '600777777', 'nuria.blanco@medisistema.es',   'Celador',                '2014-07-21'),
(8, 'Oscar',  'Prieto Nieto',      '88888888H', '600888888', 'oscar.prieto@medisistema.es',   'Celador',                '2021-04-19');

-- MEDICOS (titulares, interinos y sustitutos)

INSERT INTO medico (id_medico, nombre, apellidos, dni, telefono, email, especialidad, tipo, fecha_contratacion, id_supervisor) VALUES
(1,  'Carmen',  'Garcia Ruiz',      '10000001J', '610000001', 'carmen.garcia@medisistema.es',  'Medicina General', 'Titular',   '2010-01-11', 1),
(2,  'Javier',  'Martinez Diaz',    '10000002K', '610000002', 'javier.martinez@medisistema.es','Medicina General', 'Titular',   '2012-05-14', 1),
(3,  'Lucia',   'Fernandez Mora',   '10000003L', '610000003', 'lucia.fernandez@medisistema.es','Pediatria',        'Titular',   '2013-09-02', 2),
(4,  'Andres',  'Lopez Serra',      '10000004M', '610000004', 'andres.lopez@medisistema.es',   'Pediatria',        'Interino',  '2021-02-01', 2),
(5,  'Marta',   'Sanchez Vidal',    '10000005N', '610000005', 'marta.sanchez@medisistema.es',  'Medicina General', 'Interino',  '2022-06-13', 1),
(6,  'Pablo',   'Romero Salas',     '10000006P', '610000006', 'pablo.romero@medisistema.es',   'Medicina General', 'Sustituto', '2023-01-09', 3),
(7,  'Elena',   'Torres Ibanez',    '10000007Q', '610000007', 'elena.torres@medisistema.es',   'Pediatria',        'Sustituto', '2023-03-20', 3),
(8,  'Ricardo', 'Molina Paz',       '10000008R', '610000008', 'ricardo.molina@medisistema.es', 'Medicina General', 'Titular',   '2011-11-07', 1),
(9,  'Sofia',   'Navarro Alba',     '10000009S', '610000009', 'sofia.navarro@medisistema.es',  'Ginecologia',      'Titular',   '2014-04-28', 2),
(10, 'Diego',   'Herrera Cruz',     '10000010T', '610000010', 'diego.herrera@medisistema.es',  'Medicina General', 'Sustituto', '2024-02-05', 3);

-- PACIENTES (asignados a los médicos activos)

INSERT INTO paciente (id_paciente, nombre, apellidos, dni, fecha_nacimiento, telefono, direccion, id_medico) VALUES
(1,  'Juan',     'Perez Gomez',      '20000001A', '1980-04-12', '620000001', 'C/ Mayor 1',        1),
(2,  'Maria',    'Lopez Arias',      '20000002B', '1975-08-30', '620000002', 'C/ Mayor 3',        1),
(3,  'Pedro',    'Santos Rico',      '20000003C', '1990-01-22', '620000003', 'Av. Sol 12',        1),
(4,  'Laura',    'Nunez Bravo',      '20000004D', '1985-11-05', '620000004', 'C/ Luna 8',         1),
(5,  'Carlos',   'Iglesias Roca',    '20000005E', '1968-06-17', '620000005', 'Pza. Espana 2',     1),
(6,  'Cristina', 'Marin Vela',       '20000006F', '1995-02-28', '620000006', 'C/ Rio 21',         1),
(7,  'Alberto',  'Campos Lara',      '20000007G', '1972-12-09', '620000007', 'C/ Norte 5',        1),
(8,  'Silvia',   'Reyes Mata',       '20000008H', '1988-07-14', '620000008', 'C/ Sur 9',          2),
(9,  'Raul',     'Ferrer Cid',       '20000009J', '1979-03-03', '620000009', 'Av. Este 30',       2),
(10, 'Patricia', 'Gallego Rios',     '20000010K', '1992-10-26', '620000010', 'C/ Oeste 4',        2),
(11, 'Sergio',   'Medina Coll',      '20000011L', '1983-05-19', '620000011', 'C/ Olmo 7',         2),
(12, 'Beatriz',  'Soler Pina',       '20000012M', '1970-09-08', '620000012', 'C/ Pino 15',        2),
(13, 'Victor',   'Cabrera Boch',     '20000013N', '1965-01-31', '620000013', 'C/ Roble 2',        2),
(14, 'Daniela',  'Fuentes Mir',      '20000014P', '2015-03-25', '620000014', 'C/ Alamo 11',       3),
(15, 'Hugo',     'Pascual Riera',    '20000015Q', '2018-06-10', '620000015', 'C/ Cedro 6',        3),
(16, 'Valeria',  'Bernal Font',      '20000016R', '2016-12-01', '620000016', 'Av. Parque 3',      3),
(17, 'Mateo',    'Roldan Sole',      '20000017S', '2019-08-23', '620000017', 'C/ Sauce 18',       3),
(18, 'Julia',    'Camacho Puig',     '20000018T', '2017-04-07', '620000018', 'C/ Fresno 9',       3),
(19, 'Adrian',   'Montero Riba',     '20000019V', '2020-10-15', '620000019', 'C/ Haya 1',         4),
(20, 'Emma',     'Suarez Ferre',     '20000020W', '2021-02-11', '620000020', 'C/ Encina 14',      4),
(21, 'Leo',      'Dominguez Pla',    '20000021X', '2019-05-29', '620000021', 'Av. Centro 20',     4),
(22, 'Olivia',   'Carrasco Valls',   '20000022Y', '2022-09-03', '620000022', 'C/ Abeto 5',        4),
(23, 'Manuel',   'Aguilar Rovira',   '20000023Z', '1958-07-27', '620000023', 'C/ Tejo 10',        5),
(24, 'Rocio',    'Leon Serra',       '20000024A', '1963-11-16', '620000024', 'C/ Nogal 13',       5),
(25, 'Gonzalo',  'Mendez Costa',     '20000025B', '1977-02-20', '620000025', 'Pza. Mayor 6',      5),
(26, 'Teresa',   'Vidal Ramon',      '20000026C', '1969-08-04', '620000026', 'C/ Ciprés 8',       8),
(27, 'Ignacio',  'Rubio Miro',       '20000027D', '1981-12-13', '620000027', 'C/ Almez 22',       8),
(28, 'Alicia',   'Moreno Batlle',    '20000028E', '1998-03-09', '620000028', 'Av. Salud 17',      9);

-- HORARIOS DE CONSULTA (franjas semanales)

INSERT INTO horario_consulta (id_medico, dia_semana, hora_inicio, hora_fin) VALUES
-- Carmen Garcia (1): 30 h semanales
(1, 'Lunes',     '08:00', '14:00'),
(1, 'Martes',    '08:00', '14:00'),
(1, 'Miercoles', '08:00', '14:00'),
(1, 'Jueves',    '08:00', '14:00'),
(1, 'Viernes',   '08:00', '14:00'),
-- Javier Martinez (2): 27 h semanales (turno partido el lunes)
(2, 'Lunes',     '09:00', '13:00'),
(2, 'Lunes',     '15:00', '18:00'),
(2, 'Martes',    '09:00', '14:00'),
(2, 'Miercoles', '09:00', '14:00'),
(2, 'Jueves',    '09:00', '14:00'),
(2, 'Viernes',   '09:00', '14:00'),
-- Lucia Fernandez (3): 25 h semanales
(3, 'Lunes',     '08:30', '13:30'),
(3, 'Martes',    '08:30', '13:30'),
(3, 'Miercoles', '08:30', '13:30'),
(3, 'Jueves',    '08:30', '13:30'),
(3, 'Viernes',   '08:30', '13:30'),
-- Andres Lopez (4): 20 h semanales (turno de tarde)
(4, 'Lunes',     '14:00', '19:00'),
(4, 'Martes',    '14:00', '19:00'),
(4, 'Miercoles', '14:00', '19:00'),
(4, 'Jueves',    '14:00', '19:00'),
-- Marta Sanchez (5): 22 h semanales
(5, 'Lunes',     '10:00', '14:00'),
(5, 'Martes',    '10:00', '14:00'),
(5, 'Miercoles', '10:00', '15:00'),
(5, 'Jueves',    '10:00', '15:00'),
(5, 'Viernes',   '10:00', '14:00'),
-- Pablo Romero (6, sustituto): 15 h semanales
(6, 'Lunes',     '08:00', '13:00'),
(6, 'Miercoles', '08:00', '13:00'),
(6, 'Viernes',   '08:00', '13:00'),
-- Elena Torres (7, sustituta): 12 h semanales
(7, 'Martes',    '14:00', '18:00'),
(7, 'Jueves',    '14:00', '18:00'),
(7, 'Viernes',   '14:00', '18:00'),
-- Ricardo Molina (8): 24 h semanales
(8, 'Lunes',     '08:00', '14:00'),
(8, 'Martes',    '08:00', '14:00'),
(8, 'Jueves',    '08:00', '14:00'),
(8, 'Viernes',   '08:00', '14:00'),
-- Sofia Navarro (9): 18 h semanales
(9, 'Martes',    '09:00', '15:00'),
(9, 'Miercoles', '09:00', '15:00'),
(9, 'Jueves',    '09:00', '15:00'),
-- Diego Herrera (10, sustituto): 10 h semanales
(10, 'Martes',   '08:00', '13:00'),
(10, 'Jueves',   '08:00', '13:00');

-- SUSTITUCIONES
-- Las sustituciones 2 y 4 están ACTIVAS respecto a la fecha actual
-- del escenario (finales de julio / principios de agosto de 2026).

INSERT INTO sustitucion (id_sustitucion, id_medico_sustituto, id_medico_sustituido, fecha_inicio, fecha_fin, motivo) VALUES
(1, 6,  1, '2026-02-09', '2026-02-20', 'Vacaciones de la Dra. Garcia'),
(2, 6,  2, '2026-07-20', '2026-08-07', 'Vacaciones del Dr. Martinez'),
(3, 7,  3, '2026-04-06', '2026-04-17', 'Congreso de Pediatria'),
(4, 7,  4, '2026-07-27', '2026-08-14', 'Vacaciones del Dr. Lopez'),
(5, 10, 5, '2026-03-02', '2026-03-13', 'Baja medica de la Dra. Sanchez'),
(6, 6,  8, '2026-05-11', '2026-05-22', 'Permiso de formacion del Dr. Molina');


-- VACACIONES (planificadas y disfrutadas)

-- Vacaciones de EMPLEADOS
INSERT INTO vacacion (id_medico, id_empleado, tipo, fecha_inicio, fecha_fin) VALUES
(NULL, 1, 'Planificada', '2026-08-03', '2026-08-23'),  -- 21 dias
(NULL, 1, 'Disfrutada',  '2026-03-02', '2026-03-13'),  -- 12 dias
(NULL, 2, 'Planificada', '2026-09-01', '2026-09-10'),  -- 10 dias
(NULL, 2, 'Disfrutada',  '2026-01-12', '2026-01-16'),  -- 5 dias
(NULL, 3, 'Planificada', '2026-08-10', '2026-08-31'),  -- 22 dias
(NULL, 3, 'Disfrutada',  '2026-04-01', '2026-04-15'),  -- 15 dias
(NULL, 4, 'Planificada', '2026-12-21', '2026-12-31'),  -- 11 dias
(NULL, 4, 'Disfrutada',  '2026-02-02', '2026-02-06'),  -- 5 dias
(NULL, 5, 'Planificada', '2026-08-17', '2026-08-28'),  -- 12 dias
(NULL, 5, 'Disfrutada',  '2026-05-04', '2026-05-15'),  -- 12 dias
(NULL, 6, 'Planificada', '2026-10-05', '2026-10-16'),  -- 12 dias
(NULL, 6, 'Disfrutada',  '2026-06-08', '2026-06-10'),  -- 3 dias
(NULL, 7, 'Planificada', '2026-11-02', '2026-11-13'),  -- 12 dias
(NULL, 7, 'Disfrutada',  '2026-06-01', '2026-06-05'),  -- 5 dias
(NULL, 8, 'Planificada', '2026-09-14', '2026-09-25'),  -- 12 dias
(NULL, 8, 'Disfrutada',  '2026-01-19', '2026-01-30');  -- 12 dias

-- Vacaciones de MEDICOS (coherentes con las sustituciones registradas)

INSERT INTO vacacion (id_medico, id_empleado, tipo, fecha_inicio, fecha_fin) VALUES
(1,  NULL, 'Planificada', '2026-08-03', '2026-08-24'),  -- 22 dias
(1,  NULL, 'Disfrutada',  '2026-02-09', '2026-02-20'),  -- 12 dias (sustitucion 1)
(2,  NULL, 'Planificada', '2026-07-20', '2026-08-07'),  -- 19 dias (sustitucion 2, en curso)
(3,  NULL, 'Disfrutada',  '2026-04-06', '2026-04-17'),  -- 12 dias (sustitucion 3)
(4,  NULL, 'Planificada', '2026-07-27', '2026-08-14'),  -- 19 dias (sustitucion 4, en curso)
(5,  NULL, 'Disfrutada',  '2026-03-02', '2026-03-13'),  -- 12 dias (sustitucion 5)
(8,  NULL, 'Disfrutada',  '2026-05-11', '2026-05-22'),  -- 12 dias (sustitucion 6)
(9,  NULL, 'Planificada', '2026-12-14', '2026-12-24');  -- 11 dias