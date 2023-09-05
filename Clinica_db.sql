-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema clinica_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema clinica_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `clinica_db` DEFAULT CHARACTER SET utf8mb3 ;
USE `clinica_db` ;

-- -----------------------------------------------------
-- Table `clinica_db`.`Paciente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_db`.`Paciente` (
  `pac_id` INT NOT NULL AUTO_INCREMENT,
  `pac_nombre` VARCHAR(50) NOT NULL,
  `pac_correo` VARCHAR(50) NULL DEFAULT NULL,
  `pac_telefono` BIGINT NOT NULL,
  
  PRIMARY KEY (`pac_id`),
  
  UNIQUE INDEX `uni_correo` (`pac_correo` ASC) INVISIBLE,
  
  INDEX `idx_nombre` (`pac_nombre` ASC) INVISIBLE)

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinica_db`.`Medico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_db`.`Medico` (
  `med_id` INT NOT NULL AUTO_INCREMENT,
  `med_nombre` VARCHAR(60) NOT NULL,
  `med_especialidad` VARCHAR(30) NOT NULL,
  `med_consultorio` VARCHAR(4) NULL DEFAULT NULL COMMENT 'Indicar sólo el número del consultorio, p.ej. ',
  `med_honorarios` DECIMAL(7,2) NOT NULL COMMENT 'Cantidad en pesos mexicanos',

  PRIMARY KEY (`med_id`),

  UNIQUE INDEX `uni_nombre_consultorio` (`med_nombre` ASC, `med_consultorio` ASC) VISIBLE,

  INDEX `idx_nombre` (`med_nombre` ASC) INVISIBLE,
  INDEX `idx_especialidad` (`med_especialidad` ASC) INVISIBLE)

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinica_db`.`Cita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_db`.`Cita` (
  `cit_id` INT NOT NULL AUTO_INCREMENT,
  `cit_med_id` INT NOT NULL,
  `cit_pac_id` INT NOT NULL,
  `cit_fecha_hora` DATETIME NOT NULL,
  `cit_diagnostico` TINYTEXT NULL,

  PRIMARY KEY (`cit_id`),

  UNIQUE INDEX `cit_fecha_hora_UNIQUE` (`cit_fecha_hora` ASC) VISIBLE,

  INDEX `fk_medico_cita_idx` (`cit_med_id` ASC) VISIBLE,
  INDEX `fk_paciente_cita_idx` (`cit_pac_id` ASC) VISIBLE,

  CONSTRAINT `fk_paciente_cita`
    FOREIGN KEY (`cit_pac_id`)
    REFERENCES `clinica_db`.`Paciente` (`pac_id`)

    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT `fk_medico_cita`
    FOREIGN KEY (`cit_med_id`)
    REFERENCES `clinica_db`.`Medico` (`med_id`)

    ON DELETE RESTRICT
    ON UPDATE RESTRICT)

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*
# 1. MODIFICACIONES
# En la base de la clínica:

# Crea un índice para la especialidad en la tabla medico.
ALTER TABLE medico 
	ADD INDEX idx_especialidad (med_especialidad);

# Crea un atributo de clinica al final de la tabla medico con tipo VARCHAR(30) NOT NULL.
ALTER TABLE medico 
	ADD med_clinica VARCHAR (30) NOT NULL;

# Haz que la combinación de los atributos de nombre y clinica en la tabla medico sea única.
ALTER TABLE medico 
	ADD UNIQUE uni_nombre_clinica (med_nombre, med_clinica);

# Crea un atributo de dirección antes del atributo de teléfono en la tabla paciente con tipo VARCHAR(60).
ALTER TABLE paciente 
	ADD pac_direccion VARCHAR (60) AFTER pac_correo;

# Elimina el atributo de honorarios en la tabla medico.
ALTER TABLE medico 
	DROP COLUMN med_honorarios;

# Crea un atributo para el costo de la consulta en la tabla cita de tipo DECIMAL(8,2) NOT NULL, antes de la columna de fecha y hora
ALTER TABLE cita 
	ADD cit_costo DECIMAL (8,2) NOT NULL AFTER cit_pac_id;

# Cambia el nombre y tipo del atributo pac_telefono en la tabla paciente para que sea pac_tel CHAR(10).
ALTER TABLE paciente 
	CHANGE pac_telefono pac_tel CHAR(10);
