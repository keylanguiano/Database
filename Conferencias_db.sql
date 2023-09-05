# Created by: Anguiano Cabrera Keyla Leilani
# Date: 17/02/2023
# Definition: Crear una base de datos para controlar la información sobre la asistencia de estudiantes a conferencias

CREATE DATABASE IF NOT EXISTS conferencias_db;

#Abrir la base datos para poner cosas dentro de ella
USE conferencias_db;

CREATE TABLE IF NOT EXISTS estudiante (
	est_id INT NOT NULL AUTO_INCREMENT,
	est_nombre VARCHAR (30) NOT NULL,
    est_ap_paterno VARCHAR (30) NOT NULL,
    est_ap_materno VARCHAR (30),
    est_carrera VARCHAR (7) NOT NULL COMMENT 'Solo almacenar las siglas de la carrera, p.ej, LISC',
    est_correo VARCHAR (30) NOT NULL,
    
    PRIMARY KEY (est_id),
    
    INDEX idx_nom_comp (est_nombre, est_ap_paterno, est_ap_materno),
    INDEX idx_carrera (est_carrera),
   
   UNIQUE uni_correo (est_correo)
);

CREATE TABLE IF NOT EXISTS evento (
	eve_id INT NOT NULL AUTO_INCREMENT,
	eve_nombre VARCHAR (70) NOT NULL,
    eve_fecha DATE NOT NULL,
    eve_hora TIME NOT NULL,
    eve_duracion INT NOT NULL COMMENT 'La duración se da en minutos',
    eve_ponente VARCHAR (60) NOT NULL,
    
    PRIMARY KEY (eve_id),
    
    INDEX idx_nombre (eve_nombre),
    INDEX idx_ponente (eve_ponente),
    INDEX idx_fecha (eve_fecha),
    
    UNIQUE uni_fecha_hora_pon (eve_fecha, eve_hora, eve_ponente)
);

CREATE TABLE IF NOT EXISTS asistencia (
	asi_eve_id INT NOT NULL,   
    asi_est_id INT NOT NULL,
    asi_hora_llegada TIME NOT NULL,
    
    PRIMARY KEY (asi_eve_id, asi_est_id),
    
    CONSTRAINT fk_estudiante_asistencia
		FOREIGN KEY (asi_est_id)
		REFERENCES estudiante (est_id)
        
		ON DELETE CASCADE
		ON UPDATE CASCADE,
        
	CONSTRAINT fk_evento_asistencia
		FOREIGN KEY (asi_eve_id)
		REFERENCES evento (eve_id)
        
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);


/*
# 1. MODIFICACIONES
# En la base de conferencias:

# Crea un atributo de semestre en la tabla estudiante con tipo TINYINT antes del atributo de correo.
ALTER TABLE estudiante 
	ADD est_semestre TINYINT AFTER est_carrera;

# Crea un índice para la carrera en la tabla estudiante.
ALTER TABLE estudiante 
	ADD INDEX idx_carrera (est_carrera);
    
# Elimina el índice del ponente en la tabla evento.
ALTER TABLE evento 
	DROP INDEX idx_ponente;

# Cambia el nombre y el tipo del atributo eve_ponente por eve_orador con tipo VARCHAR(50).
ALTER TABLE evento 
	CHANGE eve_ponente eve_orador VARCHAR (50);

# Crea un atributo llamado eve_nota al final de la tabla evento de tipo TEXT.
ALTER TABLE evento 
	ADD eve_nota TEXT;

# Elimina las llaves foráneas de la tabla asistencia.
ALTER TABLE asistencia 
	DROP FOREIGN KEY fk_estudiante_asistencia;

# Elimina la llave primaria en la tabla asistencia.
ALTER TABLE asistencia 
	MODIFY asi_eve_id VARCHAR(1);

ALTER TABLE asistencia 
	MODIFY asi_est_id VARCHAR(1);
    
ALTER TABLE asistencia 
	DROP PRIMARY KEY;

# Crea un nuevo atributo llamado asi_id en la tabla asistencia de tipo INT, NOT NULL y AUTO_INCREMENT.
ALTER TABLE asistencia 
	ADD asi_id INT NOT NULL AUTO_INCREMENT FIRST;
    
# Crea una llave primaria en la tabla asistencia con el nuevo atributo asi_id.
ALTER TABLE asistencia 
	ADD PRIMARY KEY (asi_id);
*/


