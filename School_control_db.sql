-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema control_escolar_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema control_escolar_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `control_escolar_db` DEFAULT CHARACTER SET utf8 ;
USE `control_escolar_db` ;

-- -----------------------------------------------------
-- Table `control_escolar_db`.`carrera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `control_escolar_db`.`carrera` (
  `car_id` INT NOT NULL AUTO_INCREMENT,
  `car_nombre` VARCHAR(70) NOT NULL,
  `car_abrv` VARCHAR(7) NOT NULL COMMENT 'Las iniciales de la división, p. ej. LISC',
  `car_division` VARCHAR(7) NOT NULL COMMENT 'Las iniciales de la división, p. ej. DICIS',
  `car_sede` VARCHAR(30) NOT NULL,
  
  PRIMARY KEY (`car_id`),
  
  INDEX `idx_nombre` (`car_nombre` ASC) VISIBLE,
  
  UNIQUE INDEX `uni_nom_division` (`car_nombre` ASC, `car_division` ASC) INVISIBLE)

ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `control_escolar_db`.`estudiante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `control_escolar_db`.`estudiante` (
  `est_id` INT NOT NULL AUTO_INCREMENT,
  `est_nombre` VARCHAR(30) NOT NULL,
  `est_ap_paterno` VARCHAR(30) NOT NULL,
  `est_ap_materno` VARCHAR(30) NULL,
  `est_correo` VARCHAR(30) NOT NULL,
  `est_semestre` INT NOT NULL,
  `est_car_id` INT NOT NULL,
  
  PRIMARY KEY (`est_id`),
  
  INDEX `idx_nom_completo` (`est_nombre` ASC, `est_ap_paterno` ASC, `est_ap_materno` ASC) INVISIBLE,
  INDEX `fk_estudiante_carrera_idx` (`est_car_id` ASC) VISIBLE,
  
  UNIQUE INDEX `uni_correo` (`est_correo` ASC) INVISIBLE,
  
  CONSTRAINT `fk_carrera_estudiante`
    FOREIGN KEY (`est_car_id`)
    REFERENCES `control_escolar_db`.`carrera` (`car_id`)
    
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)

ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/*
# 1. MODIFICACIONES
# En la base de control escolar:

# Crea el atributo NUA al inicio de la tabla estudiante de tipo VARCHAR(7) NOT NULL.
ALTER TABLE estudiante 
	ADD est_NUA VARCHAR (7) NOT NULL FIRST;

# Cambia el nombre de la tabla estudiante por alumno.
ALTER TABLE estudiante 
	RENAME alumno;

# Cambia el tipo de atributo de est_id por INT (eliminar el AUTO_INCREMENT).
ALTER TABLE alumno 
	MODIFY est_id INT;

# Elimina la llave primaria de la tabla alumno.
ALTER TABLE alumno 
	DROP PRIMARY KEY;

# Crea la llave primaria de la tabla alumno con el atributo NUA.
ALTER TABLE alumno 
	ADD PRIMARY KEY (est_NUA);

# Elimina la columna est_id de la tabla alumno
ALTER TABLE alumno 
	DROP COLUMN est_id;

# Inserta el atributo campus al final de la tabla carrera como VARCHAR(40) NOT NULL.
ALTER TABLE carrera 
	ADD car_campus VARCHAR (40) NOT NULL;

# Crea un atributo para el semestre en la tabla alumno después del atributo est_ap_mat de tipo TINYINT NOT NULL.
ALTER TABLE carrera 
	ADD car_semestre TINYINT NOT NULL AFTER car_ap_materno;

# Crea un índice para el semestre en la tabla alumno.
ALTER TABLE alumno 
	ADD INDEX idx_semestre (est_semestre);

# Cambia el nombre de la tabla alumno por estudiante
ALTER TABLE alumno 
	RENAME estudiante;
*/


# 2. INSERCIÓN
# Insertar datos en la BD de control escolar:

