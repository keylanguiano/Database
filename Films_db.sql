# Created by: Anguiano Cabrera Keyla Leilani
# Date: 10/02/2023
# Definition: Crear una base de datos para controlar la informacion de una cartelera de cine

CREATE DATABASE IF NOT EXISTS peliculas_db;

USE peliculas_db;

# Super llaves
# [titulo, director], [titulo, duracion], [titulo, director, duracion], [titulo, director, clasificacion]
# [titulo, estreno, diretor], [titulo, director, clasificacion]

# Llaves candidatas
# [titulo, director], [titulo, duracion]

# Llave primaria 
# [id]

# Llaves alternativas
# [titulo, director],[titulo, duracion]

# Crear la tabla pelicula
CREATE TABLE IF NOT EXISTS pelicula (

	pel_id INT NOT NULL AUTO_INCREMENT, 
	pel_titulo VARCHAR (70) NOT NULL,
	pel_genero VARCHAR (25) NOT NULL,
	pel_clasificacion ENUM ('AA', 'A', 'B', 'B-15', 'C', 'D','PG-13')  NOT NULL,
	pel_duracion INT NOT NULL COMMENT 'La duración es en minutos',
    pel_director VARCHAR (50) NOT NULL,
    pel_fecha_estreno DATE NOT NULL,
    
    PRIMARY KEY (pel_id),
    
    UNIQUE uni_titulo_fecha (pel_titulo, pel_fecha_estreno),
    UNIQUE uni_titulo_duracion (pel_titulo, pel_duracion),
    
    INDEX idx_titulo (pel_titulo),
    INDEX idx_clasificacion (pel_clasificacion),
    INDEX idx_genero (pel_genero)

);

# Super llaves
# [nombre, fecha de nacimiento]

# Llaves candidatas
# [nombre, fecha de nacimiento]

# Llave primaria 
# [id]

# Llaves alternativas
# [nombre, fecha de nacimiento]

CREATE TABLE IF NOT EXISTS actor (

	act_id INT NOT NULL AUTO_INCREMENT,
    act_nombre_real VARCHAR (60) NOT NULL,
    act_nombre_artistico VARCHAR(30) NOT NULL,
    act_fecha_nacimiento DATE NOT NULL,
    act_genero ENUM('H','M','OTRO'),
    act_pais_de_nacimiento VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (act_id),
    
    INDEX idx_nombre_real (act_nombre_real),
    INDEX idx_nombre_artistico (act_nombre_artistico),
    INDEX idx_pais_de_nacimiento (act_pais_de_nacimiento),
    INDEX idx_genero (act_genero),
    
    UNIQUE uni_nombre (act_nombre_real, act_nombre_artistico)
    
);

CREATE TABLE IF NOT EXISTS elenco (

    ele_pel_id INT NOT NULL, 
    ele_act_id INT NOT NULL,
    ele_personaje VARCHAR (50) NOT NULL, 
    ele_salario DECIMAL (15, 2) NOT NULL COMMENT 'Salario en USD', 
    ele_papel ENUM ('Protagónico', 'Soporte', 'Extra'), 
    
    PRIMARY KEY (ele_pel_id, ele_act_id),
        
    CONSTRAINT fk_act_pel
		FOREIGN KEY (ele_act_id)
		REFERENCES actor (act_id)
        
        ON DELETE RESTRICT 
		ON UPDATE RESTRICT,
        
    CONSTRAINT fk_pel_act
		FOREIGN KEY (ele_pel_id)
		REFERENCES pelicula (pel_id)
        
        ON DELETE CASCADE 
		ON UPDATE CASCADE
);

# ON DELETE RESTRICT
# La opcion RESTRICT no permite borra el registro de la tabla padre, mientras haya información asociada en la tabla hija
# Para poder borra un registro de la tabla padre primero tengo que borrar los registros de la tabla hija

# ON DELETE CASCADE
# La opción CASCEADE permite borrar el registro de la tabla padre
# Al eliminar un registro de la tabla padre, en automático se eliminan los registros asociados de la tabla hija

# ON DELETE SET NULL
# La opción SET NULL pone en NULL tdos los valores de la llave al valor eliminado de la tabla padre


/*
# 1. MODIFICACIONES
# En la base de películas:

# 1. Crea un índice para el atributo ele_personaje en la tabla elenco
ALTER TABLE elenco 
	ADD INDEX idx_personaje (ele_personaje);

# 2. Crea un atributo de formato (digital, 3D, Imax, etc. ) en la tabla película, define tu el tipo y hazlo NOT NULL
ALTER TABLE pelicula 
	ADD pel_formato ENUM ( 'Digital', ' 3D' , 'Imax', '2D', '4D', 'Macro XE');

# 3. Elimna el índice del país de nacimiento en la tabla actor
ALTER TABLE actor
	DROP INDEX idx_pais_de_nacimiento;

# 4. Elimina el atributo del país de nacimiento de la tabla actor
ALTER TABLE actor 
	DROP COLUMN act_pais_de_nacimiento;

# 5. Crea un atributo de nacionalidad con tipo VARCHAR (40) en la tabla actor, después del atributo nombre_real y hazlo NOT NULL.
ALTER TABLE actor 
	ADD act_nacionalidad VARCHAR (40) NOT NULL AFTER act_nombre_real;

# 6. Crea un indice para la nacionalidad en la tabla actor.
ALTER TABLE actor 
	ADD INDEX idx_nacionalidad (act_nacionalidad);

# 7. Cambia el nombre del atributo ele_papel por ele_rol en la tabla elenco.
ALTER TABLE elenco 
	CHANGE ele_papel ele_rol ENUM ('Protagónico', 'Soporte', 'Extra');
    
# 8. Elimina el indice para la clasificación de la pelicula en la tabla pelicula.
ALTER TABLE pelicula 
	DROP INDEX idx_clasificacion;
*/


# 2. INSERCIÓN
# Insertar datos en la BD de películas:

# 4 películas de cada género: acción, fantasía, drama y terror, considera clasificaciones AA, A, B15, C y D

INSERT INTO pelicula (pel_titulo, pel_genero, pel_clasificacion, pel_duracion, pel_director, pel_fecha_estreno)
	VALUES ('Avengers: Infinity War', 'Acción', 'B', 149, 'Anthony Russo', '2018-04-27'),
		   ('Hanna', 'Acción', 'B', 111, 'Joe Wright', '2011-04-08'),
		   ('Lucy', 'Acción', 'B-15', 90, 'Luc Besson', '2014-08-29'),
		   ('Black Panther: Wakanda Forever', 'Acción', 'B', 161, 'Ryan Coogler', '2022-11-10');
    
INSERT INTO pelicula (pel_titulo, pel_genero, pel_clasificacion, pel_duracion, pel_director, pel_fecha_estreno)
	VALUES ('Alicia en el país de las maravillas', 'Fantasía', 'A', 108, 'Tim Burton', '2010-03-10'),
		   ('Dune 2', 'Fantasía', 'B', 155, 'Denis Villeneuve', '2023-11-03'),
		   ('Animales Fantásticos', 'Fantasía', 'B', 105, 'Tim Burton', '1990-12-07'),
		   ('La Cenicienta', 'Fantasía', 'A', 160, 'Kenneth Branagh', '2015-03-13');
           