*/


# 2. INSERCIÓN
# Insertar datos en la BD de clínica:

# 4 pacientes con teléfonos de cada ciudad: Irapuato, Salamanca y León

INSERT INTO paciente (pac_nombre, pac_correo, pac_telefono)
	VALUES ('Keyla Leilani Anguiano Cabrera', 'kl.anguianocabrera@ugto.mx', 4622650412),
		   ('Jean David García Jaime', 'jd.garciajaime@ugto.mx', 4621136579),
           ('Diego Díaz Segovia', 'd.diazsegovia@ugto.mx', 4621924779),
		   ('Erick Armando López Ramírez', 'ea.lopezramirez@ugto.mx', 4623333133);

INSERT INTO paciente (pac_nombre, pac_correo, pac_telefono)
	VALUES ('María Guadalupe Prieto Pantoja', 'mg.prietopantoja@ugto.mx', 4641034539),
		   ('Fernando Romero Torres', 'f.romerotorres@ugto.mx', 4641080308),
           ('Pedro Ángel Lopéz Vargas', 'pa.lopezvargas@ugto.mx', 4642295961),
		   ('Jonathan Esaú Arriaga Saldaña', 'je.arriagasaldaña@ugto.mx', 4641917579);
           
INSERT INTO paciente (pac_nombre, pac_correo, pac_telefono)
	VALUES ('Jonathan Uriel Pérez Vargas', 'ju.perezvargas@ugto.mx', 4771979706),
		   ('Nicholas Andrew Guido Arroyo', 'na.guidoarroyo@ugto.mx', 4771503950),
		   ('Fabian Alexis Segoviano Balandran', 'fa.segovianobalandran@ugto.mx', 4772522383),
		   ('Perla Yareli Camacho Sanchéz', 'py.camachosanchez@ugto.mx', 4772111752);
           
# 3 médicos de cada especialidad: general, ginecólogo, urólogo, oncólogo y dermatólogo, con honorarios entre 500 y 1500

INSERT INTO medico (med_nombre, med_especialidad, med_consultorio, med_honorarios)
	VALUES ('Meredith Eleonor Grey', 'General', 1, 1500),
		   ('Miranda Bailey', 'General', 2, 1000),
           ('Jo Wilson', 'General', 3, 500);
		
INSERT INTO medico (med_nombre, med_especialidad, med_consultorio, med_honorarios)
	VALUES ('Adison Forbes Montgomery', 'Ginecología', 4, 1500),
		   ('Carina de Luca', 'Ginecología', 5, 1000),
		   ('Lexie Grey', 'Ginecología', 6, 500);
           
INSERT INTO medico (med_nombre, med_especialidad, med_consultorio, med_honorarios)
	VALUES ('Preston Burke', 'Urología', 7, 1500),
		   ('Owen Hunt', 'Urología', 8, 1000),
		   ('Alex Karev', 'Urología', 9, 500);
           
INSERT INTO medico (med_nombre, med_especialidad, med_consultorio, med_honorarios)
	VALUES ('Derek Shepherd', 'Oncología', 10, 1500),
		   ('Cristina Yang', 'Oncología', 11, 1000),
		   ('Amelia Shepherd', 'Oncología', 12, 500);
           
INSERT INTO medico (med_nombre, med_especialidad, med_consultorio, med_honorarios)
	VALUES ('Mark Sloan', 'Dermatología', 13, 1500),
		   ('Jackson Avery', 'Dermatología', 14, 1000),
		   ('George O´Malley', 'Dermatología', 15, 500);
           
# 2 citas para cada médico que sean en los meses abril, mayo o junio, 1 entre las 08-12h y 1 entre las 16-20h

INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (1, 1, '2023-04-02 08:00:00', 'Faringitis'),
		   (1, 2, '2023-05-04 16:00:00', 'Tuberculosis');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (2, 3, '2023-06-06 08:30:00', 'Sarampión'),
		   (2, 4, '2023-04-08 16:30:00', 'Varicela');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (3, 5, '2023-05-10 09:00:00', 'Rotavirus'),
		   (3, 6, '2023-06-12 17:00:00', 'Amigdalitis');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (4, 4, '2023-04-14 09:30:00', 'Cistitis'),
		   (4, 12, '2023-05-16 17:30:00', 'Endometriosis');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (5, 4, '2023-06-18 10:00:00', 'Infección'),
		   (5, 12, '2023-04-20 18:00:00', 'Mioma uterino');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (6, 4, '2023-05-22 10:30:00', 'Quistes'),
		   (6, 12, '2023-06-24 18:30:00', 'Disminorrea');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (7, 7, '2023-04-26 11:00:00', 'Infección urinaria'),
		   (7, 8, '2023-05-28 19:00:00', 'Cálculos renales');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (8, 9, '2023-06-30 11:30:00', 'Hiperplasia prostática'),
		   (8, 10, '2023-04-02 19:30:00', 'Uretritis');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (9, 11, '2023-05-04 12:00:00', 'Hematuria'),
		   (9, 12, '2023-06-06 20:00:00', 'Nefritis');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (10, 1, '2023-04-08 08:00:00', 'Tumor cerebral'),
		   (10, 2, '2023-05-10 16:00:00', 'Glioma');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (11, 3, '2023-06-12 08:30:00', 'Cáncer de páncreas'),
		   (11, 4, '2023-04-14 16:30:00', 'Cancer de pulmón');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (12, 5, '2023-05-16 09:00:00', 'Cáncer de ovario'),
		   (12, 6, '2023-06-18 17:00:00', 'Cáncer de riñón');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (13, 7, '2023-04-20 09:30:00', 'Sarpulllido'),
		   (13, 8, '2023-05-22 17:30:00', 'Eccema');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (14, 9, '2023-06-24 10:00:00', 'Psoriasis'),
		   (14, 10, '2023-04-26 18:00:00', 'Impétigo');
           
INSERT INTO cita (cit_med_id, cit_pac_id, cit_fecha_hora, cit_diagnostico)
	VALUES (15, 11, '2023-05-28 10:30:00', 'Urticaria'),
		   (15, 12, '2023-06-30 18:30:00', 'Dermatitis seborreica');


/*
# 3. BORRADO
# Borrar datos en la BD de clínica:

# Borrar las citas de un paciente cualquiera con id específico (dado por ti) y un médico cualquiera con id específico (dado por ti).
DELETE FROM cita
	WHERE cit_pac_id = 3
		AND cit_med_id = 2;

# Borrar las citas del mes de abril para un médico cualquiera con id específico. *** Revisar
DELETE FROM cita
	WHERE cit_fecha_hora BETWEEN '2023-04-01 00:00:00' AND '2023-04-30 23:59:59'
		AND cit_med_id = 2;

# Borrar médicos dermatólogos y oncólogos con honorarios entre 1000 y 1300 pesos
DELETE FROM cita
	WHERE cit_med_id BETWEEN 10 AND 15;
        
DELETE FROM medico
	WHERE (med_especialidad = 'Dermatología' OR med_especialidad = 'Oncología')
		AND med_honorarios BETWEEN 1000 AND 1300;

# Borrar a un médico cualquiera con un consultorio específico (dado por ti)
DELETE FROM medico
	WHERE med_consultorio = 2;

# Borrar pacientes cuyo nombre incluya el string 'gonzalez' y cuyo correo termine en el string '@gmail.com'
DELETE FROM paciente
	WHERE pac_nombre LIKE '%Gonzalez%'
		AND pac_correo LIKE '%@gmail.com';

# Borrar pacientes cuyo teléfono inicie con el string '464' y cuyo nombre inicie con el string 'juan'
DELETE FROM paciente
	WHERE pac_telefono LIKE '464%'
		AND pac_nombre LIKE 'Juan%';
*/


# 4. ACTUALIZACIÓN
# Modificar datos en la BD de clínica

# Cambiar el teléfono y el correo de un paciente cualquiera con un nombre específico (dado por ti)
UPDATE paciente
	SET pac_telefono = '4776804307', pac_correo = 'keyla_anguiano@hotmail.com'
	WHERE pac_nombre = 'Keyla Leilani Anguiano Cabrera';

# Cambiar el nombre y el correo de un paciente cualquiera con un id específico (dado por ti)
UPDATE paciente
	SET pac_telefono = '4621136579', pac_correo = 'jean_garcia@hotmail.com'
	WHERE pac_id = 2;
    