# Carreras de DICIS: LISC, LICE, LIME, LIGE, LIMEC, LIAD

INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Sistemas Computacionales', 'LISC', 'DICIS', 'Salamanca');

INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Comunicaciones y Electrónica', 'LICE', 'DICIS', 'Salamanca');
    
INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Mecánica', 'LIME', 'DICIS', 'Salamanca');
    
INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Gestión Empresarial', 'LIGE', 'DICIS', 'Salamanca');
    
INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Mecatronica', 'LIMEC', 'DICIS', 'Salamanca');
    
INSERT INTO carrera (car_nombre, car_abrv, car_division, car_sede)
	VALUES ('Licenciatura en Ingeniería en Artes Digitales', 'LIAD', 'DICIS', 'Salamanca');
    
# 4 Estudiantes de cada carrera
# Considerar estudiantes de semestres entre 1 y 9

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Keyla Leilani', 'Anguiano', 'Cabrera', 'kl.anguianocabrera@ugto.mx', 1, 1),
		   ('Jean David', 'García', 'Jaime', 'jd.garciajaime@ugto.mx', 1, 1),
		   ('Fernando', 'Romero', 'Torres', 'f.romerotorres@ugto.mx', 2, 1),
		   ('Jonathan Esaú', 'Arriaga', 'Saldaña', 'je.arriagasaldaña@ugto.mx', 2, 1);
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Diego', 'Díaz', 'Segovia', 'd.diazsegovia@ugto.mx', 3, 2),
		   ('María Guadalupe', 'Prieto', 'Pantoja', 'mg.prietopantoja@ugto.mx', 3, 2),
		   ('Pedro Ángel', 'Lopéz', 'Vargas', 'pa.lopezvargas@ugto.mx', 4, 2),
		   ('Erick Armando', 'Lopéz', 'Ramírez', 'ea.lopezramirez@ugto.mx', 4, 2);

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Jonathan Uriel', 'Pérez', 'Vargas', 'ju.perezvargas@ugto.mx', 5, 3),
		   ('Nicholas Andrew', 'Guido', 'Arroyo', 'na.guidoarroyo@ugto.mx', 5, 3),
		   ('Fabian Alexis', 'Segoviano', 'Balandran', 'fa.segovianobalandran@ugto.mx', 6, 3),
		   ('José Miguel', 'Crespo', 'Flores', 'jm.crespoflores@ugto.mx', 6, 3);

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Perla Yareli', 'Camacho', 'Sanchéz', 'py.camachosanchez@ugto.mx', 7, 4),
		   ('Jonathan Antonio', 'Vallejo', 'Pérez', 'ja.vallejoperez@ugto.mx', 7, 4),
		   ('Emmanuel', 'Coronilla', 'Hernández', 'e.coronillahernandez@ugto.mx', 8, 4),
		   ('Yennifer', 'Olivares', 'Rodríguez', 'y.olivaresrodriguez@ugto.mx', 8, 4);
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Paolo de Piero', 'Lorandi', 'Camacho', 'pdp.lorandicamacho@ugto.mx', 9, 5),
		   ('Ximena', 'Ocejo', 'Rizo', 'x.ocejorizo@ugto.mx', 9, 5),
		   ('Jesus Adrian', 'Martínez', 'Jaime', 'ja.martinezjaime@ugto.mx', 1, 5),
		   ('Adriana Rubí', 'Vázquez', 'López', 'ar.vazquezlopez@ugto.mx', 1, 5);
           
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_semestre, est_car_id)
	VALUES ('Andrea', 'Bravo', 'Carmona', 'a.bravocarmona@ugto.mx', 2, 6),
		   ('Hadassah Alejandra', 'Hernández', 'García', 'ha.hernandezgarcia@ugto.mx', 2, 6),
		   ('Adrian', 'Corona', 'Pacheco', 'a.coronapacheco@ugto.mx', 3, 6),
		   ('José Julian', 'Sierra', 'Álvarez', 'jj.sierraalvarez@ugto.mx', 3, 6);
  
  