# 2. INSERCIÓN
# Insertar datos en la BD de conferencias:

# 3 estudiantes de cada carrera: LISC, LICE, LIME, LIGE, LIMEC, LIAD

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Keyla Leilani', 'Anguiano', 'Cabrera', 'LISC', 'kl.anguianocabrera@ugto.mx'),
		   ('Jean David', 'García', 'Jaime', 'LISC', 'jd.garciajaime@ugto.mx'),
		   ('Fernando', 'Romero', 'Torres', 'LISC', 'f.romerotorres@ugto.mx');
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Diego', 'Díaz', 'Segovia', 'LICE', 'd.diazsegovia@ugto.mx'),
		   ('María Guadalupe', 'Prieto', 'Pantoja', 'LICE', 'mg.prietopantoja@ugto.mx'),
		   ('Pedro Ángel', 'Lopéz', 'Vargas', 'LICE', 'pa.lopezvargas@ugto.mx');

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Jonathan Uriel', 'Pérez', 'Vargas', 'LIME', 'ju.perezvargas@ugto.mx'),
		   ('Nicholas Andrew', 'Guido', 'Arroyo', 'LIME', 'na.guidoarroyo@ugto.mx'),
		   ('Fabian Alexis', 'Segoviano', 'Balandran', 'LIME', 'fa.segovianobalandran@ugto.mx');

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Perla Yareli', 'Camacho', 'Sanchéz', 'LIGE', 'py.camachosanchez@ugto.mx'),
		   ('Jonathan Antonio', 'Vallejo', 'Pérez', 'LIGE', 'ja.vallejoperez@ugto.mx'),
		   ('Emmanuel', 'Coronilla', 'Hernández', 'LIGE', 'e.coronillahernandez@ugto.mx');
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Paolo de Piero', 'Lorandi', 'Camacho', 'LIMEC', 'pdp.lorandicamacho@ugto.mx'),
		   ('Ximena', 'Ocejo', 'Rizo', 'LIMEC', 'x.ocejorizo@ugto.mx'),
		   ('Jesus Adrian', 'Martínez', 'Jaime', 'LIMEC', 'ja.martinezjaime@ugto.mx');
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_carrera, est_correo)
	VALUES ('Andrea', 'Bravo', 'Carmona', 'LIAD', 'a.bravocarmona@ugto.mx'),
		   ('Hadassah Alejandra', 'Hernández', 'García', 'LIAD', 'ha.hernandezgarcia@ugto.mx'),
		   ('Adrian', 'Corona', 'Pacheco', 'LIAD', 'a.coronapacheco@ugto.mx');
           
# 4 eventos para fechas en cada mes: abril, mayo, junio, en horario entre las 10.00-16.00h, con duraciones entre 30 y 90 minutos.

INSERT INTO evento (eve_nombre, eve_fecha, eve_hora, eve_duracion, eve_ponente)
	VALUES ('Taller motivación académica', '2023-04-05', '10:00:00' , 90, 'Erandi Solorio Farfán'),
		   ('Plática métodos para definir tus objetivos', '2023-04-10', '10:30:00' , 60, 'Erandi Solorio Farfán'),
		   ('Plática mi vocación profesional', '2023-04-15', '11:00' , 60, 'Erandi Solorio Farfán'),
		   ('Plática métodos para definir tus objetivos', '2023-04-20', '11:30:00' , 60, 'Erandi Solorio Farfán');
           
INSERT INTO evento (eve_nombre, eve_fecha, eve_hora, eve_duracion, eve_ponente)
	VALUES ('Plática el arte de descansar', '2023-05-05', '12:00:00' , 60, 'Erandi Solorio Farfán'),
		   ('Plática abeja activa y creativa', '2023-05-10', '12:30:00' , 60, 'Erandi Solorio Farfán'),
		   ('Plática una mirada a las inteligencias múltiples', '2023-05-15', '13:00:00' , 60, 'Erandi Solorio Farfán'),
		   ('Taller motivacón académica', '2023-05-20', '13:30:00' , 90, 'Erandi Solorio Farfán');
           
