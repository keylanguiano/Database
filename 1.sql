-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema playlist_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema playlist_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `playlist_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `playlist_db` ;

-- -----------------------------------------------------
-- Table `playlist_db`.`cancion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist_db`.`cancion` (
  `can_id` INT NOT NULL AUTO_INCREMENT,
  `can_titulo` VARCHAR(40) NOT NULL,
  `can_interprete` VARCHAR(30) NOT NULL COMMENT '\'Solamente indicar el interprete principal\'',
  `can_duracion` INT NOT NULL COMMENT 'La duración es en minutos',
  `can_genero` VARCHAR(45) NOT NULL,
  `can_anio` INT NOT NULL,
  
  INDEX `idx_titulo` (`can_titulo` ASC) VISIBLE,
  INDEX `idx_interprete` (`can_interprete` ASC) VISIBLE,
  INDEX `idx_genero` (`can_genero` ASC) VISIBLE,
  UNIQUE INDEX `uni_titulo_interprete` (`can_titulo` ASC, `can_interprete` ASC) VISIBLE,
  PRIMARY KEY (`can_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `playlist_db`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist_db`.`usuario` (
  `usu_id` INT NOT NULL AUTO_INCREMENT,
  `usu_nombre` VARCHAR(60) NOT NULL,
  `usu_genero` VARCHAR(4) NOT NULL,
  `usu_correo` VARCHAR(45) NOT NULL,
  `usu_fecha_nac` DATE NOT NULL,
  PRIMARY KEY (`usu_id`),
  INDEX `idx_nombre` (`usu_nombre` ASC) VISIBLE,
  UNIQUE INDEX `uni_correo` (`usu_correo` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `playlist_db`.`lista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist_db`.`lista` (
  `lis_id` INT NOT NULL AUTO_INCREMENT,
  `lis_usu_id` INT NOT NULL,
  `lis_nombre` VARCHAR(50) NOT NULL,
  `lis_fecha_creacion` DATETIME NOT NULL,
  `lis_etiquetas` VARCHAR(30) NULL COMMENT 'Descripción de la playlist\.n',
  PRIMARY KEY (`lis_id`),
  
  INDEX `fk_lista_usuario1_idx` (`lis_usu_id` ASC) VISIBLE,
  
  CONSTRAINT `fk_lista_usuario1`
    FOREIGN KEY (`lis_usu_id`)
    REFERENCES `playlist_db`.`usuario` (`usu_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `playlist_db`.`detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `playlist_db`.`detalle` (
  `det_cancion_id` INT NOT NULL,
  `det_lista_id` INT NOT NULL,
  `det_fecha` DATE NOT NULL,
  `det_favorita` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`det_cancion_id`, `det_lista_id`),
  INDEX `fk_detalle_lista1_idx` (`det_lista_id` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_cancion`
    FOREIGN KEY (`det_cancion_id`)
    REFERENCES `playlist_db`.`cancion` (`can_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_detalle_lista`
    FOREIGN KEY (`det_lista_id`)
    REFERENCES `playlist_db`.`lista` (`lis_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


# LENGUAJE DE MANIPULACIÓN DE DATOS

# 1.a. 
# Inserta  5  usuarios  de  diferentes  géneros  con  fechas  de  nacimiento entre el 2000 y el 2003 (inventa los datos).
INSERT INTO usuario (usu_nombre, usu_genero, usu_correo, usu_fecha_nac)
	VALUES ('Keyla Leilani Anguiano Cabrera', 'M', 'kl.anguianocabrera@ugto.mx', '2003-10-20'),
		   ('Jean David García Jaime', 'H', 'jd.garciajaime@ugto.mx', '2003-05-25'),
		   ('Fernando Romero Torres', 'H', 'f.romerotorres@ugto.mx', '1999-10-19'),
           ('Diego Díaz Segovia', 'H', 'd.diazsegovia@ugto.mx', '2003-10-05'),
		   ('María Guadalupe Prieto Pantoja', 'M', 'mg.prietopantoja@ugto.mx', '2003-04-26');
           
# 1.b.
# Inserta 6 canciones de diferentes géneros(inventa los datos).
INSERT INTO cancion (can_titulo, can_interprete, can_duracion, can_genero, can_anio)
	VALUES ('Si tu supieras', 'Feid', 3, 'reguetón', 2022),
		   ('Aquí algo cambio', 'Julión Álvares', 3, 'banda', 2015),
		   ('Quizás, quizás, quizás', 'Andrea Bocelli', 2, 'clásica', 2000),
           ('Crazy', 'Aerosmith', 5, 'rock', 2003),
		   ('Darte un beso', 'Prince royce', 4, 'bachata', 1999),
		   ('Lean on', 'Major Lazer', 4, 'pop', 2017);

# 1.c.
# 2 playlists para 3 de los usuarios que insertaste (selecciónalos tú e inventa los datos de la playlists).En total debes crear 6 playlists.
INSERT INTO lista (lis_nombre, lis_usu_id, lis_fecha_creacion, lis_etiquetas)
	VALUES ('Puro feid', 1, '2022-10-04', 'Cuando quier'),
		   ('Playlist para cantar', 1,'2023-08-05', 'A todo pulmón');
           
INSERT INTO lista (lis_nombre, lis_usu_id, lis_fecha_creacion, lis_etiquetas)
	VALUES ('Playlist para hacer el aseo', 2, '2020-05-15', 'Para andar de chacha'),
		   ('Playlist para llorar', 2, '2021-01-04', 'Cuando ando sad');
           
INSERT INTO lista (lis_nombre, lis_usu_id, lis_fecha_creacion, lis_etiquetas)
	VALUES ('Playlist para manejar', 3, '2015-03-05', 'Para andar rápida y furiosa'),
		   ('Playlist para hacer el gym', 3, '2010-03-15', 'Para motivarme');
           
# 1.d.
# Agrega 3 canciones para cada playlist creada. En total debes agregar 18 canciones.
INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (1, 1, '2021-01-04', 'S'),
		   (1, 2, '2021-01-05', 'N'),
		   (1, 3, '2021-01-06', 'S');
		
INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (2, 4, '2023-08-05', 'S'),
		   (2, 5, '2023-08-06', 'N'),
		   (2, 6, '2023-08-07', 'S');

INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (3, 1, '2020-05-15', 'S'),
		   (3, 2, '2020-05-16', 'N'),
		   (3, 3, '2020-05-17', 'S');
		
INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (4, 4, '2021-01-04', 'S'),
		   (4, 5, '2021-01-05', 'N'),
		   (4, 6, '2021-01-06', 'S');
           
INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (5, 1, '2015-03-05', 'S'),
		   (5, 2, '2015-03-06', 'N'),
		   (5, 3, '2015-03-07', 'S');
		
INSERT INTO detalle (det_lista_id, det_cancion_id, det_fecha, det_favorita)
	VALUES (6, 4, '2010-03-15', 'S'),
		   (6, 5, '2010-03-16', 'N'),
		   (6, 6, '2010-03-17', 'S');

# 2.a.
# Incrementa en dos semanas la fecha de nacimiento de los usuarios con  fecha  de  nacimiento  entre  1990  y  1995,  
# o  entre  1996  y  1997; que tengan en su nombre cualquiera de los siguientes strings: ‘Ortiz’, ‘Mendieta’ o ‘Cortez’; 
# y que su correo termine en ‘gmail.com’.
UPDATE usuario
	SET usu_fecha_nac = ADDDATE(usu_fecha_nac, 7)
    WHERE ((YEAR(usu_fecha_nac) BETWEEN '1990' AND '1995') OR (YEAR(usu_fecha_nac) BETWEEN '1996' AND '1997'))
		AND ((usu_nombre LIKE '%Ortiz%') OR (usu_nombre LIKE '%Mendieta%') OR (usu_nombre LIKE '%Cortez%'))
        AND usu_correo LIKE '%gmail.com'; 

# 2.b.
# Incrementa en 1 minuto la duración de las canciones que en su título tengan alguno de los siguientes strings:
# ‘amor’, ‘tu’ o ‘sube’; que sean del género ‘banda’, ‘pop’ o ‘ranchera’; que tengan duración entre  1  a  3  minutos  
# o  exactamente  5  minutos;  y  cuyo  intérprete inicie con alguno de los siguientes strings: ‘la’ o ‘el’.
UPDATE cancion
	SET can_duracion = (can_duracion + 1)
    WHERE ((can_titulo LIKE '%amor%') OR (can_titulo LIKE '%tu%') OR (can_titulo LIKE '%sube%'))
		AND can_genero IN ('banda', 'pop', 'ranchera')
        AND ((can_duracion BETWEEN 1 AND 3) OR (can_duracion = 5))
        AND ((can_interprete LIKE 'la%') OR (can_interprete LIKE 'el%')); 
        
# 2.c.
# Cambia el género de las canciones que sean ‘rock’ o ‘bachata’ a ‘pop’, pero  solo  cuando  su  año  de  salida  esté  entre  1970  y  1980,  
# o  entre 1982 y 1984; la duración sea entre 4 y 5 minutos; y que en su título tenga alguno de los siguientes strings: ‘color’, ‘risa’ o ‘brillar’.
UPDATE cancion
	SET can_genero = 'pop'
    WHERE can_genero IN ('rock', 'bachata')
		AND ((can_anio BETWEEN 1970 AND 1980) OR (can_anio BETWEEN 1982 AND 1984))
        AND can_duracion BETWEEN 4 AND 5
        AND ((can_titulo LIKE '%color%') OR (can_titulo LIKE '%risa%') OR (can_titulo LIKE '%brillar%')); 
      
      
# 3.a.
# Recupera el nombre, el correo y el género de los usuarios, junto con todos  los  atributos  de  las  playlists  que  haya  creado  cada uno.  
# Solo devuelve los datos cuando el nombre del usuario contenga el string ‘Trejo’; su fecha de nacimiento esté entre 1995 y 2005; 
# y su correo termine  en  alguno  de  los  strings:  ‘gmail.com’  o  ‘outlook.com’. 
# Ordena el  resultado primero  por  género  de  forma  descendente  y luego por nombre de forma ascendente. 
# Devuelve todos los usuarios que cumplan las condiciones, aunque no tengan playlists asociadas.
SELECT usuario.usu_nombre, usuario.usu_correo, usuario.usu_genero, lista.*
	FROM usuario
    LEFT JOIN lista
		ON usuario.usu_id = lista.lis_usu_id
	WHERE usuario.usu_nombre LIKE '%Trejo%'
		AND YEAR(usuario.usu_fecha_nac) BETWEEN 1995 AND 2005
        AND ((usuario.usu_correo LIKE '%gmail.com') OR (usuario.usu_correo LIKE '%outlook.com'))
	ORDER BY usuario.usu_genero DESC, usuario.usu_nombre ASC;


# 3.b.
# Recupera  el  nombre  y  la  fecha  de  creación  de  todas  las playlists, junto  con  el  título,  el  intérprete  y  el  género  de  
# las  canciones asociadas a cada playlist. Solo devuelve los datos cuando la fecha de creación de la playlist esté entre 2022 y 2023; 
# su nombre termine en el string ‘bailar’; que las canciones sean del género ‘bachata’, ‘salsa’ o ‘electrónica’; 
# y que la duración de las canciones sea de 3 o 5 minutos.  Ordena  el  resultado primero  por  género  de  las  canciones de  forma  descendente  
# y  luego  por  nombre  de  la  playlist  de  forma ascendente.   
# Devuelve   todas   las   canciones   que   cumplan   las condiciones, aunque no estén asociadas con una playlist. 
SELECT lista.lis_nombre, lista.lis_fecha_creacion, cancion.can_titulo, cancion.can_interprete, cancion.can_genero
	FROM lista
	INNER JOIN detalle
		ON lista.lis_id = detalle.det_lista_id
	RIGHT JOIN cancion
		ON detalle.det_cancion_id = cancion.can_id
	WHERE YEAR(lista.lis_fecha_creacion) BETWEEN 2022 AND 2023
		AND lista.lis_nombre LIKE '%bailar'
        AND cancion.can_genero IN ('bachata', 'salsa', 'electrónica')
		AND cancion.can_duracion BETWEEN 3 AND 5
	ORDER BY cancion.can_genero DESC, lista.lis_nombre ASC;
	


# 3.c.
#Recuperar el nombre y el género de los usuarios; el nombre y la fecha de creación de las playlists que haya creado cada uno;
# y el título, el intérprete y el género de las canciones asociadas con cada playlist. 
# Solo  devuelve  los  datos  para  los  usuarios  con  fecha  de  nacimiento entre 1999 y 2002; 
# cuyas playlists tengan en sus etiquetas el string ‘estudiar’; y que las canciones sean del género ‘clásica’. 
# Ordena el resultado  primero  por  nombre  del  usuario  de  forma  ascendente  y luego por el nombre de la playlist de forma ascendente.
SELECT usuario.usu_nombre, usuario.usu_genero, lista.lis_nombre, lista.lis_fecha_creacion, cancion.can_titulo, cancion.can_interprete, cancion.can_genero
	FROM usuario
    INNER JOIN lista
		ON usuario.usu_id = lista.lis_usu_id
	INNER JOIN cancion 
		ON lista.lis_id = cancion.can_id
        WHERE YEAR(usuario.usu_fecha_nac) BETWEEN 1999 AND 2002
			AND lista.lis_etiquetas LIKE '%estudiar%'
			AND cancion.can_genero = 'clásica'
	ORDER BY usuario.usu_genero ASC, lista.lis_nombre ASC;

# 4.a.
# Recupera el género y el año de las canciones, el número de canciones por  la  combinación  de  género  y  año,  el  promedio,  el  mínimo  y  el máximo 
# de  la  duración  de  las  canciones  en  cada  combinación  de género  y  año.  
# Devuelve  el  resultado  solo  cuando  el  mínimo  de  la duración  sea  1,  3,  5 o  7.  
# Ordena el  resultado  de forma  ascendente por el número de canciones.
SELECT can_genero, can_anio, COUNT(*) AS numero_canciones, AVG(can_duracion) AS promedio_duracion, MIN(can_duracion) AS minima_duracion, MAX(can_duracion) AS maxima_duracion
	FROM cancion
    GROUP BY can_genero, can_anio
	HAVING minima_duracion IN(1, 3, 5, 7)
	ORDER BY numero_canciones ASC;

# 4.b.
# Recupera el mes de creación de las playlists, el número de canciones asociadas  con  las  playlist  por  mes,  el  promedio,  el  mínimo  y  el máximo
# de las duraciones de las canciones asociadas con las playlists por  mes. Devuelve  el  resultado  solo  cuando  el  promedio  de  la duración  de  las  canciones 
# por  mes  esté  entre  2  y  3.  Ordena  el resultado de forma ascendente por el número de canciones.
SELECT MONTH(lista.lis_fecha_creacion) AS mes, COUNT(*) AS numero_canciones, AVG(cancion.can_duracion) AS promedio_duracion, MIN(cancion.can_duracion) AS minima_duracion, MAX(cancion.can_duracion) AS maxima_duracion
	FROM lista
    INNER JOIN detalle
		ON lista.lis_id = detalle.det_lista_id
	INNER JOIN cancion
		ON detalle.det_cancion_id = cancion.can_id
	GROUP BY mes
    HAVING promedio_duracion BETWEEN 2 AND 3
    ORDER BY numero_canciones ASC;