/*
# 3. BORRADO
# Borrar datos en la BD de control escolar:

# Borrar estudiantes cuyos apellidos paterno y materno terminen en 'ez' (ambos deben terminar en 'ez')
DELETE FROM estudiante
	WHERE ((est_ap_paterno LIKE '%ez') AND (est_ap_materno LIKE '%ez')) ;
        
# Borrar estudiantes de una carrera cualquiera con id específico (dado por ti) y cuyo corre electrónico termine en el string 'ugto.mx'
DELETE FROM estudiante
	WHERE est_car_id = 2
		AND est_correo LIKE '%ugto.mx';
        
# Borrar estudiantes de la carrera LISC (revisar el id), que estén entre los semestre 8 y 9 o entre los semestres 1 y 2, y cuyo correo electrónico termine en el string 'gmail.com'
DELETE FROM estudiante
	WHERE est_car_id = 1
		AND ((est_semestre BETWEEN 8 AND 9) OR (est_semestre BETWEEN 1 AND 2))
        AND est_correo LIKE '%gmail.com';
        
# Borrar todos los estudiantes para una carrera cualquier con id específico (dado por ti).
DELETE FROM estudiante
	WHERE est_car_id = 4;

# Borrar la carrera con el id del ejercicio anterior, pero considerando sus iniciales.
DELETE FROM carrera
	WHERE car_abrv = 'LIGE';
*/
    

# 4. ACTUALIZACIÓN
# Modificar datos en la BD de control escolar

# Cambiar la sede para todas las carreras de una división cualquiera (dada por ti)
UPDATE carrera
	SET car_sede = 'Guanajuato'
    WHERE car_division = 'DICIS';

# Cambiar el nombre y las iniciales para una carrera cualquiera con un nombre específico
UPDATE carrera
	SET car_nombre = 'Licenciatura en Ingeniería en Mecatrónica', car_abrv = 'LIMT'
    WHERE car_nombre = 'Licenciatura en Ingeniería en Mecatronica';

# Cambiar el nombre y apellidos de un estudiante con nombre y apellidos específicos (dados por ti)
UPDATE estudiante
	SET est_nombre = 'Lupe', est_ap_paterno = 'Pantoja', est_ap_materno = 'Prieto'
    WHERE (est_nombre = 'María Guadalupe' AND est_ap_paterno = 'Prieto' AND est_ap_materno = 'Pantoja');

# Incrementar en 1 el semestre de todos los estudiantes de la carrera LISC (usar el id de la carrera) que estén entre 7o y 8o.
UPDATE estudiante
	SET est_semestre = (est_semestre + 1)
    WHERE est_car_id = 1
		AND est_semestre BETWEEN 7 AND 8;
        

# 5. CONSULTAS 1      
# Consultar datos en la BD de control escolar:

# Recuperar el nombre, las iniciales y la sede de las carreras de la divisón correspondiente a 'DICIS'.
SELECT car_nombre, car_abrv, car_sede
	FROM carrera
    WHERE car_division = 'DICIS';
    
# Recuperar el nombre, las iniciales y la sede de las carreras que en su nombre tengan el string 'Ingeniería'.
SELECT car_nombre, car_abrv, car_sede
	FROM carrera
    WHERE car_nombre LIKE '%Ingeniería%';
    
# Recuperar el nombre y las iniciales de las carreras de dos sedes cualquiera (dadas por ti).
SELECT car_nombre, car_abrv
	FROM carrera
    WHERE car_division = 'DICIS';
    
# Recuperar todos los atributos y registros de los estudiantes.
SELECT *
	FROM estudiante;