INSERT INTO pelicula (pel_titulo, pel_genero, pel_clasificacion, pel_duracion, pel_director, pel_fecha_estreno)
	VALUES ('Mujercitas', 'Drama', 'A', 135, 'Greta Gerwing', '2019-12-25'),
		   ('Jane Eyre', 'Drama', 'B', 120, 'Cary Fukunaga', '2011-03-11'),
		   ('Rebecca', 'Drama', 'PG-13', 123, 'Ben Wheatley', '2020-10-16'),
		   ('Orgullo y prejuicio', 'Drama', 'A', 127, 'Joe Wright', '2006-02-10');
    
INSERT INTO pelicula (pel_titulo, pel_genero, pel_clasificacion, pel_duracion, pel_director, pel_fecha_estreno)
	VALUES ('La huérfana', 'Terror', 'B-15', 123, 'Jaume Collet-Serra', '2009-06-24'),
		   ('Alien: Covenant', 'Terror', 'B-15', 123, 'Ridley Scott', '2017-05-07'),
		   ('La monja', 'Terror', 'B', 96, 'Corin Hardy', '2018-09-07'),
		   ('El conjuro', 'Terror', 'B-15', 112, 'James Wan', '2013-08-23');
    
# 3 actores nacidos en cada país: USA, México y Reino Unido

INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Scarlett Ingrid Johansson', 'Scarlett Johansson', '1984-11-22', 'M', 'USA'),
		   ('Saoirse Una Ronan', 'Saoirse Una Ronan', '1994-04-12', 'M', 'USA'),
		   ('Timothée Hal Chalamet', 'Timothée Chalamet', '1995-12-27', 'H', 'USA'),
		   ('Vera Ann Farmiga', 'Vera Farmiga', '1973-08-06', 'M', 'USA'),
		   ('John Christopher Depp II', 'Johnny Depp', '1963-06-09', 'H', 'USA');
           
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Demián Sandero Bichir Nájera', 'Demián Bichir', '1963-08-01', 'H', 'México'),
		   ('José Ténoch Huerta Mejia', 'Tenoch Huerta', '1981-01-29', 'H', 'México'),
		   ('Mitzi Mabel Espinosa Cadena', 'Mabel Cadena', '1990-09-23', 'M', 'México');
           
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Florence Rose Pugh', 'Florence Pugh', '1996-01-03', 'M', 'Reino Unido'),
		   ('Andrew James Matfin Bell', 'Jamie Bell', '1986-03-14', 'H', 'Reino Unido'),
		   ('Thomas Stanley Holland', 'Tom Holland', '1996-06-01', 'H', 'Reino Unido'),
		   ('James Edward Carter', 'Jim Carter', '1948-08-19', 'H', 'Reino Unido'),
		   ('Keira Christina Knightley', 'Keira Knightley', '1985-03-26', 'M', 'Reino Unido'),
		   ('Lily Chloe Ninette Thomson', 'Lily James', '1989-04-05', 'M', 'Reino Unido');
           
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Catherine Élise Blanchett', 'Cate Blanchett', '1969-05-14', 'M', 'Australia'),
		   ('Mia Wasikowska', 'Mia Wasikowska', '1989-10-25', 'M', 'Australia');
		
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Amr Waked​', 'Amr Waked', '1973-04-12', 'H', 'Egipto');
    
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Colin James Farrell', 'Colin Farrell', '1976-05-31', 'H', 'Irlanda');
    
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Michael Fassbender', 'Michael Fassbender', '1977-04-02', 'H', 'Alemania');
    
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Jean Dell', 'Jean Dell', '1961-03-17', 'H', 'Francia');
    
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Donald McNicol Sutherland', 'Donald Sutherland', '1935-07-17', 'H', 'Canadá'),
		   ('Aryana Engineer', 'Aryana Engineer', '2001-03-06', 'M', 'Canadá');
           
INSERT INTO actor (act_nombre_real, act_nombre_artistico, act_fecha_nacimiento, act_genero, act_pais_de_nacimiento)
	VALUES ('Shannon Kook', 'Shannon Kook', '1987-02-09', 'H', 'Sudáfrica');
    
# 2 registros en la tabla elenco para cada película

INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (1, 1, 'Natasha Romanoff', 20000000, 'Protagónico'),
		   (1, 11, 'Peter Parker', '4000000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (2, 2, 'Hanna Heller', 12000000, 'Protagónico'),
		   (2, 15, 'Marissa', '1000000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (3, 1, 'Lucy', 2000000, 'Protagónico'),
		   (3, 17, 'Pierre del Río', '1000000', 'Soporte');
	
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (4, 7, 'Namor', 1000000, 'Protagónico'),
		   (4, 8, 'Namora', '500000', 'Soporte');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (5, 5, 'El sombrerero', 3000000, 'Protagónico'),
		   (5, 16, 'Alicia', '3500000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (6, 3, 'Paul Atreides', 3000000, 'Protagónico'),
		   (6, 9, 'Irulan Corrino', '1500000', 'Protagónico');
	
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (7, 5, 'Gallert Grindelwald', 2000000, 'Protagónico'),
		   (7, 18, 'Lord Percival Graves', '1500000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (8, 13, 'Cenicienta', 10000000, 'Protagónico'),
		   (8, 15, 'La madrastra', '500000', 'Soporte');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (9, 2, 'Jo March', 3000000, 'Protagónico'),
		   (9, 3, 'Laurie', '2500000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (10, 16, 'Jane Eyre', 5000000, 'Protagónico'),
		   (10, 19, 'Edward Rochester', '4000000', 'Protagónico');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (11, 13, 'Mrs de Winter', 10000000, 'Protagónico'),
		   (11, 20, 'Restaurant Maitre D', '500000', 'Extra');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (12, 13, 'Elizabeth Bennet', 20000000, 'Protagónico'),
		   (12, 21, 'Sr. Bennet', '10000', 'Soporte');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (13, 4, 'Kate Coleman', 2000000, 'Protagónico'),
		   (13, 3, 'Max Coleman', '1500000', 'Protagónico');

INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (14, 18, 'Walter', '2000000', 'Protagónico'),
		   (14, 6, 'Lope', 500000, 'Soporte');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (15, 4, 'Lorraine Warren', 6000000, 'Protagónico'),
		   (15, 6, 'Padre Burke', 500000, 'Soporte');
           
INSERT INTO elenco (ele_pel_id, ele_act_id, ele_personaje, ele_salario, ele_papel)
	VALUES (16, 4, 'Lorraine Warren', 8000000, 'Protagónico'),
		   (16, 22, 'Drew', 500000, 'Soporte');
   
/*
# 3. BORRADO
# Borrar datos en la BD de películas:

# Borrar registros en el elenco para película específica (dada por ti), que hayan tenido papel protagónico y cuyo salario sea mayor a 500mil.
DELETE FROM elenco
	WHERE ele_pel_id = 8
		AND ele_papel = 'Protagónico'
        AND ele_salario > 500000;

# Borrar un actor cualquiera con id específico (dado por ti).
DELETE FROM actor
	WHERE act_id = 23;

# Borrar actores que hayan nacido entre 1985 y 1995 y sean de USA o de Reino Unido.
DELETE FROM elenco
	WHERE ele_act_id IN (2, 3, 10, 13, 14);

DELETE FROM actor
	WHERE act_fecha_nacimiento BETWEEN '1985-01-01' AND '1995-12-31'
		AND (act_pais_de_nacimiento = 'USA' OR act_pais_de_nacimiento = 'Reino Unido');
        
# Borrar películas cuyos títulos empiecen con las frase 'el hombre'.
DELETE FROM pelicula
	WHERE pel_titulo LIKE 'el hombre%';

# Borrar las películas que duren menos de 110 minutos y sean del género 'acción'.
DELETE FROM pelicula
	WHERE pel_duracion < '01:50:00'
		AND pel_genero = 'Acción';
*/


# 4. ACTUALIZACIÓN
# Modificar datos en la BD de películas

# Incrementar la duración de todas las películas en 10 minutos.
# UPDATE pelicula 
#	SET pel_duracion = ADDTIME(pel_duracion, '00:10:00');
    
# Cambiar la clasificación de todas las películas 'aa' a 'a'.
UPDATE pelicula
	SET pel_clasificacion = 'A'
    WHERE pel_clasificacion = 'AA'; 
    
# Cambiar el país y la fecha de nacimiento de un actor cualquiera con nombre específico (dado por ti).
UPDATE actor
	SET act_pais_de_nacimiento = 'Reino Unido', act_fecha_nacimiento = '2003-10-20'
    WHERE act_nombre_real = 'Timothée Hal Chalamet';
    
# Cambiar la clasificación y el género de una película cualquiera con título específico (dado por ti).
UPDATE pelicula
	SET pel_clasificacion = 'A', pel_genero = 'Acción'
    WHERE pel_titulo = 'Animales Fantásticos'; 
    
# Cambiar el papel de un actor cualquiera con id específico (dado por ti) en alguna de las películas que haya participado.
UPDATE elenco
	SET ele_papel = 'Protagónico'
	WHERE ele_act_id = 21
		AND ele_pel_id = 12;

# Incrementar en 10000 el salario de todos los actores de una película cualquiera con id específico (dado por ti) y cuyo salario sea menor a 100000.
UPDATE elenco
	SET ele_salario = (ele_salario + 10000)
	WHERE ele_pel_id = 12
		AND ele_salario < 100000;

# Cambiar todos los papeles de 'extra' a 'soporte' en el elenco de una película cualquiera con id específico y cuyo salario esté entre 100000 y 200000.
UPDATE elenco
	SET ele_papel = 'Soporte'
	WHERE ele_papel = 'Extra'
		AND ele_pel_id = 11
        AND ele_salario BETWEEN 100000 AND 200000;

# Cambiar el personaje de un actor con id específico (dado por ti) en una película de id específico (dado por ti).
UPDATE elenco
	SET ele_personaje = 'Hada madrina'
	WHERE ele_act_id = 15
		AND ele_pel_id = 8;
        
# En la bd de películas:

# Recuperar todos los atributos de los actores nacidos en Reino Unido entre 1980 y 1990.
SELECT *
	FROM actor
    WHERE act_pais_de_nacimiento = 'Reino Unido'
		AND act_fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31';

# Recuperar todos los atributos de los actores nacidos en México en cualquiera de los tres años: 1980, 1985 o 1990.
SELECT *
	FROM actor
    WHERE act_pais_de_nacimiento = 'México'
		AND ((act_fecha_nacimiento BETWEEN '1980-01-01' AND '1980-12-31') OR (act_fecha_nacimiento BETWEEN '1985-01-01' AND '1985-12-31') OR (act_fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31'));

# Recuperar el nombre y el nombre real de los actores nacidos en México o USA entre 1970 y 1990 y cuyo nombre contenga el string 'pérez'.
SELECT act_nombre_artistico, act_nombre_real
	FROM actor
    WHERE (act_pais_de_nacimiento = 'México' OR act_pais_de_nacimiento = 'USA')
		AND act_fecha_nacimiento BETWEEN '1970-01-01' AND '1990-12-31'
        AND act_nombre_real LIKE '%Pérez%';

# Recuperar el nombre y el nombre real de los actores y los ids de las películas en los que ha trabajado cada uno.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id
	FROM actor, elenco
    WHERE actor.act_id = ele_act_id;
    
# 5. CONSULTAS 1
# Consultar datos en la BD de películas:

# Recuperar todos los atributos y registros de las películas.
SELECT *
	FROM pelicula;
        
# Recuperar todos los atributos de los actores nacidos en Reino Unido entre 1980 y 1990.
SELECT *
	FROM actor
    WHERE act_pais_de_nacimiento = 'Reino Unido'
		AND act_fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31';
        
# Recuperar todos los atributos de los actores nacidos en USA cuyo nombre real contenga el string 'jackson'.
SELECT *
	FROM actor
    WHERE act_pais_de_nacimiento = 'USA'
        AND act_nombre_real LIKE '%Jackson%';
        
# Recuperar todos los atributos de los actores nacidos en México en cualquiera de los tres años: 1980, 1985 o 1990.
SELECT *
	FROM actor
    WHERE act_pais_de_nacimiento = 'México'
		AND ((act_fecha_nacimiento BETWEEN '1980-01-01' AND '1980-12-31') OR (act_fecha_nacimiento BETWEEN '1985-01-01' AND '1985-12-31') OR (act_fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31'));

# Recuperar el nombre y el nombre real de los actores nacidos en México o USA entre 1970 y 1990 y cuyo nombre real contenga el string 'pérez'.
SELECT act_nombre_artistico, act_nombre_real
	FROM actor
    WHERE (act_pais_de_nacimiento = 'México' OR act_pais_de_nacimiento = 'USA')
		AND act_fecha_nacimiento BETWEEN '1970-01-01' AND '1990-12-31'
        AND act_nombre_real LIKE '%Pérez';
        
# Recuperar el título, el género y la clasificación de las películas con duración mayor a 120 minutos.
SELECT pel_titulo, pel_genero, pel_clasificacion
	FROM pelicula
    WHERE pel_duracion > 120;
        
# Recuperar el título y el género de las películas con duración entre 90 y 120 minutos y clasificación 'aa', 'a', o 'c'.
SELECT pel_titulo, pel_genero
	FROM pelicula
    WHERE pel_duracion BETWEEN 90 AND 120
		AND pel_clasificacion IN ('AA', 'A', 'C');
    
# Recuperar el título y la duración de las películas de género 'acción' con duración menor o igual a 100 minutos y clasificación 'c' o 'd'.
SELECT pel_titulo, pel_duracion
	FROM pelicula
    WHERE pel_genero = 'Acción'
		AND pel_duracion <= 100
		AND pel_clasificacion IN ('C', 'D');


# CROSS JOIN

# Recuperar el nombre y el nombre real de los actores y los ids de las películas en los que ha trabajado cada uno.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id;
        
# Recuperar el nombre y el nombre real de los actores y los ids de las películas en los que ha trabajado cada uno, pero solo aquellos que hayan nacido en USA.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id
		AND actor.act_pais_de_nacimiento = 'USA';
    
# Recuperar el nombre y el nombre real de los actores y los ids de las películas en los que ha trabajado cada uno, pero solo aquellos que hayan nacido en México entre 1970 y 2000.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id
		AND actor.act_pais_de_nacimiento = 'México'
		AND actor.act_fecha_nacimiento BETWEEN '1970-01-01' AND '2000-12-31';
        
# Recuperar el título y el género de las películas y los ids de los actores que trabajaron en cada película junto con el papel que hicieron en ella.
SELECT pelicula.pel_titulo, pelicula.pel_genero, elenco.ele_act_id, elenco.ele_personaje
	FROM pelicula, elenco
    WHERE pelicula.pel_id = elenco.ele_pel_id;
        
# Recuperar el título de las películas de género 'acción' y clasificaciones 'b' o 'c' junto con los ids de los actores que trabajaron en ella y el papel que hicieron.
SELECT pelicula.pel_titulo, elenco.ele_act_id, elenco.ele_personaje
	FROM pelicula, elenco
    WHERE pelicula.pel_id = elenco.ele_pel_id
		AND pelicula.pel_genero = 'Acción'
        AND pel_clasificacion IN ('B', 'C');
       
       
# UNIONES ENTRE TABLAS

# Habíamos visto: Cross Join o unión cruzada directa

# INNER JOIN

# Une dos tablas basado en una condición (condición de unión)
# Devuelve los registros de ambas tablas que cumplen con la condición (Intersección de conjuntos)

# EJERCICIOS

# Recuperar el título de cada película y los ids de los actores que participaron en ella

# Unión cruzada directa (Cross Join)
SELECT pelicula.pel_titulo, elenco.ele_act_id
	FROM pelicula, elenco
    WHERE pelicula.pel_id = elenco.ele_pel_id;
    
# Inner Join
# Similar a la unión cruzada directa.
# Cambia la estructura de la instrucción SELECT
SELECT pelicula.pel_titulo, elenco.ele_act_id
	# Tabla izquierda
    FROM pelicula
    # Tabla derecha
    INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id;
        
# Además de los ids de los actores, recuperar también su nombre (de los actores)
SELECT pelicula.pel_titulo, elenco.ele_act_id, actor.act_nombre_real
    FROM pelicula
    INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# Agregar el personaje que hizo cada actor en cada pelíula que participó y el salario que obtuvo
SELECT pelicula.pel_titulo, elenco.ele_act_id, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
    FROM pelicula
    INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
    
# Quitando los ids para que quede más limpio
SELECT pelicula.pel_titulo, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
    FROM pelicula
    INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# NOTA
# Con Inner Join sólo se recuperan los registros de ambas tablas que tenngan coincidencias.
# Si hay registros que no tienen coincidencias no se recuperan.
# Por ejemplo, si hay películas que no tienen actores asociados, y actores que no han
# participado en películas, por lo que sus títulos o nombre no se recuperan


# LEFT JOIN

# Une dos tablas basado en una condición. Devuelve todos los registros de la tabla izquierda
# (primera tabla), incluso si no hay registros que cumplen la condición de la tabla derecha.
# En caso de que no hauya registros que coincidan en la tabla derecha, se devuelve un registro lleno
# de NULL para empatar con el registro de la izquierda.

# EJERCICIOS

# Recuperar el título de cada película y os ids de los actores que participaron en ella.
# Incluir las películas que no tengan actores que hayan participado en ellas.
SELECT pelicula.pel_titulo, elenco.ele_act_id
    FROM pelicula
    LEFT JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id;
        
# Además incluir el nombre del actor, el personaje que hizo y el salario que cobró en cada peícula
SELECT pelicula.pel_titulo, elenco.ele_act_id, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
    FROM pelicula
    LEFT JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	# Segunda tabla derecha
	LEFT JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# Que pasa siun Inner Join en la segunda unión
# Los registros que tienen NULL en ele_act_d no se devuelven porque no hay coincidencias
# en el atributo act_id en la tabla actor ya que no puiede haber valores NULL en ese atributo, porque es la llave primaria.
SELECT pelicula.pel_titulo, elenco.ele_act_id, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
    FROM pelicula
    LEFT JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# Quitando los ids de los actores para que sea más limpio el resultado
SELECT pelicula.pel_titulo, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
    FROM pelicula
    LEFT JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# RIGHT JOIN

# Une dos tablas basado en una condición. Similar a Left Join pero ahora devuelve todos los registros
# de la tabla derecha, incluso si no hay registros en la tabla izquierda que cumplan con la condición.

# EJERCICIOS

# Devolver el nombre de los actores y los ids de las películas en las que han participado.
# Incluir los actores que no tengan películas asociadas.
SELECT actor.act_nombre_real, elenco.ele_pel_id
    FROM elenco
    RIGHT JOIN actor
		ON elenco.ele_act_id = actor.act_id;

# Además incluir el personaje y salario que hizó y cobró en cada película
SELECT actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje, elenco.ele_salario
    FROM elenco
    RIGHT JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# Incluir el título de la película
# La primera unión se vuelve la tabla de la izquierda, quiero devolver todo eso y sólo pegarle el título
# de la película, que es la tabla derecha.
# Por eso se hace un Left Join en la segunda unión.
SELECT actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje, elenco.ele_salario, pelicula.pel_titulo
    FROM elenco
    RIGHT JOIN actor
		ON elenco.ele_act_id = actor.act_id
	LEFT JOIN pelicula
		ON elenco.ele_pel_id = pelicula.pel_id;
        
# Quitando los ids para que sea más limpio
SELECT actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario, pelicula.pel_titulo
    FROM elenco
    RIGHT JOIN actor
		ON elenco.ele_act_id = actor.act_id
	LEFT JOIN pelicula
		ON elenco.ele_pel_id = pelicula.pel_id;
        
# NOTA
# Cada que se vaya agregandp una nueva tabla para unir, esa nueva tabla es siempre la tabla derecha.
# El resultado de las uniones previas se devuelve siempre la tabla izquierda.

# INNER/LEFT/RIGHT JOIN
# WHERE
# ORDER BY
# LIMIT

SELECT actor.act_nombre, pelicula.pel_titulo, elenco.ele_personaje, elenco.ele_salario
	FROM elenco # Tabla izquierda
	RIGHT JOIN actor # Tabla derecha
		ON actor.act_id= elenco.ele_act_id # El resultado se vuelve la tabla izquierda
	LEFT JOIN pelicula # Segunda tabla derecha
		ON pelicula.pel_id = elenco.ele_pel_id
	WHERE elenco.ele_salario > 500000
	ORDER BY elenco.ele_salario DESC, actor.act_nombre ASC
	LIMIT 2, 3;

# Paso 1: Une la tabla elenco con la tabla actor. Devuelve todos los actores (tabla derecha) aunque no tengan participación en películas
# Paso 2: Une el resultado de la unión previa con la tabla película. Devuelve todos los registros de la tabla anterior, aunque no haya películas asociadas.
# Paso 3: Restringe (filtra) el resultado con la condición WHERE que el salario del actor en la película sea > 500000
# Paso 4: Ordena el resultado primero por salario de forma descendente y luego por el nombre del actor de forma ascendente.
# Paso 5: Limita el resultado a solo 3 registros, a partir de la posición 2.


# Inner Join es conceptualmente similar a Cross Join, pero siempre 

# 6. CONSULTAS 2 | ORDER BY y LIMIT
# Consultar datos en la BD de películas:

# Recuperar el nombre y el nombre real de los actores nacidos en México o USA entre 1970 y 1990. Devolver el resultado ordenado por nombre de forma ascendente.
SELECT act_nombre_artistico, act_nombre_real
	FROM actor
    WHERE act_pais_de_nacimiento IN ('México', 'USA')
		AND act_fecha_nacimiento BETWEEN '1970-01-01' AND '1990-12-31'
	ORDER BY act_nombre_artistico ASC;

# Recuperar el nombre, nombre real y fecha de nacimiento de los actores nacidos en México, Reino Unido o Canadá entre 1980 y 1990. Devolver el resultado ordenado primero por nombre de forma ascendente y luego fecha de nacimiento de forma descendente.
SELECT act_nombre_artistico, act_nombre_real, act_fecha_nacimiento
	FROM actor
    WHERE act_pais_de_nacimiento IN ('México', 'Reino Unido', 'Canadá')
		AND act_fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31'
	ORDER BY act_nombre_artistico ASC, act_fecha_nacimiento DESC;
    
# Recuperar el título, el género y la clasificación de las películas con duración entre de 90 o 120 minutos. Devolver el resultado ordenado primero por género de forma ascendente y luego por título de forma descendente.
SELECT pel_titulo, pel_genero, pel_clasificacion
	FROM pelicula
	WHERE pel_duracion BETWEEN 90 AND 120
    ORDER BY pel_genero ASC, pel_titulo DESC;

# Recuperar el título y el género de las películas con duración entre 70 y 100 minutos con clasificación 'aa', 'a', o 'c'. Devolver el resultado ordenado primero por clasificación de forma descendente y luego por título de forma ascendente.
SELECT pel_titulo, pel_genero
	FROM pelicula
	WHERE pel_duracion BETWEEN 70 AND 100
		AND pel_clasificacion IN ('AA', 'A', 'C')
    ORDER BY pel_clasificacion DESC, pel_titulo ASC;
    
# Recuperar el id del actor, el id de la película y el salario de la tabla elenco, solo para los salarios que sean 1millón o 10millones. Devolver el resultado ordenado primero por papel de forma descendente y luego por salario de forma ascendente.
SELECT ele_act_id, ele_pel_id, ele_salario
	FROM elenco
	WHERE ele_salario IN (1000000, 10000000)
    ORDER BY ele_papel DESC, ele_salario ASC;

# Recuperar el personaje, papel y salario de la tabla elenco, para los ids de actor 1, 3 y 5. Devolver el resultado ordenado por personaje de forma descendente y luego por papel de forma descendente. 
SELECT ele_personaje, ele_papel, ele_salario
	FROM elenco
	WHERE ele_act_id IN (1, 3, 5)
    ORDER BY ele_personaje DESC, ele_papel DESC;
    
# Recuperar todos los atributos de los actores nacidos en México en cualquiera en los años 1980 y 1990. Devolver el resultado ordenado por nombre de forma descendente. Devolver solo los primeros 3 registros.
SELECT *
	FROM actor
	WHERE act_pais_de_nacimiento = 'México'
		AND ((act_fecha_nacimiento BETWEEN '1980-01-01' AND '1980-12-31') OR (act_fecha_nacimiento BETWEEN '1990-01-01' AND '1990-12-31'))
	ORDER BY act_nombre_artistico DESC
    LIMIT 3;

# Recuperar todos los atributos de los elencos. Devolver el resultado ordenado por salario de forma ascendente. Devolver solo 4 registros a partir de la posición 5.
SELECT *
	FROM elenco
    ORDER BY ele_salario ASC
    LIMIT 5, 4;

# Recuperar todos los atributos de las películas. Devolver el resultado ordenado primero por género de forma ascendente y luego por título de forma ascendente. Devolver solo 5 registros a partir de la posición 3.
SELECT *
	FROM pelicula
    ORDER BY pel_genero ASC, pel_titulo ASC
    LIMIT 3, 5;

# CROSS JOIN

# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado y el personaje que hicieron. Devolver el resultado ordenado por nombre de forma ascendente. Devolver solo 4 registros a partir de la posición 3.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id
    ORDER BY actor.act_nombre_artistico ASC
    LIMIT 3, 4;

# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado y el personaje que hicieron, pero solo aquellos que hayan nacido en USA o México. Devolver el resultado ordenado por personaje de forma ascendente. Devolver solo los primero 5 registros.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id
		AND act_pais_de_nacimiento IN ('México', 'USA')
    ORDER BY elenco.ele_personaje ASC
    LIMIT 5;
    
# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado, el personaje que hicieron y su salario, pero solo aquellos que nacieron en USA o Reino Unido entre 1970 y 1975 y entre 1980 y 1985. Devolver el resultado ordenado primero por salario de forma ascendente y luego por nombre de forma descendente. Devolver solo 3 registros a partir de la posición 2.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje, elenco.ele_salario
	FROM actor, elenco
    WHERE actor.act_id = elenco.ele_act_id
		AND act_pais_de_nacimiento IN ('USA', 'Reino Unido')
        AND ((act_fecha_nacimiento BETWEEN '1970-01-01' AND '1975-12-31') OR (act_fecha_nacimiento BETWEEN '1980-01-01' AND '1985-12-31'))
    ORDER BY elenco.ele_salario ASC, actor.act_nombre_artistico DESC
    LIMIT 2, 3;

# Recuperar el nombre de los actores, el título de las películas en las que participaron, el personaje que hicieron y su salario, pero solo aquellos que nacieron en USA. Devolver el resultado ordenado primero por nombre de forma ascendente y luego por título de película de forma ascendente. Devolver solo los primeros 5 registros.
SELECT actor.act_nombre_artistico, pelicula.pel_titulo, elenco.ele_personaje, elenco.ele_salario
	FROM actor, pelicula, elenco
    WHERE ((actor.act_id = elenco.ele_act_id) AND (pelicula.pel_id = elenco.ele_pel_id))
		AND act_pais_de_nacimiento = 'USA'
        ORDER BY actor.act_nombre_artistico ASC, pelicula.pel_titulo ASC
    LIMIT 5;


# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT) ORDER BY, LIMIT
# Consultar datos en la BD de películas:

# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado y el personaje que hicieron. Devolver el resultado ordenado por nombre de forma ascendente. Devolver solo 4 registros a partir de la posición 3.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje
	FROM actor
    INNER JOIN elenco
		ON actor.act_id = elenco.ele_act_id
    ORDER BY actor.act_nombre_artistico ASC
    LIMIT 3, 4;

# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado y el personaje que hicieron, pero solo aquellos que hayan nacido en USA o México. Devolver el resultado ordenado por personaje de forma ascendente. Devolver solo los primero 5 registros.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje
	FROM actor
    INNER JOIN elenco
		ON actor.act_id = elenco.ele_act_id
	WHERE actor.act_pais_de_nacimiento IN ('USA', 'México')
    ORDER BY elenco.ele_personaje ASC
    LIMIT 5;

# Recuperar el nombre y el nombre real de los actores, los ids de las películas en las que ha trabajado, el personaje que hicieron y su salario, pero solo aquellos que nacieron en USA o Reino Unido entre 1970 y 1975 y entre 1980 y 1985. Devolver el resultado ordenado primero por salario de forma ascendente y luego por nombre de forma descendente. Devolver solo 3 registros a partir de la posición 2.
SELECT actor.act_nombre_artistico, actor.act_nombre_real, elenco.ele_pel_id, elenco.ele_personaje, elenco.ele_salario
	FROM actor
    INNER JOIN elenco
		ON actor.act_id = elenco.ele_act_id
	WHERE actor.act_pais_de_nacimiento IN ('USA', 'Reino Unido')
		AND ((YEAR(actor.act_fecha_nacimiento) BETWEEN 1970 AND 1975) OR (YEAR(actor.act_fecha_nacimiento) BETWEEN 1980 AND 1985))
    ORDER BY elenco.ele_salario ASC, actor.act_nombre_artistico DESC
    LIMIT 2, 3;

# Recuperar el nombre de los actores, el título de las películas en las que participaron, el personaje que hicieron y su salario, pero solo aquellos que nacieron en USA. Devolver el resultado ordenado primero por nombre de forma ascendente y luego por título de película de forma ascendente. Devolver solo los primeros 5 registros.
SELECT actor.act_nombre_artistico, pelicula.pel_titulo, elenco.ele_personaje, elenco.ele_salario
	FROM actor
    INNER JOIN elenco
		ON actor.act_id = elenco.ele_act_id
	INNER JOIN pelicula
		ON elenco.ele_pel_id = pelicula.pel_id
	WHERE actor.act_pais_de_nacimiento = 'USA'
    ORDER BY actor.act_nombre_artistico ASC, pelicula.pel_titulo ASC
    LIMIT 5;


# FUNCIONES RÁPIDAS

# CHAR_LENGTH(s) 
# Devuelve la longitud de la cadena(s) en caracteres
SELECT pel_titulo, CHAR_LENGTH(pel_titulo) AS longitud
	FROM pelicula;
    
# MAX
# Devuelve el valor máximo de un atributo
# Con VARCHAR, devuelve el string con valores máximos en la tabla de codificación 
# Aproximación al orden alfabético (orden lexicográfico)
# Con DATE, devuelve. la fecha más reciente
SELECT MAX(pel_titulo), MAX(pel_duracion), MAX(pel_fecha_estreno)
	FROM pelicula;

# MIN
# Devuelve el valor mínimo de un atributo
# Con VARCHAR, devuelve el string con valores mínimo en la tabla de codificación 
# Aproximación al orden alfabético (orden lexicográfico)
# Con DATE, devuelve. la fecha más antigua
SELECT MIN(pel_titulo), MIN(pel_duracion), MIN(pel_fecha_estreno)
	FROM pelicula;

SELECT MAX(CHAR_LENGTH(pel_titulo)) AS mas_largo, MIN(CHAR_LENGTH(pel_titulo)) AS mas_corto
	FROM pelicula;
    
# SUBSTR
# (s, p, n)
# Devuelve el substring de la cadena s, empezando en la posición p y considerando n caracteres

SELECT pel_titulo, SUBSTR(pel_titulo, 3, 5)
	FROM pelicula;

# AGRUPAMIENTO DE CONSULTAS

# Agrupar datos de acuerdo con un criterio.

# GROUP BY [nombre_columnal],
# 		   [nombre_columna2],
#		   [nombre_columna3],
#		   ...

# Agrupar (agregar) un conjunto de registros en otro conjunto de registros que resumen
# los valores de las columnas indicadas. Esta sección devuelve un registro por cada
# conjunto. En otras palabras, reduce el número de registros en el resultado de la consulta.

# Agrupa las películas de acuerdo con la columna pel_clas.
SELECT *
	FROM pelicula
	GROUP BY pel_clas; 
    
# Devuelve un registro de cada grupo.
# No hay un criterio para seleccionar al registro que se devuelve, a veces, es el primero.

# GROUP BY se suele utilizar para agregar datos de cada grupo.
# (Generalmente) se utiliza con funciones que agreguen valores de los registros de cada grupo.
# Algunas funciones que se aplican sobre los registros de los grupos:

# COUNT: Cuenta el número de valores (registros) en cada grupo

# Agrupa las películas de acuerdo con la columna pel_clas.
# Devuelve la clasificación y cuenta el número de registros en cada clasificación.
SELECT pel_clas, COUNT(pel_clas)
	FROM pelicula
	GROUP BY pel_clas; 

# Paso 1: Agrupa por clasificación
# Paso 2: Cuenta (COUNT) cuántos registros hay en cada grupo.

# Agrupa las películas de acuerdo con la columna pel_genero.
# Devuelve el género y cuenta el número de registros en cada género.
SELECT pel_genero, COUNT(pel_genero)
	FROM pelicula
	GROUP BY pel_genero; 


# SUM: Suma los valores de cada grupo (datos numéricos)

# Agrupa las películas de acuerdo con la columna pel_clas.
# Devuelve la clasificación, cuenta el número de registros # en cada clasificación, y suma la duración de las películas
# de cada clasificación
SELECT pel_clas, COUNT(pel_clas), SUM(pel_duracion)
	FROM pelicula
	GROUP BY pel_clas; 

# Paso 1: Agrupa por clasificación
# Paso 2: Cuenta (COUNT) cuántos registros hay en cada clasificación
# Paso 3: Suma las duraciones de las películas en cada clasificación.


# AVG: Calcula el promedio de los valores de cada grupo (datos numéricos)

# Agrupa las películas de acuerdo con la columna pel_clas.
# Devuelve la clasificación, cuenta el número de registros en cada clasificación, suma la duración de las películas 
# de cada clasificación, y calcula el promedio de la duración de las películas en cada clasificación.
SELECT pel_clas,
		COUNT(pel_clas),
		SUM(pel_duracion),
		AVG(pel_duracion)
	FROM pelicula
	GROUP BY pel_clas; 

# Paso 2: Cuenta (COUNT) cuántos registros hay en cada clasificación
# Paso 3: yume las duraciones de las películas en cada clasificación.
# Paso 4: Calcula el promedio de la duración de las películas en cada clasificación.


# MIN: Devuelve el valor mínimo de cada grupo
# MAX: Devuelve el valor mínimo de cada grupo

SELECT pel_clas,
		COUNT (pel_clas),
		SUM(pel_duracion),
		AVG(pel_duracion),
		MIN(pel_duracion),
		MAX (pel_duracion)
	FROM pelicula
	GROUP BY pel_clas;

# Paso 1: Agrupa por clasificación
# Paso 2: Cuenta (COUNT) cuántos registros hay en cada clasificación
# Paso 3: Suma las duraciones de las películas en cada clasificación.
# Paso 4: Calcula el promedio de la duración de las películas en cada clasificación.
# Paso 5: Devuelve la duración mínima y máxima de las películas en cada clasificación.


# USO DE ALIAS
# USO DE ORDER BY

# EL ORDER BY actúa sobre el resultado de los grupos

SELECT pel_clas,
		COUNT(pel_clas) AS num_peliculas,
		SUM(pel_duracion) AS duracion_total,
		AVG(pel_duracion) AS duracion_promedio,
		MIN(pel_duracion) AS duracion_minima,
		MAX(pel_duracion) AS duracion_maxima
	FROM pelicula
	GROUP BY pel_clas
	ORDER BY duracion_promedio DESC;

# Paso 1: Agrupa por clasificación
# Paso 2: Cuenta (COUNT) cuántos registros hay en cada clasificación
# Paso 3: Suma las duraciones de las películas en cada clasificación.
# Paso 4: Calcula el promedio de la duración de las películas en cada clasificación.
# Paso 5: Devuelve la duración mínima y máxima de las películas en cada clasificación.
# Paso "6": Le cambia el nombre a las columnas resultantes de la consulta
# Paso 7: Ordena el resultado de acuerdo con la columna duracion_promedio

SELECT pel genero, pel _clas
	FROM pelicula
	GROUP BY pel_genero, pel_clas;
    
# Paso 1: Agrupa por genero, y después por clasificación.
# (terror, B15)
# (terror, A)
# (terror, C)
# (comedia, A)
# (comedia, B15)

SELECT pel genero, pel _clas, COUNT(*) AS cuenta
	FROM pelicula
	GROUP BY pel_genero, pel_clas;
    
# Paso 1: Agrupa por genero, y después por clasificación.
# Paso 2: Cuenta cuantos registros hay en cada grupo de (genero, clasificación)
# (terror, B15)
# (terror, A)
# (terror, C)
# (comedia, A)
# (comedia, B15)
# ...

SELECT pel_genero, pel_clas, COUNT(*) AS cuenta
	FROM pelicula
	GROUP BY pel_genero, pel_clas;
# Paso 1: Agrupa por genero, y después por clasificación.
# Paso 2: Cuenta cuantos registros hay en cada grupo de (genero, clasificación)
# (terror, B15) -> 3
# (terror, C) -> 1
# (accion, A) -> 4
# ...


# FUNCIONES RÁPIDAS

# YEAR (DATE) - Obtiene la parte del año de un dato DATE/DATETIME
# MONTH (DATE) - Obtiene la parte del mes de un dato DATE/DATETIME
# DAY (DATE) - Obtiene la parte del día de un dato DATE/DATETIME

# Extrae las partes individuales de la fecha de estreno # de las películas (año, mes, día).
SELECT pel_titulo,
		pel_fecha_estreno,
		YEAR(pel_fecha_estreno),
		MONTH (pel_fecha_estreno),
		DAY (pel_fecha_estreno)
	FROM pelicula;


# CON GROUP BY

SELECT MONTH(pel_fecha_estreno) AS mes_estreno,
		COUNT(*) AS pels_por_mes
	FROM pelicula
	GROUP BY mes_estreno;

# Paso 1: Extrae el mes de la fecha de estreno de cada película
# Paso 2: Agrupa por el mes de la fecha de estreno.
# Paso 3: Cuenta cuántas películas hay en cada mes de la fecha de estreno.

# Nota: El * es un comodín que considera cualquier columna.
# Si hago referencia directa a una columna en a función de agrupamiento, 
# si esta columna tiene un NULL en algún registro, ese registro no cuenta para el agrupamiento.
# Si se utiliza el comodín * y cualquier columna tiene un valor en el registro ese registro cuenta para el agrupamiento.

# CONDICIONES (FILTRADO) SOBRE GRUPOS

# La sección WHERE no funciona sobre el resultado del agrupamineto, sólo funciona a nivel de registros sencillos.
# Si quiero hacer un filtrado de los registros resultantes de un agrupamiento,
# necesito utilizar la sección HAVING (es como un WHERE pero aplicado sobre el resultado del GROUP BY).

SELECT act_pais_nac AS pais_nac,
		COUNT(*) AS actores_por_pais
	FROM actor
	GROUP BY pais_nac;
    
# Paso 1: Agrupa por país de nacimiento
# Paso 2: Cuenta cuántos actores hay en cada país

SELECT act_pais_nac AS pais_nac,
		COUNT(*) As actores_por_pais
	FROM actor
	GROUP BY pais_nac
	HAVING actores_por_pais > 3;

# Paso 1: Agrupa por país de nacimiento
# Paso 2: Cuenta cuántos actores hay en cada país.
# Paso 3: Filtra los países que tengan 3 o menos actores.

SELECT MONTH(act_fecha_nac) AS mes_nac,
		COUNT(*) actores_por_mes
	FROM actor
	GROUP BY mes_nac
	HAVING actores_por_mes > 1;
    
# Paso 1: Extrae el mes de la fecha de nacimiento
# Paso 2: Agrupa de acuerdo con el mes de la fecha de nacimiento
# Paso 3: Cuenta cuántos actores hay en cada mes de la fecha de nacimiento
# Paso 4: Filtra el resultado del agrupamiento por los meses que tengan más de un actor

SELECT pel_genero,
		pel_clas,
		COUNT(*) AS cuenta
	FROM pelicula
	GROUP BY pel_genero, pel_clas
	HAVING cuenta BETWEEN 3 AND 4;
    
# Paso 1: Agrupa los registros por la combinación de pel_genero y pel_clas
# Paso 2: Cuenta cuántas películas hay en cada grupo
# Paso 3: Filtra los resultados del agrupamiento por la combinación que tenga 3 o 4 películas

# Igual que arriga, pero con el operador de pertenencia
SELECT pel_genero,
		pel_clas,
		COUNT(*) AS cuenta
	FROM pelicula
	GROUP BY pel_genero, pel_clas
	HAVING cuenta IN (3, 4);


# ORDEN DE EJECUCIÓN

# INNER/LEFT/RIGHT JOIN
# WHERE
# GROUP BY
# HAVING
# ORDER BY
# LIMIT

SELECT pel_clas,
		COUNT(*) AS num_peliculas,
		SUM(pel_duracion) AS duracion_total,
		AVG (pel_duracion) AS duracion_promedio,
		MIN(pel_duracion) AS duracion_minima, MAX (pel _duracion) AS duracion_maxima
    FROM pelicula
	GROUP BY pel_clas
	HAVING duracion_minima > 110
	ORDER BY duracion_promedio DESC;
    
# Paso 1: Agrupa las películas por clasificación
# Paso 2: Cuenta cuántas películas hay en cada clasificación
# Paso 3: Suma, calcula el promedio, el mínimo y el máximo de la duración de las películas en cada clasificación
# Paso 4: Filtra el resultado del agrupamiento por la duración mínima › 110
# Paso 5: Ordena el regultado por la duración promedio de forma descendente

SELECT pel_clas,
		COUNT(*) AS num_peliculas,
		SUM(pel_duracion) AS duracion_total,
		AVG(pel_duracion) AS duracion_promedio,
		MIN(pel_duracion) AS duracion_minima,
		MAX(pel_duracion) AS duracion_maxima
	FROM pelicula
	GROUP BY pel_clas
	HAVING duracion_minima > 110
	ORDER BY duracion_promedio DESC
	LIMIT 1;
    
# Paso 1: Agrupa las películas por clasificación
# Paso 2: Cuenta cuántas películas hay en cada clasificación
# Paso 3: Suma, calcula el promedio, el mínimo y el máximo de la duración de las películas en cada clasificación
# Paso 4: Filtra el resultado del agrupamiento por la duración mínima › 110
# Paso 5: Ordena el resultado por la duración promedio de forma descendente.
# Paso 6: Limita el resultado a solo 1 registro


# Agrupando a partir de una unión de tablas

SELECT pelicula.pel_titulo, pelicula.pel_genero, elenco.ele_act_id
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id;
        
SELECT pelicula.pel_titulo, pelicula.pel_genero, elenco.ele_act_id
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	WHERE pelicula.pel_genero IN ('terror', 'accion');
    
SELECT pelicula.pel _titulo,
		pelicula.pel_genero,
		elenco.ele_act_id,
		COUNT(*)
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	WHERE pelicula.pel_genero IN ('terror', 'accion')
	GROUP BY pelicula.pel_genero;
    
SELECT pelicula.pel_genero,
		COUNT(*) AS actores_por_genero
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id= elenco.ele_pel_id
	WHERE pelicula.pel_genero IN ('terror', 'accion')
	GROUP BY pelicula.pel_genero;

SELECT pelicula.pel _genero,
		COUNT(*) AS actores_por_genero
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	#WHERE pelicula.pel _genero IN ('terror', 'accion"')
	GROUP BY pelicula.pel_genero
	ORDER BY pelicula.pel_genero DESC;
    
SELECT pelicula.pel_genero,
		COUNT(*) AS actores_por_genero
	FROM pelicula
	INNER JOIN elenco
		ON pelicula.pel_id = elenco.ele_pel_id
	#WHERE pelicula.pel _genero IN ('terror', 'accion')
	GROUP BY pelicula.pel_genero
	HAVING actors_por_genero > 5
	ORDER BY pelicula.pel_genero DESC;

# Paso 1: Une la tabla película con la tabla elenco, sólo devuelve la intersección de las unión.
# Paso 2: Agrupa el resultado de la unión previa de acuerdo con el género de las películas
# Paso 3: Cuenta cuántos registros hay en cada género, esto corresponde a cuantos actores hay en cada género de películas.
# Paso 4: Filtra el resultado del agrupamiento por el número de actores en' el género de película.
# Paso 5: Ordena el resultado por el género.

# SUBCONSULTAS

# Una subconsulta es una instrucción SELECT dentro de otra instrucción SELECT

# Una subconsulta puede regressar un escalar (un único valor), un registro (un único renglón), o una tabla 
# (uno o más registros, con una o más columnas)

# Básicamente, tomar el resultado de una consulta y utilizarlo como tabla temporal para otra consulta

# NOTA:
# El resultado de una subconsulta, también se puede utilizar en las instrucciones DELETE y UPDATE


# EJERCICIOS

# Devolver el título de las películas con la duración más larga de todas

# Paso 1: Obtener la duración más larga de todas las películas
SELECT MAX(pelicula.pel_duracion) AS duracion_maxima
	FROM pelicula;

# NOTA:
# Las funciones agregativas (MAX, MIN, AVG, SUM) devuelven siempre un sólo valor, ya sea general o uno
# para cada grupo cuando se usan con el GROUP BY

# Paso 2: Obtener el titulo de las peliculas (solo)
SELECT pelicula.pel_titulo
	FROM pelicula;
    
# Paso 3: Obtener el título de las películas con la duración más larga
SELECT pelicula.pel_titulo, MAX(pelicula.pel_duracion) AS duracion_maxima
	FROM pelicula;
    
# Sólo devuelve un registro, ya que devuelve siempre el mínimo de registros de acuerdo con la consulta.
# La función MAX sólo devuelve un valor

# Si lo pongo así, MYSQL en la primera columna pel_titulo me devuelve el valor de esa columna en el primer registro
# MAXX(pel_duracion) si devuelve la duración maxima

# Están sucediendo dos cosas:
# 1. MAX() devuelve el valor máximo de la columna indicada, por lo tanto, trabaja a nivel de toda la tabla (o de grupos)
# y sólo me devuelve un valor general (o para cada grupo).
# 2. Como MAX() sólo devuelve un valor, las otras comlumnas que se devuelvan también tendrán solo un valor.
# Si utilizan una columna sencilla (por ejemplo pel_titulo), MYSQL devolverá el primer valor que se encuentre en esa columna.

# USANDO UNA SUBCONSULTA

# Se renombra la tabla que calcula el valor máximo como q2 y se utiliza el atributo de esa tabla para comparar con la 
# duración de todas las películas
SELECT pelicula.pel_titulo, pelicula.pel_duracion
	FROM pelicula
    INNER JOIN
		(SELECT MAX(pelicula.pel_duracion) AS duracion_maxima
	FROM pelicula) AS q2
	ON pelicula.pel_duracion = q2.duracion_maxima;
    
# Devolver el nombre del actor con el salario más alto en todas las películas

# Paso 1: Sacar el salario máximo de la tabla elenco
SELECT MAX(elenco.ele_salario) AS salario_maximo
	FROM elenco;
    
# Paso 2: Obtener el id y el nombre del actor
SELECT elenco.ele_act_id, elenco.ele_salario
	FROM elenco;
    
# Paso 3: Obtener el id, el nombre y el salario máximo de todas las películas
SELECT elenco.ele_act_id, elenco.ele_salario
	FROM elenco
    INNER JOIN 
		(SELECT MAX(elenco.ele_salario) AS salario_maximo
			FROM elenco) AS q2
	ON elenco.ele_salario = q2.salario_maximo;

# Paso 4: Obtener el id, el nombre y el salario de cada actor en cada pelicula
SELECT elenco.ele_act_id, elenco.ele_salario
	FROM elenco
    INNER JOIN 
		(SELECT MAX(elenco.ele_salario) AS salario_maximo
			FROM elenco) AS q2
	ON elenco.ele_salario = q2.salario_maximo;

# Paso 5: Unir la tabla resultante con la tabla actor
SELECT elenco.ele_act_id, elenco.ele_salario
	FROM elenco
    INNER JOIN 
		(SELECT MAX(elenco.ele_salario) AS salario_maximo
			FROM elenco) AS q2
		ON elenco.ele_salario = q2.salario_maximo
    INNER JOIN actor
		ON actor.act_id = elenco.ele_act_id;
        
# Recuperar el título de cada película, el salario más alto de cada película, el nombre del actor que tuvo ese salario y que personaje hizo.

# Paso 1: Recuperar todas las columnas de las películas
SELECT *
	FROM pelicula;
    
# Paso 2: Recuperar el salario más alto por película
SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS salario_maximo
	FROM elenco
    GROUP BY elenco.ele_pel_id;
    
# Paso 3: Unir las consultas previas para obtener el título de la película y el salario más alto por película
SELECT pelicula.pel_id, pelicula.pel_titulo, salario_maximo
	FROM pelicula
    INNER JOIN
		(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS salario_maximo
			FROM elenco
			GROUP BY elenco.ele_pel_id) AS q2
	ON pelicula.pel_id = q2.ele_pel_id;
    
# Paso 4: Recuperar el id del actor con el salario mas alto por pelicula
SELECT elenco.ele_pel_id, elenco.ele_act_id, elenco.ele_salario
	FROM elenco
	INNER JOIN
		(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS sal_max
			FROM elenco
			GROUP BY elenco.ele_pel_id) AS q2
	ON elenco.ele_salario = q2.sal_max
		AND elenco.ele_pel_id = q2.ele_pel_id;

# Paso 5: Agregar el personage que hi2o el actor en esa pelicula
SELECT eLenco.ele_pel_id, elenco.ele_act_ad, elenco.ele_personaje, elenco.ele_salario
	FROM elenco
		INNER JOIN
			(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS sal_max
				FROM elenco
				GROUP BY elenco.ele_pel_id) AS q2
		ON elenco.ele_salario = q2.sal_max
			AND elenco.ele_pel_id = q2.ele_pel_id;

# Paso 6: Agregar el título de la película
SELECT elenco.ele_pel_id, pelicula.pel_titulo, elenco.ele_act_id, elenco.ele_personaje, elenco.ele_salario
	FROM elenco
	INNER JOIN
		(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS salario_maximo
			FROM elenco
			GROUP BY elenco.ele_pel_id) AS q2
	ON elenco.ele_salario = q2.salario_maximo
		AND elenco.ele_pel_id= q2.ele_pel_id
	INNER JOIN pelicula
		ON q2.ele_pel_id = pelicula.pel_id;

# Paso 7: Agregar el nombre y el nombre real del actor
SELECT elenco.ele_pel_id, pelicula.pel_titulo, elenco.ele_act_id, actor.act_nombre, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
	FROM elenco
	INNER JOIN
		(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS sal_max
			FROM elenco
			GROUP BY elenco.ele_pel_id) AS q2
	ON elenco.ele_salario = q2.sal_max
		AND elenco.ele_pel_id = q2.ele_pel_id
	INNER JOIN pelicula
		ON q2.ele_pel_id = pelicula.pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
        
# Paso 8: Quitar los ids
SELECT pelicula.pel_titulo, actor.act_nombre, actor.act_nombre_real, elenco.ele_personaje, elenco.ele_salario
	FROM elenco
	INNER JOIN
		(SELECT elenco.ele_pel_id, MAX(elenco.ele_salario) AS sal_max
			FROM elenco
			GROUP BY elenco.ele_pel_id) AS q2
	ON elenco.ele_salario = q2.sal_max
		AND elenco.ele_pel_id = q2.ele_pel_id
	INNER JOIN pelicula
		ON q2.ele_pel_id= pelicula.pel_id
	INNER JOIN actor
		ON elenco.ele_act_id = actor.act_id;