# Incrementar en 100 los honorarios de todos los oncólogos que cobren menos de 1000
UPDATE medico
	SET med_honorarios = (med_honorarios + 100)
    WHERE med_especialidad = 'Oncología'
		AND med_honorarios < 1000;

# Cambiar el consultorio, la especialidad y los honorarios de un médico cualquiera con nombre específico (dado por ti)
UPDATE medico
	SET med_consultorio = 16, med_especialidad = 'Neurología', med_honorarios = 2000
    WHERE med_nombre = 'Derek Shepherd';

# Cambiar las citas de mayo de un médico cualquiera con id específico (dado por ti) para 7 días después
UPDATE cita
	SET cit_fecha_hora = ADDDATE(cit_fecha_hora, 7)
    WHERE cit_fecha_hora BETWEEN '2023-05-01 00:00:00' AND '2023-05-31 23:59:59'
		AND cit_med_id = 1;
    
# Cambiar todas las citas una hora después para un médico cualquiera y un paciente cualquiera con ids específicos (dados por ti)
UPDATE cita
	SET cit_fecha_hora = ADDTIME(cit_fecha_hora, '01:00:00')
    WHERE cit_med_id = 1
		AND cit_pac_id = 1;
    
    
# 5. CONSULTAS 1   
# Consultar datos en la BD de Clínica:

# Recuperar todos los atributos de los pacientes que tengan en su nombre el string 'Jiménez'.
SELECT *
	FROM paciente
    WHERE pac_nombre LIKE '%Jiménez%';
    
# Recuperar todos los atributos de los pacientes cuyos teléfonos inicien con '464' o '462'.
SELECT *
	FROM paciente
    WHERE (pac_telefono LIKE '464%' OR pac_telefono LIKE '462%');
    
# Recuperar todos los atributos de los pacientes cuyos teléfonos inicien con '464' y su correo termine con '@outlook.com' o '@gmail.com'.
SELECT *
	FROM paciente
    WHERE pac_telefono LIKE '464%'
		AND (pac_correo LIKE '%@outlook.com' OR pac_correo LIKE '%@gmail.com');
    
# Recuperar el nombre, el consultorio y los honorarios de los médicos que tengan especialidad en 'Dermatología'.
SELECT med_nombre, med_consultorio, med_honorarios
	FROM medico
    WHERE med_especialidad = 'Dermatología';

# Recuperar el nombre, el consultorio, la especialidad y los honorarios de los médicos que cobren entre $800.00 y $1000.00.
SELECT med_nombre, med_consultorio, med_especialidad, med_honorarios
	FROM medico
    WHERE med_honorarios BETWEEN 800 AND 1000;
    
# Recuperar el nombre, el consultorio, la especialidad y los honorarios de los médicos que cobren menos o igual de $900.00 y sean de especialidad 'Ginecología' o 'Urología'.
SELECT med_nombre, med_consultorio, med_especialidad, med_honorarios
	FROM medico
    WHERE med_honorarios <= 900
		AND (med_especialidad = 'Ginecología' OR med_especialidad = 'Urología');
    
# Recuperar el nombre, el consultorio, la especialidad y los honorarios de los médicos que tengan en su nombre el string 'Salgado', cobren entre $300.00 y $700.00 y sean de especialidad 'General' u 'Oncología'.
SELECT med_nombre, med_consultorio, med_especialidad, med_honorarios
	FROM medico
    WHERE med_nombre LIKE '%Salgado%'
		AND med_honorarios BETWEEN 300 AND 700
		AND (med_especialidad = 'General' OR med_especialidad = 'Oncología');
        
# Recuperar el id del paciente, el id del médico y la fecha y hora de las citas entre abril y mayo.
SELECT cit_pac_id, cit_med_id, cit_fecha_hora
	FROM cita
    WHERE cit_fecha_hora BETWEEN '2023-04-01 00:00:00' AND '2023-05-31 23:59:59';
    
# Recuperar el id del paciente y la fecha y hora de las citas entre mayo y junio para un médico cualquiera con id específico (dado por ti).
SELECT cit_pac_id, cit_fecha_hora
	FROM cita
    WHERE cit_fecha_hora BETWEEN '2023-05-01 00:00:00' AND '2023-06-30 23:59:59'
		AND cit_med_id = 6;
    