# Recuperar todos los atributos de los estudiantes en semestres 5 y 8.
SELECT *
	FROM estudiante
    WHERE est_semestre IN (5,8);
    
# Recuperar todos los atributos de los estudiantes cuyo correo termine con el string 'ugto.mx' y estén en los semestres 7 y 9.
SELECT *
	FROM estudiante
    WHERE est_correo LIKE '%ugto.mx'
		AND est_semestre IN (7,9);
    
# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes de semestres entre 4 y 7.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS est_nombre_completo
	FROM estudiante
    WHERE est_semestre BETWEEN 4 AND 7;
        
# Recuperar la concatenación de (nombre, apellido paterno y apellido materno), el id de la carrera y el semestre de los estudiantes de la carrera con ids 2 y 4 que estén en los semestres 1, 3 y 5.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS est_nombre_completo, est_car_id, est_semestre
	FROM estudiante
    WHERE est_car_id IN (2, 4)
		AND est_semestre IN (1, 3, 5);
    
# Recuperar la concatenación de (nombre, apellido paterno y apellido materno) de los estudiantes de las carreras con ids 1, 4 y 5, que estén en los semestres 2 y 5 y cuyo apellido paterno o materno termine en 'ez' (cualquiera de los dos).
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS est_nombre_completo
	FROM estudiante
    WHERE est_car_id IN (1, 4, 5)
		AND est_semestre IN (2, 5)
        AND (est_ap_paterno LIKE '%ez' OR est_ap_materno LIKE '%ez');
        
# CROSS JOIN

# Recuperar el nombre y las iniciales de las carreras junto con la concatenación (nombre, apellido paterno y apellido materno) de los estudiantes de cada carrera.
SELECT carrera.car_nombre, carrera.car_abrv, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo
	FROM carrera, estudiante
    WHERE carrera.car_id = estudiante.est_car_id;

# Recuperar el nombre y las iniciales de la carrera junto con la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes para la carrera con iniciales de 'LICE'.
SELECT carrera.car_nombre, carrera.car_abrv, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera, estudiante
    WHERE carrera.car_id = estudiante.est_car_id
		AND carrera.car_abrv = 'LICE';
    
# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes y el nombre de la carrera en la que están.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre
	FROM estudiante, carrera
    WHERE carrera.car_id = estudiante.est_car_id;

# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes y el nombre de la carrera en la que están, pero solo para los estudiantes cuyo apellido materno o apellido paterno termine en 'ez' o en 'is' (cualquiera de los dos apellido y cualquiera de las dos terminaciones).
 SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS est_nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre
	FROM estudiante, carrera
    WHERE carrera.car_id = estudiante.est_car_id
		AND (estudiante.est_ap_paterno LIKE '%ez' OR estudiante.est_ap_materno LIKE '%ez' OR estudiante.est_ap_paterno LIKE '%is' OR estudiante.est_ap_materno LIKE '%is');
        
        
# 6. CONSULTAS 2 | ORDER BY y LIMIT  
# Consultar datos en la BD de control escolar:

# Recuperar el nombre, las iniciales y la sede de las carreras de la divisón correspondiente a 'DICIS'. Devolver el resultado ordenado por sede de forma ascendente.
SELECT car_nombre, car_abrv, car_sede
	FROM carrera
    WHERE car_division = 'DICIS'
    ORDER BY car_sede ASC;

# Recuperar el nombre, las iniciales, la sede y la división de las carreras que en su nombre tengan el string 'ingeniería' o el string 'bio'. Devolver el resultado ordenado primero por división de forma ascendente y después por nombre de forma ascendente. Devolver solo 5 registros a partir de la posición 3.
SELECT car_nombre, car_abrv, car_sede, car_division
	FROM carrera
    WHERE (car_nombre LIKE '%Ingeniería%' OR car_nombre LIKE '%Bio%')
    ORDER BY car_division ASC, car_nombre ASC
    LIMIT 3, 5;
    