INSERT INTO evento (eve_nombre, eve_fecha, eve_hora, eve_duracion, eve_ponente)
	VALUES ('Taller planeando tu futuro', '2023-06-05', '14:00:00' , 90, 'Erandi Solorio Farfán'),
		   ('Taller creando mi CV', '2023-06-10', '14:30:00' , 90, 'Erandi Solorio Farfán'),
		   ('Plática activa tus procesos cógnitivos', '2023-06-15', '15:00:00' , 60, 'Erandi Solorio Farfán'),
		   ('Plática preparándome para mis exámenes', '2023-06-20', '15:30:00' , 60, 'Erandi Solorio Farfán');
           
# 2 registros de estudiantes para cada evento.

INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (1, 1, '10:00:00'),
		   (1, 2, '10:05:00');

INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (2, 3, '10:30:00'),
		   (2, 4, '10:35:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (3, 5, '11:00:00'),
		   (3, 6, '11:05:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (4, 7, '11:30:00'),
		   (4, 8, '11:35:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (5, 9, '12:00:00'),
		   (5, 10, '12:05:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (6, 11, '12:30:00'),
		   (6, 12, '12:35:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (7, 13, '13:00:00'),
		   (7, 14, '13:05:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (8, 15, '13:30:00'),
		   (8, 16, '13:35:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (9, 17, '14:00:00'),
		   (9, 18, '14:05:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (10, 1, '14:30:00'),
		   (10, 2, '14:35:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (11, 3, '15:00:00'),
		   (11, 4, '15:05:00');
           
INSERT INTO asistencia (asi_eve_id, asi_est_id, asi_hora_llegada)
	VALUES (12, 5, '15:30:00'),
		   (12, 6, '15:35:00');
           
USE conferencias_db;    
       

/*
# 3. BORRADO
# Borrar datos en la BD de conferencias:

# Borrar registros de asistencia para un evento cualquiera con id específico (dado por ti) y cuya hora de llegada sea mayor o igual de las 10.30h.
DELETE FROM asistencia
	WHERE asi_eve_id = 1
		AND asi_hora_llegada >= '10:30:00';

# Borrar eventos que estén programados para mayo con hora de inicio a las 10.00h u 11.00h y que tengan duración de 30 minutos.
DELETE FROM evento
	WHERE eve_fecha BETWEEN '2023-05-01' AND '2023-05-31'
		AND eve_hora BETWEEN '10:00:00' AND '11:00:00'
		AND eve_duracion = 30;

# Borrar eventos de un ponente específico (dado por ti) y cuyo nombre del evento tenga incluido el string 'futuro'.
DELETE FROM asistencia
	WHERE asi_eve_id = 9;

DELETE FROM evento
	WHERE eve_ponente = 'Erandi Solorio Farfán'
		AND eve_nombre LIKE '%futuro%';

# Borrar eventos con duración entre 60 y 80 minutos que estén programados para los primeros 15 días de junio.
DELETE FROM evento
	WHERE eve_duracion BETWEEN 60 AND 80
		AND (eve_fecha BETWEEN '2023-05-01' AND '2023-05-15');

# Borrar estudiantes cuyo apellido paterno termine en el string 'ís' y sean de la carrera de LISC.
DELETE FROM estudiante
	WHERE est_ap_paterno LIKE '%ís'
		AND est_carrera = 'LISC';

# Borrar estudiantes de la carrera de LIME, LICE o LIAD cuyo correo termine en el string 'gmail.com'
DELETE FROM estudiante
	WHERE (est_carrera = 'LIME' OR est_carrera = 'LICE' OR est_carrera = 'LIAD')
		AND est_correo LIKE '%gmail.com';
*/


# 4. ACTUALIZACIÓN
# Modificar datos en la BD de conferencias:

# Cambiar la carrera de un estudiante cualquiera con un id específico (dado por ti)
UPDATE estudiante
	SET est_carrera = 'LISC'
    WHERE est_id = 4;

# Cambiar la carrera a LISSCC para todos los estudiantes de la carrera LISC
UPDATE estudiante
	SET est_carrera = 'LISSCC'
    WHERE est_carrera = 'LISC';

# Incrementar en 1 semana la fecha de los eventos de mayo que estén a las 10.00h
UPDATE evento
	SET eve_fecha = ADDDATE(eve_fecha, 7)
    WHERE eve_fecha BETWEEN '2023-05-01' AND '2023-05-31'
		AND eve_hora = '00:10:00';

# Cambiar el nombre del ponente para todos los eventos de un ponente cualquiera (dado por ti)
UPDATE evento
	SET eve_ponente = 'Consejería Educativa'
    WHERE eve_ponente = 'Erandi Solorio Farfán';

# Disminuir en 15 minutos todos los eventos de junio que estén entre las 14:00h y 15:00h
UPDATE evento
	SET eve_duracion = (eve_duracion - 15)
    WHERE eve_fecha BETWEEN '2023-06-01' AND '2023-06-30'
		AND eve_hora BETWEEN '14:00:00' AND '15:00:00';

# Aumentar en 15 minutos la hora de llegada de los estudiantes para un evento cualquiera con un id específico (dado por ti).
UPDATE asistencia
	SET asi_hora_llegada = ADDTIME(asi_hora_llegada, '00:15:00')
    WHERE asi_eve_id = 2;
    
    
# 5. CONSULTAS 1
# Consultar datos en la BD de conferencias:

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes de la carrera 'LISC'.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS est_nombre_completo
	FROM estudiante
    WHERE est_carrera = 'LISC';

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) y el correo de los estudiantes de la carrera 'LICE' cuyo correo termine con el string 'ugto.mx' y cuyo nombre contenga el string 'Juan'.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS est_nombre_completo, est_correo
	FROM estudiante
    WHERE est_carrera = 'LICE'
		AND est_correo LIKE '%ugto.mx'
        AND est_nombre LIKE '%Juan%';
    
# Recuperar todos los atributos de los eventos que tenga una duración entre 60 y 90 minutos.
SELECT *
	FROM evento
    WHERE eve_duracion BETWEEN 60 AND 90;
    
# Recuperar todos los atributos de los eventos que tenga una duración de 30, 60 o 90 minutos en el mes de mayo.
SELECT *
	FROM evento
    WHERE eve_duracion IN (30, 60, 90)
		AND eve_fecha BETWEEN '2023-05-01' AND '2023-05-30';

# Recuperar el nombre, la fecha y la hora de los eventos cuyo ponente contenga el string 'Luis', que sean del mes de junio y que sean de horas entre las 10.00h y las 13.00h.
SELECT eve_nombre, eve_fecha, eve_hora
	FROM evento
    WHERE eve_ponente LIKE '%Luis%'
		AND eve_fecha BETWEEN '2023-06-01' AND '2023-06-30'
        AND eve_hora BETWEEN '10:00:00' AND '13:00:00';

# Recuperar el nombre, la fecha y la hora de los eventos que tengan en su nombre el string 'sociedad' y que sean a las 10.00h o a las 14.00h.
SELECT eve_nombre, eve_fecha, eve_hora
	FROM evento
    WHERE eve_nombre LIKE '%sociedad%'
        AND eve_hora BETWEEN '10:00:00' AND '14:00:00';
      
# CROSS JOIN

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo, asistencia.asi_eve_id, asistencia.asi_hora_llegada
	FROM estudiante, asistencia
    WHERE estudiante.est_id = asistencia.asi_est_id;
        
# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento, pero solo para los estudiantes de la carrera de 'LIME' cuyo correo termine en '@gmail.com'.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo, asistencia.asi_eve_id, asistencia.asi_hora_llegada
	FROM estudiante, asistencia
    WHERE estudiante.est_id = asistencia.asi_est_id
		AND estudiante.est_carrera = 'LIME'
        AND estudiante.est_correo LIKE '%@gmail.com';
    
# Recuperar el nombre, la fecha y la hora de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento, asistencia
    WHERE evento.eve_id = asistencia.asi_eve_id;
        
# Recuperar el nombre, la fecha y la hora de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno, pero solo para los eventos de junio con horas de 10.00h o 13.00h
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento, asistencia
    WHERE evento.eve_id = asistencia.asi_eve_id
		AND evento.eve_fecha BETWEEN '2023-06-01' AND '2023-06-30'
        AND evento.eve_hora IN ('10:00:00', '13:00:00');
       

# 6. CONSULTAS 2 | ORDER BY y LIMIT
# Consultar datos en la BD de conferencias:

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes de la carrera 'LISC'. Devolver el resultado ordenado por la concatenación de forma ascendente.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS nombre_completo
	FROM estudiante
    WHERE est_carrera = 'LISC' 
    ORDER BY nombre_completo ASC;

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno), la carrera y el correo de los estudiantes cuyo correo termine con el string 'ugto.mx' y cuyo nombre contenga el string 'Juan'. Devolver el resultado ordenado primero por la carrera de forma ascendente y luego por el correo de forma descendente. Devolver solo los 5 primeros registros.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS nombre_completo, est_carrera, est_correo
	FROM estudiante
    WHERE est_correo LIKE '%@ugto.com'
		AND est_nombre LIKE '%Juan%'
    ORDER BY est_carrera ASC, est_correo DESC
    LIMIT 5;
    
# Recuperar todos los atributos de los eventos que tenga una duración entre 60 y 90 minutos, y que inicien entre las 10.00 y las 14.00h. Devolver el resultado ordenado por hora de forma ascendente. Devolver solo 4 registros a partir de la posición 2.
SELECT *
	FROM evento
	WHERE eve_duracion BETWEEN 60 AND 90
		AND eve_hora BETWEEN '10:00:00' AND '14:00:00'
	ORDER BY eve_hora ASC
    LIMIT 2, 4;
    
# Recuperar el nombre, la fecha y la hora de los eventos cuyo ponente contenga el string 'Luis' o el string 'Pedro', que sean de los mes de mayo o junio y que sean de horas entre las 10.00h y las 13.00h. Devolver el resultado ordenado primero por fecha de forma ascendente y luego por hora de forma ascendente. Devolver solo los primeros 3 registros.
SELECT eve_nombre, eve_fecha, eve_hora
	FROM evento
    WHERE (eve_ponente LIKE '%Luis%' OR eve_ponente LIKE '%Pedro%')
		AND MONTH(eve_fecha) IN ('05', '06')
        AND eve_hora BETWEEN '10:00:00' AND '13:00:00'
        ORDER BY eve_fecha ASC, eve_hora ASC
        LIMIT 3;

# Recuperar todos los atributos de la tabla asistencia, para las horas de llegada entre las 09.00h y las 11.00h. Devolver el resultado ordenado primero por el id del evento de forma descendente y luego por la hora de llegada de forma ascendente.
SELECT *
	FROM asistencia
    WHERE asi_hora_llegada BETWEEN '09:00:00' AND '11:00:00'
    ORDER BY asi_eve_id DESC, asi_hora_llegada ASC;
    
# CROOS JOIN

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes, junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento. Devolver el resultado ordenado primero por carrera de forma ascendente y luego por la concatenación de forma ascendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_eve_id, asistencia.asi_hora_llegada
	FROM estudiante, asistencia
    WHERE estudiante.est_id = asistencia.asi_est_id
    ORDER BY estudiante.est_carrera ASC, nombre_completo ASC;

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento, pero solo para los estudiantes cuyo nombre tenga el string 'Juan' y las horas de llegada sean entre las 09.00h y las 13.00h. Devolver el resultado ordenado por hora de llegada de forma ascendente. Devolver solo 5 registros a partir de la posición 4.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_eve_id, asistencia.asi_hora_llegada
	FROM estudiante, asistencia
    WHERE estudiante.est_id = asistencia.asi_est_id
		AND estudiante.est_nombre LIKE '%Juan%'
        AND asistencia.asi_hora_llegada BETWEEN '09:00:00' AND '13:00:00'
    ORDER BY asistencia.asi_hora_llegada ASC
    LIMIT 4, 5;
    
# Recuperar el nombre, la fecha, la hora, la duración y el ponente de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno, pero solo para los eventos con duración entre 45 y 60 minutos. Devolver el resultado ordenado primero por duración de forma ascendente y luego por fecha de forma descendente. Devolver solo los primeros 5 registros.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_duracion, evento.eve_ponente, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento, asistencia
    WHERE evento.eve_id = asistencia.asi_eve_id
		AND evento.eve_duracion BETWEEN 45 AND 60
	ORDER BY evento.eve_duracion ASC, evento.eve_fecha DESC
    LIMIT 5;

# Recuperar el nombre, la fecha, la hora, la duración y el ponente de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno, pero solo para los eventos cuyo ponente tenga el string 'luis' o 'perez', y para las horas de llegada entre las 09.00 y las 13.00h. Devolver el resultado ordenado por hora de llegada de forma ascendente. Devolver solo los primeros 5 registros.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_duracion, evento.eve_ponente, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento, asistencia
    WHERE evento.eve_id = asistencia.asi_eve_id
		AND (evento.eve_ponente LIKE '%Luis%' OR evento.eve_ponente LIKE '%Pérez%')
        AND asistencia.asi_hora_llegada BETWEEN '09:00:00' AND '13:00:00'
	ORDER BY asistencia.asi_hora_llegada ASC
    LIMIT 5;
    
# Recuperar el nombre, la fecha, la hora y el ponente de los eventos; la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes; y la hora de llegada de los estudiantes que asistieron a cada evento. Solo para los eventos realizados en mayo y junio. Devolver el resultado ordenado primero por carrera de forma ascendente y luego por fecha del evento de forma descendente.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_ponente, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_hora_llegada
	FROM evento, estudiante, asistencia
    WHERE ((evento.eve_id = asistencia.asi_eve_id) AND (estudiante.est_id = asistencia.asi_est_id))
		AND MONTH(eve_fecha) IN ('05', '06')
	ORDER BY estudiante.est_carrera ASC, evento.eve_fecha desc;


# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT) ORDER BY, LIMIT
# Consultar datos en la BD de conferencias:

# Recuperar la concatenación de (nombre, apellido paterno, apellido materno), la carrera y el correo de los estudiantes, junto con el id del evento y la hora de llegada a todos los eventos que haya asistido cada estudiante. Incluir a los estudiantes que no hayan asistido a eventos.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, estudiante.est_correo, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM estudiante
    LEFT JOIN asistencia
		ON estudiante.est_id = asistencia. asi_est_id;

# Recuperar el nombre, fecha, hora y ponente de los eventos, junto con el id del estudiante y la hora llegada de todos los estudiantes que hayan asistido a cada evento. Incluir los eventos que no tengan asistencia.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_ponente, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento
    LEFT JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id;

# Recuperar el nombre, fecha, hora y ponente de los eventos; la concatenación de (nombre, apellido paterno, apellido materno), la carrera y el correo de los estudiantes; y la hora de llegada de cada estudiante a cada evento. Incluir los eventos que no tengan asistencia.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_ponente, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, estudiante.est_correo, asistencia.asi_hora_llegada
	FROM evento
    LEFT JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id
	INNER JOIN estudiante
		ON asistencia. asi_est_id = estudiante.est_id;

# Recuperar el nombre, fecha, hora y ponente de los eventos; la concatenación de (nombre, apellido paterno, apellido materno), la carrera y el correo de los estudiantes; y la hora de llegada de cada estudiante a cada evento. Incluir los estudiantes que no hayan asistido a eventos.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_ponente, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, estudiante.est_correo, asistencia.asi_hora_llegada
	FROM evento
    INNER JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id
	RIGHT JOIN estudiante
		ON asistencia. asi_est_id = estudiante.est_id;
	
# ORDER BY, LIMIT

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes, junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento. Devolver el resultado ordenado primero por carrera de forma ascendente y luego por la concatenación de forma ascendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM estudiante
    INNER JOIN asistencia
		ON estudiante.est_id = asistencia. asi_est_id
	ORDER BY estudiante.est_carrera ASC, nombre_completo ASC;

# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes junto con los ids de los eventos a los que asistieron y la hora de llegada a cada evento, pero solo para los estudiantes cuyo nombre tenga el string 'Juan' y las horas de llegada sean entre las 09.00h y las 13.00h. Devolver el resultado ordenado por hora de llegada de forma ascendente. Devolver solo 5 registros a partir de la posición 4.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM estudiante
    INNER JOIN asistencia
		ON estudiante.est_id = asistencia. asi_est_id
	WHERE estudiante.est_nombre LIKE '%Juan%'
		AND asistencia.asi_hora_llegada BETWEEN '09:00:00' AND '13:00:00'
	ORDER BY asistencia.asi_hora_llegada ASC
    LIMIT 4, 5;

# Recuperar el nombre, la fecha, la hora, la duración y el ponente de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno, pero solo para los eventos con duración entre 45 y 60 minutos. Devolver el resultado ordenado primero por duración de forma ascendente y luego por fecha de forma descendente. Devolver solo los primeros 5 registros.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_duracion, evento.eve_ponente, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento
    INNER JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id
	WHERE evento.eve_duracion BETWEEN 45 AND 60
    ORDER BY evento.eve_duracion ASC, evento.eve_fecha DESC
    LIMIT 5;

# Recuperar el nombre, la fecha, la hora, la duración y el ponente de los eventos junto con los ids de los estudiantes que asistieron a cada evento y la hora de llegada de cada uno, pero solo para los eventos cuyo ponente tenga el string 'luis' o 'perez', y para las horas de llegada entre las 09.00 y las 13.00h. Devolver el resultado ordenado por hora de llegada de forma ascendente. Devolver solo los primeros 5 registros.
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_duracion, evento.eve_ponente, asistencia.asi_est_id, asistencia.asi_hora_llegada
	FROM evento
    INNER JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id
	WHERE (evento.eve_ponente LIKE '%Luis%' OR evento.eve_ponente LIKE '%Pérez%')
		AND asistencia.asi_hora_llegada BETWEEN '09:00:00' AND '13:00:00'
    ORDER BY asistencia.asi_hora_llegada ASC
    LIMIT 5;

# Recuperar el nombre, la fecha, la hora y el ponente de los eventos; la concatenación de (nombre, apellido paterno y apellido materno) y la carrera de los estudiantes; y la hora de llegada de los estudiantes que asistieron a cada evento. Solo para los eventos realizados en mayo y junio. Devolver el resultado ordenado primero por carrera de forma ascendente y luego por fecha del evento de forma descendente.	
SELECT evento.eve_nombre, evento.eve_fecha, evento.eve_hora, evento.eve_ponente, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_carrera, asistencia.asi_hora_llegada
	FROM evento
    INNER JOIN asistencia
		ON evento.eve_id = asistencia. asi_eve_id
	INNER JOIN estudiante
		ON asistencia. asi_est_id = estudiante.est_id
	WHERE MONTH(evento.eve_fecha) IN ('05', '06')
	ORDER BY estudiante.est_carrera ASC, asistencia.asi_hora_llegada DESC;


# 8. CONSULTAS 4 | GROUP BY (CON HAVING)
# Consultar datos en la BD de conferencias:

# Recuperar el número de estudiantes por carrera.
SELECT est_carrera, COUNT(est_carrera) AS numero_estudiantes
	FROM estudiante
    GROUP BY est_carrera;

# Recuperar el número de estudiantes por apellido paterno.
SELECT est_ap_paterno, COUNT(est_ap_paterno) AS numero_estudiantes
	FROM estudiante
    GROUP BY est_ap_paterno;

# Recuperar el número de estudiantes por la combinación de apellido paterno y carrera.
SELECT CONCAT(est_ap_paterno, '	', est_carrera) AS ap_paterno_carrera, COUNT(*) AS numero_estudianres
	FROM estudiante
    GROUP BY ap_paterno_carrera;
    
# Recuperar el número de eventos por la combinación de año y mes.
SELECT CONCAT(YEAR(eve_fecha), '	', MONTH(eve_fecha)) AS anio_mes, COUNT(*) AS numero_eventos
	FROM evento
    GROUP BY anio_mes;
    
# Recuperar el número de eventos por la combinación de mes y hora, pero solo cuando haya 1 o 3 eventos.
SELECT CONCAT(MONTH(eve_fecha), '	', eve_hora) AS mes_hora, COUNT(*) AS numero_eventos
	FROM evento
    GROUP BY mes_hora
    HAVING numero_eventos IN(1, 3);

# Recuperar el número de eventos por ponente.
SELECT eve_ponente, COUNT(eve_ponente) AS numero_eventos
	FROM evento
    GROUP BY eve_ponente;
    
# Recuperar el promedio de duración y la duración mínima y máxima de los eventos agrupados por la combinación de año y mes.
SELECT CONCAT(YEAR(eve_fecha), '	', MONTH(eve_fecha)) AS anio_mes, AVG(eve_duracion) AS duracion_promedio, MIN(eve_duracion) AS duracion_minima, MAX(eve_duracion) AS duracion_maxima
	FROM evento
    GROUP BY anio_mes;
    
# Recuperar el promedio de la duración y la duración mínima y máxima de los eventos agrupados por las cinco primeras letras del nombre del evento.
SELECT CONCAT(SUBSTR(eve_nombre, 1, 5)) AS primeras_5_letras, AVG(eve_duracion) AS duracion_promedio, MIN(eve_duracion) AS duracion_minima, MAX(eve_duracion) AS duracion_maxima
	FROM evento
    GROUP BY primeras_5_letras;
    
# Recuperar el número de asistencias por hora de llegada.
SELECT asi_hora_llegada, COUNT(asi_hora_llegada) AS numero_asistencias
	FROM asistencia
    GROUP BY asi_hora_llegada;