# Recuperar el id del médico y la fecha y la hora de las citas de abril y junio para un paciente cualquiera con id específico (dado por ti).
SELECT cit_med_id, cit_fecha_hora
	FROM cita
    WHERE cit_fecha_hora BETWEEN '2023-04-01 00:00:00' AND '2023-06-30 23:59:59'
		AND cit_pac_id = 7;
    
# Recuperar la fecha y hora de las citas de abril y junio para un médico cualquiera con id específico (dado por ti) y para un paciente cualquiera con id específico (dado por ti).
SELECT cit_fecha_hora
	FROM cita
    WHERE cit_fecha_hora BETWEEN '2023-04-01 00:00:00' AND '2023-06-30 23:59:59'
		AND cit_pac_id = 6
        AND cit_med_id = 12;
        
# CROSS JOIN	

# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
	WHERE medico.med_id = cita.cit_med_id;

# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos, pero solo para los mUrologíaédico de especialidad 'Ginecología' o 'Urología'.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
	WHERE medico.med_id = cita.cit_med_id
		AND (medico.med_especialidad = 'Ginecología' OR medico.med_especialidad = 'Urología');
    
# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos, pero solo para los médico de especialidad 'Ginecología' o 'Urología', y con fechas de abril y junio.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
	WHERE medico.med_id = cita.cit_med_id
		AND (medico.med_especialidad = 'Ginecología' OR medico.med_especialidad = 'Urología')
        AND cita.cit_fecha_hora BETWEEN '2023-04-01 00:00:00' AND '2023-06-30 23:59:59';
        
# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos, pero solo para los médico de especialidad 'Dermatología', con fechas de mayo y junio y con honorarios mayores a $1000.00.	
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
	WHERE medico.med_id = cita.cit_med_id
		AND medico.med_especialidad = 'Dermatología'
        AND cita.cit_fecha_hora BETWEEN '2023-05-01 00:00:00' AND '2023-06-30 23:59:59'
        AND medico.med_honorarios > 1000;
        
# Recuperar el nombre, el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente, cita
    WHERE paciente.pac_id = cita.cit_pac_id;
    
# Recuperar el nombre, el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes que tengan en su nombre el string 'Aguilar'
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente, cita
    WHERE paciente.pac_id = cita.cit_pac_id
		AND paciente.pac_nombre LIKE '%Aguilar%';
    
# Recuperar el nombre, el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes que tengan en su nombre el string 'Gómez', y con fechas de mayo.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente, cita
    WHERE paciente.pac_id = cita.cit_pac_id
		AND paciente.pac_nombre LIKE '%Gómez%'
        AND cita.cit_fecha_hora BETWEEN '2023-05-01 00:00:00' AND '2023-05-31 23:59:59';
     

# 6. CONSULTAS 2 | ORDER BY y LIMIT          
# Consultar datos en la BD de Clínica

# Recuperar todos los atributos de los pacientes que tengan en su nombre el string 'Jiménez' o el string 'Hernández'. Devolver el resultado ordenado de forma ascendente por el teléfono.
SELECT *
	FROM paciente
    WHERE (pac_nombre LIKE '%Juan%' OR pac_nombre LIKE '%Hernández%')
    ORDER BY pac_telefono ASC;
    
# Recuperar todos los atributos de los pacientes cuyos teléfonos inicien con '464' o con '461' y su correo termine con '@outlook.com' o '@gmail.com'. Devolver el resultado ordenado de forma descendente por el correo. Devolver solo 4 registros a partir de la posición 2.
SELECT *
	FROM paciente
    WHERE (pac_telefono LIKE '464%' OR pac_telefono LIKE '461%')
		AND (pac_correo LIKE '%@outlook.com' OR pac_correo LIKE '%@gmail.com')
    ORDER BY pac_correo ASC
    LIMIT 2, 4;
    
# Recuperar el nombre, el consultorio y los honorarios de los médicos que tengan especialidad en 'Dermatología', 'Ginecología' o 'Traumatología'. Devolver el resultado ordenado por nombre de forma descendente. Devolver solo los primeros 5 registros.
SELECT med_nombre, med_consultorio, med_honorarios
	FROM medico
    WHERE med_especialidad IN ('Dermatología', 'Ginecología', 'Traumatología')
    ORDER BY med_nombre DESC
    LIMIT 5;
    