# Recuperar el nombre y las iniciales de las carreras de dos divisiones cualquiera (dadas por ti), pero solo aquellas cuyas iniciales contengan el string 'LI'. Devolver el resultado ordenado por iniciales de forma ascendente. Devolver solo los primeros 5 registros.
SELECT car_nombre, car_abrv
	FROM carrera
    WHERE (car_division = 'DICIS' OR car_division = '')
		AND car_abrv LIKE '%LI%'
    ORDER BY car_abrv ASC
    LIMIT 5;
    
# Recuperar todos los atributos de los estudiantes en semestres 5 y 8, cuyo correo termine con el string 'gmail.com'. Devolver el resultado ordenado primero por apellido paterno de forma ascendente y luego por apellido materno de forma ascendente.
SELECT *
	FROM estudiante
	WHERE est_semestre IN (5, 8)
		AND est_correo LIKE '%gmail.com'
	ORDER BY est_ap_paterno ASC, est_ap_materno ASC;
    
# Recuperar la concatenación de (nombre, apellido paterno y apellido materno), el id de la carrera y el semestre de los estudiantes de la carrera con ids 1, 3 y 5 que estén en los semestres 2, 4 y 6. Devolver el resultado ordenado por id de la carrera de forma ascendente. Devolver solo 5 registros a partir de la posición 2.
SELECT CONCAT(est_nombre, ' ', est_ap_paterno, ' ', est_ap_materno) AS nombre_completo, est_car_id, est_semestre
	FROM estudiante
    WHERE est_car_id IN (1, 3, 5)
		AND est_semestre IN (2, 4, 6)
    ORDER BY est_car_id ASC
    LIMIT 2, 5;
    
# CROSS JOIN

# Recuperar el nombre y las iniciales de las carreras junto con la concatenación (nombre, apellido paterno y apellido materno) y el semestre de los estudiantes de cada carrera. Devolver el resultado ordenado por nombre de la carrera de forma ascendente. Devolver solo los primeros 10 registros.
SELECT carrera.car_nombre, carrera.car_abrv, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_semestre
	FROM carrera, estudiante
    WHERE carrera.car_id = estudiante.est_car_id
    ORDER BY carrera.car_nombre ASC
    LIMIT 10;
    
# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes, junto con el nombre, las iniciales y la sede de la carrera en la que están. Devolver el resultado ordenado primero por sede de forma ascendente y luego por semestre de forma descendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre, carrera.car_abrv, carrera.car_sede
	FROM estudiante, carrera
    WHERE estudiante.est_car_id = carrera.car_id
    ORDER BY carrera.car_sede ASC, estudiante.est_semestre DESC;
    
# Recuperar el nombre, las iniciales, la sede y la división de las carreras; junto con la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes para las carreras que tengan en su nombre 'ingeniería' o 'bio'. Devolver el resultado ordenado por división de forma ascendente. Devolver solo 5 registros a partir de la posición 2.
SELECT carrera.car_nombre, carrera.car_abrv, carrera.car_sede, carrera.car_division, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera, estudiante
    WHERE carrera.car_id = estudiante.est_car_id
		AND (car_nombre LIKE '%Ingeniería%' OR car_nombre LIKE '%Bio%')
    ORDER BY carrera.car_division ASC
    LIMIT 2, 5;
    
# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes ; junto con el nombre y las iniciales de la carrera en la que están, pero solo para los estudiantes cuyo apellido materno o apellido paterno termine en 'ez' o en 'is' (cualquiera de los dos apellido y cualquiera de las dos terminaciones). Devolver el resultado ordenado primero por iniciales de la carrera de forma ascendente y luego por la concatenación de forma ascendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre, carrera.car_abrv
	FROM estudiante, carrera
    WHERE estudiante.est_car_id = carrera.car_id
		AND (estudiante.est_ap_paterno LIKE '%ez' OR estudiante.est_ap_materno LIKE '%ez' OR estudiante.est_ap_paterno LIKE '%is' OR estudiante.est_ap_materno LIKE '%is')
    ORDER BY carrera.car_abrv ASC, nombre_completo ASC;
    