# Recuperar el nombre, el consultorio, la especialidad y los honorarios de los médicos que cuyo nombre termine en 'Pérez', 'Jiménez' o 'Salgado', cobren entre $300.00 y $1200.00 y sean de especialidad 'General', 'Oncología', 'Oftalmología' o 'Urología'. Devolver el resultado ordenado primero por especialidad de forma descendente y luego por nombre de forma ascendente. Devolver solo 5 registros a partir de la posición 3.
SELECT med_nombre, med_consultorio, med_especialidad, med_honorarios
	FROM medico
    WHERE (med_nombre LIKE '%Pérez' OR med_nombre LIKE '%Jiménez' OR med_nombre LIKE '%Salgado')
		AND med_honorarios BETWEEN 300 AND 1200
        AND med_especialidad IN ('General', 'Oncología', 'Oftalmología', 'Urología')
    ORDER BY med_especialidad DESC, med_nombre ASC
    LIMIT 3, 5;
    
# Recuperar el id del médico, y la fecha y la hora de las citas de abril y junio para los pacientes con ids entre 1 y 10. Devolver el resultado ordenado ordenado primero por fecha y hora de forma descendente y luego por id del médico de forma ascendente.
SELECT cit_med_id, cit_fecha_hora
	FROM cita
    WHERE MONTH(cit_fecha_hora) IN ('04', '06')
		AND cit_pac_id BETWEEN 1 AND 10
	ORDER BY cit_fecha_hora DESC, cit_med_id ASC;

# CROSS JOIN

# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos. Devolver el resultado ordenado por nombre del médico de forma ascendente.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
    WHERE medico.med_id = cita.cit_med_id
    ORDER BY medico.med_nombre ASC;
    
# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos, pero solo para los médico cuyo nombre tenga los strings 'Hérnandez', 'López' o 'Gómez', de especialidad 'Ginecología', 'Urología' o 'Dermatología', y con fechas de entre abril y junio. Devolver el resultado ordenado por especialidad de forma ascendente. Devolver solo los primeros 10 registros.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico, cita
    WHERE medico.med_id = cita.cit_med_id
		AND (med_nombre LIKE '%Hérnandez%' OR med_nombre LIKE '%López%' OR med_nombre LIKE '%Gómez%')
        AND med_especialidad IN ('Ginecología', 'Urología', 'Dermatología')
        AND MONTH(cit_fecha_hora) IN ('04', '05', '06')
    ORDER BY medico.med_especialidad ASC
    LIMIT 10;
    
# Recuperar el nombre y el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes que tengan en su nombre el string 'Aguilar' o 'Méndez' y cuyo correo termine en el string 'gmail.com'. Devolver el resultado ordenado primero por el id del médico de forma ascendente y después por el nombre del paciente de forma descendente.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente, cita
    WHERE paciente.pac_id = cita.cit_pac_id
		AND (paciente.pac_nombre LIKE '%Aguilar%' OR paciente.pac_nombre LIKE '%Méndez%' OR paciente.pac_nombre LIKE '%Gómez%')
        AND paciente.pac_correo LIKE '%gmail.com'
	ORDER BY cita.cit_med_id ASC, paciente.pac_nombre DESC;
        
# Recuperar el nombre y el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes cuyos teléfonos inicien con '464' o '442', y para citas con fechas entre enero y junio. Devolver el resultado ordenado por id del médico de forma ascendente. Devolver solo 5 registros a partir de la posición 3.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente, cita
    WHERE paciente.pac_id = cita.cit_pac_id
		AND (paciente.pac_telefono LIKE '464%' OR paciente.pac_telefono LIKE '442%')
        AND MONTH(cit_fecha_hora) BETWEEN '01'AND '06'
	ORDER BY cita.cit_med_id ASC
    LIMIT 3, 5;
    
# Recuperar el nombre, el teléfono y el correo de los pacientes; el nombre, el consultorio y los honorarios de los médicos; y la fecha y hora de la citas. Ordenar el resultado primero por fecha y hora de forma ascendente, y después por nombre del médico de forma ascendente.
SELECT paciente.pac_nombre, paciente.pac_telefono, paciente.pac_correo, medico.med_nombre, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora
	FROM paciente, medico, cita
    WHERE ((paciente.pac_id = cita.cit_pac_id) AND (medico.med_id = cita.cit_med_id))
	ORDER BY cita.cit_fecha_hora ASC, medico.med_nombre ASC;
    
    
# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT) ORDER BY, LIMIT
# Consultar datos en la BD de clínica

# Recuperar el nombre, el consultorio y la especialidad de cada médico, junto con la fecha y hora, y el id de los pacientes con los que ha tenido citas. Incluir los médicos que no han tenido citas.
SELECT medico.med_nombre, medico.med_consultorio, medico.med_especialidad, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico
    LEFT JOIN cita
		ON medico.med_id = cita.cit_med_id;

# Recuperar el nombre, el correo y el teléfono de los pacientes, junto con la fecha y hora y el id de los médicos con los que han tenido citas. Incluir los pacientes que no ha tenido citas.
SELECT paciente.pac_nombre, paciente.pac_correo, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente
    LEFT JOIN cita
		ON paciente.pac_id = cita.cit_pac_id;

# Recuperar el nombre, el consultorio, la especialidad y los honorarios de cada médico; la fecha y hora de sus citas; y el nombre, el correo y el teléfono de los pacientes de esas citas. Incluir los médicos que no han tenido citas.
SELECT medico.med_nombre, medico.med_consultorio, medico.med_especialidad, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id, paciente.pac_nombre, paciente.pac_correo, paciente.pac_telefono
	FROM medico
    LEFT JOIN cita
		ON medico.med_id = cita.cit_med_id
	INNER JOIN paciente
		ON cita.cit_pac_id = paciente.pac_id;

# Recuperar el nombre, el consultorio, la especialidad y los honorarios de cada médico; la fecha y hora de sus citas; y el nombre, el correo y el teléfono de los pacientes de esas citas. Incluir los pacientes que no han tenido citas.
SELECT medico.med_nombre, medico.med_consultorio, medico.med_especialidad, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id, paciente.pac_nombre, paciente.pac_correo, paciente.pac_telefono
	FROM medico
    INNER JOIN cita
		ON medico.med_id = cita.cit_med_id
	RIGHT JOIN paciente
		ON cita.cit_pac_id = paciente.pac_id;

# ORDER BY, LIMIT

# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos. Devolver el resultado ordenado por nombre del médico de forma ascendente.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico
    INNER JOIN cita
		ON medico.med_id = cita.cit_med_id
	ORDER BY medico.med_nombre ASC;

# Recuperar el nombre, la especialidad, el consultorio y los honorarios de los médicos, junto con la fecha y hora y el id del paciente de las citas de cada uno de los médicos, pero solo para los médico cuyo nombre tenga los strings 'Hérnandez', 'López' o 'Gómez', de especialidad 'Ginecología', 'Urología' o 'Dermatología', y con fechas de entre abril y junio. Devolver el resultado ordenado por especialidad de forma ascendente. Devolver solo los primeros 10 registros.
SELECT medico.med_nombre, medico.med_especialidad, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora, cita.cit_pac_id
	FROM medico
    INNER JOIN cita
		ON medico.med_id = cita.cit_med_id
	WHERE ((medico.med_nombre LIKE '%Hérnandez%') OR (medico.med_nombre LIKE '%López%') OR (medico.med_nombre LIKE '%Gómez%'))
		AND medico.med_especialidad IN ('Ginecología', 'Urología', 'Dermatología')
        AND MONTH(cita.cit_fecha_hora) BETWEEN '04' AND '06'
	ORDER BY medico.med_especialidad ASC
    LIMIT 10;

# Recuperar el nombre y el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes que tengan en su nombre el string 'Aguilar' o 'Méndez' y cuyo correo termine en el string 'gmail.com'. Devolver el resultado ordenado primero por el id del médico de forma ascendente y después por el nombre del paciente de forma descendente.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente
    INNER JOIN cita
		ON paciente.pac_id = cita.cit_pac_id
	WHERE ((paciente.pac_nombre LIKE '%Aguilar%') OR (paciente.pac_nombre LIKE '%Méndez%'))
		AND paciente.pac_correo LIKE '%gmail.com'
	ORDER BY cita.cit_med_id ASC, paciente.pac_nombre DESC;

# Recuperar el nombre y el telefono de los pacientes, junto con la fecha y hora y el id del médico de las citas de cada uno de los pacientes, pero solo para los pacientes cuyos teléfonos inicien con '464' o '442', y para citas con fechas entre enero y junio. Devolver el resultado ordenado por id del médico de forma ascendente. Devolver solo 5 registros a partir de la posición 3.
SELECT paciente.pac_nombre, paciente.pac_telefono, cita.cit_fecha_hora, cita.cit_med_id
	FROM paciente
    INNER JOIN cita
		ON paciente.pac_id = cita.cit_pac_id
	WHERE (paciente.pac_telefono LIKE '464%' OR paciente.pac_telefono LIKE '442%')
		AND MONTH(cit_fecha_hora) BETWEEN '01'AND '06'
	ORDER BY cita.cit_med_id ASC
    LIMIT 3, 5;

# Recuperar el nombre, el teléfono y el correo de los pacientes; el nombre, el consultorio y los honorarios de los médicos; y la fecha y hora de la citas. Ordenar el resultado primero por fecha y hora de forma ascendente, y después por nombre del médico de forma ascendente.    
SELECT paciente.pac_nombre, paciente.pac_telefono, paciente.pac_correo, medico.med_nombre, medico.med_consultorio, medico.med_honorarios, cita.cit_fecha_hora
	FROM paciente
    INNER JOIN cita
		ON paciente.pac_id = cita.cit_pac_id
	INNER JOIN medico
		ON cita.cit_med_id = medico.med_id
	ORDER BY cita.cit_fecha_hora ASC, medico.med_nombre ASC;
    
    
# 8. CONSULTAS 4 | GROUP BY (CON HAVING)
# Consultar datos en la BD de clínica:

# Recuperar el número de pacientes por los tres primeros dígitos de su teléfono.
SELECT SUBSTR(pac_telefono, 1, 3) AS lada, COUNT(*) AS numero_pacientes
	FROM paciente
    GROUP BY lada;
    
# Recuperar el número de médicos por especialidad.
SELECT med_especialidad, COUNT(med_especialidad) AS numero_medicos
	FROM medico
    GROUP BY med_especialidad;
    
# Recuperar el máximo, mínimo y promedio de los honorarios de los médicos por especialidad
SELECT med_especialidad, MAX(med_honorarios) AS honorarios_maximos, MIN(med_honorarios) AS honorarios_minimos, AVG(med_honorarios) AS honorarios_promedio
	FROM medico
    GROUP BY med_especialidad;
    
# Recuperar el número de médicos por la combinación de especialidad y honorarios.
SELECT CONCAT(med_especialidad, ' ', med_honorarios) AS especialidad_honorarios, COUNT(*) AS numero_medicos
	FROM medico
    GROUP BY especialidad_honorarios;
    
# Recuperar el número de citas por fecha.
SELECT DATE(cit_fecha_hora) AS fecha, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY fecha;
    
# Recuperar el número de citas por año y ordenar de mayor a menor.
SELECT YEAR(cit_fecha_hora) AS anio, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY anio
    ORDER BY numero_citas DESC;
    
# Recuperar el número de citas por la combinación de año y mes y ordenar de menor a mayor, pero solo cuando haya de 1 a 3 citas.
SELECT CONCAT(YEAR(cit_fecha_hora), '-', MONTH(cit_fecha_hora)) AS anio_mes, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY anio_mes
    HAVING numero_citas BETWEEN 1 AND 3
    ORDER BY numero_citas ASC;

# Recuperar el número de citas por id del médico.
SELECT cit_med_id, COUNT(cit_med_id) AS numero_citas
	FROM cita
    GROUP BY cit_med_id;
    
# Recuperar el número de citas por id del paciente.
SELECT cit_pac_id, COUNT(cit_pac_id) AS numero_citas
	FROM cita
    GROUP BY cit_pac_id;
    
# Recuperar el número de citas por la combinación del id del paciente y el id del médico, y ordenar de menor a mayor.
SELECT CONCAT(cit_med_id, ' ', cit_pac_id) AS id_medico_id_paciente, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY id_paciente_id_medico
    ORDER BY numero_citas ASC;
    
# Recuperar el número de citas por la combinación del id del paciente y la hora, y ordenar de mayor a menor, limitar a solo los tres primeros registros.
SELECT CONCAT(cit_pac_id, ' ', TIME(cit_fecha_hora)) AS id_paciente_hora, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY id_paciente_hora
    ORDER BY numero_citas DESC
    LIMIT 3;