# Recuperar el nombre, las iniciales y la sede de la carrera junto con la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes para las carreras que estén en la división DICIS. Devolver el resultado ordenado de forma ascendente por la concatenación. Devolver solo los primero 10 registros.
SELECT carrera.car_nombre, carrera.car_abrv, carrera.car_sede, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera, estudiante
    WHERE carrera.car_id = estudiante.est_car_id
		AND carrera.car_division = 'DICIS'
    ORDER BY nombre_completo ASC
    LIMIT 10;
    

# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT) ORDER BY, LIMIT
# Consultar datos en la BD de control escolar:

# Recuperar el nombre, la división y la sede de cada carrera, junto con la concatenación de (nombre, apellido paterno, apellido materno), el correo y el semestre de los estudiantes de cada carrera. 
SELECT carrera.car_nombre, carrera.car_division, carrera.car_sede, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera
    INNER JOIN estudiante
		ON carrera.car_id = estudiante.est_car_id;

# Recuperar el nombre, la división y la sede de cada carrera, junto con la concatenación de (nombre, apellido paterno, apellido materno), el correo y el semestre de los estudiantes de cada carrera. Incluir las carreras que no tengan estudiantes.
SELECT carrera.car_nombre, carrera.car_division, carrera.car_sede, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera
    LEFT JOIN estudiante
		ON carrera.car_id = estudiante.est_car_id;

# Recuperar la concatenación de (nombre, apellido paterno, apellido materno), el correo y el semestre de los estudiantes, junto con el nombre, la abreviatura y la división de su carrera. Incluir las carreras que no tengan estudiantes.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre, carrera.car_abrv, carrera.car_division
	FROM estudiante
    RIGHT JOIN carrera
		ON estudiante.est_car_id = carrera.car_id;

# ORDER BY, LIMIT

# Recuperar el nombre y las iniciales de las carreras junto con la concatenación (nombre, apellido paterno y apellido materno) y el semestre de los estudiantes de cada carrera. Devolver el resultado ordenado por nombre de la carrera de forma ascendente. Devolver solo los primeros 10 registros.
SELECT carrera.car_nombre, carrera.car_abrv, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_semestre
	FROM carrera
    INNER JOIN estudiante
		ON carrera.car_id = estudiante.est_car_id
	ORDER BY carrera.car_nombre ASC
    LIMIT 10;

# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes, junto con el nombre, las iniciales y la sede de la carrera en la que están. Devolver el resultado ordenado primero por sede de forma ascendente y luego por semestre de forma descendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre, carrera.car_abrv, carrera.car_sede
	FROM estudiante
    INNER JOIN carrera
		ON estudiante.est_car_id = carrera.car_id
	ORDER BY carrera.car_sede ASC, estudiante.est_semestre DESC;

# Recuperar el nombre, las iniciales, la sede y la división de las carreras; junto con la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes para las carreras que tengan en su nombre 'ingeniería' o 'bio'. Devolver el resultado ordenado por división de forma ascendente. Devolver solo 5 registros a partir de la posición 2.
SELECT carrera.car_nombre, carrera.car_abrv, carrera.car_sede, carrera.car_division, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera
    INNER JOIN estudiante
		ON carrera.car_id = estudiante.est_car_id
	WHERE (carrera.car_nombre LIKE '%Ingeniería%' OR carrera.car_nombre LIKE '%Bio%')
	ORDER BY carrera.car_division ASC
    LIMIT 2, 5;

# Recuperar la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes ; junto con el nombre y las iniciales de la carrera en la que están, pero solo para los estudiantes cuyo apellido materno o apellido paterno termine en 'ez' o en 'is' (cualquiera de los dos apellido y cualquiera de las dos terminaciones). Devolver el resultado ordenado primero por iniciales de la carrera de forma ascendente y luego por la concatenación de forma ascendente.
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre, carrera.car_nombre, carrera.car_abrv
	FROM estudiante
    INNER JOIN carrera
		ON estudiante.est_car_id = carrera.car_id
	WHERE (estudiante.est_ap_paterno LIKE '%ez' OR estudiante.est_ap_materno LIKE '%ez' OR estudiante.est_ap_paterno LIKE '%is' OR estudiante.est_ap_materno LIKE '%is')
	ORDER BY carrera.car_abrv ASC, nombre_completo ASC;

# Recuperar el nombre, las iniciales y la sede de la carrera junto con la concatenación (nombre, apellido paterno y apellido materno), el correo y el semestre de los estudiantes para las carreras que estén en la división DICIS. Devolver el resultado ordenado de forma ascendente por la concatenación. Devolver solo los primero 10 registros.
SELECT carrera.car_nombre, carrera.car_abrv, carrera.car_sede, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo, estudiante.est_correo, estudiante.est_semestre
	FROM carrera
    INNER JOIN estudiante
		ON carrera.car_id = estudiante.est_car_id
	WHERE carrera.car_division = 'DICIS'
	ORDER BY nombre_completo ASC
    LIMIT 10;


# 8. CONSULTAS 4 | GROUP BY (CON HAVING)
# Consultar datos en la BD de control escolar:

# Recuperar el número de carreras por sede.
SELECT car_sede, COUNT(car_sede) AS numero_carreras
	FROM carrera
    GROUP BY car_sede;

# Recuperar el número de sedes por división.
SELECT car_division, COUNT(DISTINCT(car_sede)) AS numero_sedes
	FROM carrera
    GROUP BY car_division;
    
# Recuperar el número de de carreras por división
SELECT car_division, COUNT(car_division) AS numero_carreras
	FROM carrera
    GROUP BY car_division;
    
# Recuperar el número de carreras por la combinación de sede y división.
SELECT CONCAT(car_sede, ' ', car_division) AS sede_division, COUNT(*) AS numero_carreras
	FROM carrera
    GROUP BY sede_division;
    
# Recuperar el número de estudiantes por carrera id
SELECT est_car_id, COUNT(est_car_id) AS numero_estudiantes
	FROM estudiante
    GROUP BY est_car_id;
    
# Recuperar el número de estudiantes por semestre y ordenar de mayor a menor.
SELECT est_semestre, COUNT(est_semestre) AS numero_estudiantes
	FROM estudiante
    GROUP BY est_semestre
    ORDER BY numero_estudiantes DESC;
    
# Recuperar el número de estudiantes por semestre y ordenar de mayor a menor, limitar solo a los primeros 3 registros.
SELECT est_semestre, COUNT(est_semestre) AS numero_estudiantes
	FROM estudiante
    GROUP BY est_semestre
    ORDER BY numero_estudiantes DESC
    LIMIT 3;
    
# Recuperar el número de estudiantes por la combinación del id de la carrera y el semestre y ordenar a menor a mayor.
SELECT CONCAT(est_car_id, '	', est_semestre) AS id_carrera_semestre, COUNT(*) AS numero_estudiantes
	FROM estudiante
    GROUP BY id_carrera_semestre
    ORDER BY numero_estudiantes ASC;

# Recuperar el semestre promedio de los estudiantes por id de carrera.
SELECT est_car_id, AVG(est_semestre) AS semestre_promedio
	FROM estudiante
    GROUP BY est_car_id;
    
# Recuperar el mínimo y máximo semestre de los estudiantes agrupados por el id de la carrera.
SELECT est_car_id, MIN(est_semestre) AS semestre_minimo, MAX(est_semestre) AS semestre_maximo
	FROM estudiante
    GROUP BY est_car_id;
