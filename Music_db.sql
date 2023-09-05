# Created by : Anguiano Cabrera Keyla Leilani
# Date : 10 / 02 / 20203
# Definition : Crerar una base de datos para controlar la información de un catálogo musical

# Crear el edificio (o el espacio) en el que colocamos
# las tablas

CREATE DATABASE IF NOT EXISTS musica_db; # Crea la base de datos si no existe, si ya existe, ignora la instrucción

#Abrir la base de datos para poner cosas dentro de ella
USE musica_db;

# Super llaves para la tabla interprete
# [nombre]

# Llaves candidatas para la tabla interprete
# [nombre]

# Llaves primaria
# [id]

# Llaves alterna
# [nombre]

# Crear la tabla interprete
CREATE TABLE IF NOT EXISTS interprete (
	inte_id INT NOT NULL AUTO_INCREMENT,
	inte_nombre VARCHAR (25) NOT NULL,
    
    PRIMARY KEY (inte_id),
    
    INDEX idx_nombre (inte_nombre)
    
);

# Super llaves
# [titulo], [titulo, canciones], [titulo, genero], [titulo, interprete], [titulo, anio]
# [titulo, produuctora], [titulo, canciones, genero], [titulo, canciones, interprete]
# [titulo, canciones, anio], [titulo, canciones, productora], [titulo, genero, interprete]
# [titulo, genero, anio], [titulo, genero, productora], [titulo, interprete, anio]
# [titulo, interprete, productora], [titulo, anio, productora], [titulo, canciones, genero, interprete, anio]
# [titulo, canciones, genero, interprete, productora], [titulo, canciones, genero, anio, productora]
# [titulo, canciones, interprete, anio, productora]
# [titulo, canciones, genero, interprete, anio, productora]

# Llaves candidatas para la tabla disco
# [titulo]

# Llaves primaria
# [id]

# Llaves alterna
# [titulo]

# Crear la tabla disco
CREATE TABLE IF NOT EXISTS disco (
	dis_id INT NOT NULL AUTO_INCREMENT,
	dis_titulo VARCHAR (50) NOT NULL,
	dis_n_canciones INT,
	dis_genero VARCHAR (15),
	dis_id_interprete INT NOT NULL,
    dis_anio YEAR NOT NULL,
    dis_productora VARCHAR (30) NOT NULL,
    
    PRIMARY KEY (dis_id),
								
    INDEX idx_titulo (dis_titulo),    
    INDEX idx_genero (dis_genero),    
    INDEX idx_interprete (dis_id_interprete), 
    
    UNIQUE uni_titulo_genero_interprete (dis_titulo, dis_genero, dis_id_interprete),
    
    CONSTRAINT fk_inte_dis
		FOREIGN KEY (dis_id_interprete)
		REFERENCES interprete (inte_id)
        
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

# Super llaves
# [titulo], [pista], [titulo, disco], [titulo, pista], [titulo, duracion]

# Llaves candidatas
# [titulo]
# [pista]

# Llave primaria
# [id]

# Llaves alternativas
# [titulo]
# [pista]

# Crear la tabla canción
CREATE TABLE IF NOT EXISTS cancion (
	can_id INT NOT NULL AUTO_INCREMENT,
	can_titulo VARCHAR (40) NOT NULL,
	can_id_disco INT,
	can_n_pista INT,
	can_duracion FLOAT NOT NULL,
    
    PRIMARY KEY (can_id),
								
    INDEX idx_titulo (can_titulo),
    
    UNIQUE uni_titulo_disco (can_titulo, can_id_disco),
    
    CONSTRAINT fk_dis_can
		FOREIGN KEY (can_id_disco)
		REFERENCES disco (dis_id)
        
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
# En la base de catálogo musical:

# Crea un atributo de nombre real en la tabla interprete con tipo VARCHAR(50).
ALTER TABLE interprete 
	ADD inte_nombre_real VARCHAR (50);

# Crea un índice para el nuevo atributo de nombre real en la tabla interprete.
ALTER TABLE interprete 
	ADD INDEX idx_nombre_real (inte_nombre_real);

# Elimina la propiedad de unicidad (y el índice) del atributo int_nombre en la tabla interprete.
ALTER TABLE interprete 
	DROP INDEX idx_nombre;

# Cambia el tipo de dato de los atributos duración y número de pista a TINYINT en la tabla cancion.
ALTER TABLE cancion 
	MODIFY can_duracion TINYINT; 
    
ALTER TABLE cancion 
	MODIFY can_num_pista TINYINT;
    
# Crea un índice con la combinación de los atributos sello y anio en la tabla disco.
ALTER TABLE  disco 
	ADD INDEX idx_disquera_anio (dis_productora, dis_anio);

# Cambia el nombre y el tipo de dato del atributo can_titulo por can_nombre y tipo VARCHAR(40) NOT NULL.
ALTER TABLE cancion 
	CHANGE can_titulo can_nombre VARCHAR (40) NOT NULL;
*/


# 2. INSERCIÓN
# Insertar datos en la BD de catálogo musical:

# 4 intérpretes para géneros diversos: reguetón, rock, banda, clásica (el género no está incluido en la tabla intérprete, pero considéralo para incluirlos)

INSERT INTO interprete (inte_nombre)
	VALUES ('Feid');
           
INSERT INTO interprete (inte_nombre)
	VALUES ('Aerosmith');
           
INSERT INTO interprete (inte_nombre)
	VALUES ('Julión Álvares');
           
INSERT INTO interprete (inte_nombre)
	VALUES ('Andrea Bocelli');
           
# 3 discos de cada género de: reguetón, rock, banda, clásica

INSERT INTO disco (dis_titulo, dis_n_canciones, dis_genero, dis_id_interprete, dis_anio, dis_productora)
	VALUES ('Inter Shibuya - La mafia', 15, 'Reggaeton', 1, '2021', 'Universal Music Latino'),
		   ('Feliz cumpleños Ferxxo te pirateamos el álbum', 15, 'Reggaeton', 1, '2022', 'Universal Music Latino'),
		   ('Ferxxo (Vol1:M.O.R)', 16, 'Reggaeton', 1, '2020', 'Universal Music Latino');

INSERT INTO disco (dis_titulo, dis_n_canciones, dis_genero, dis_id_interprete, dis_anio, dis_productora)
	VALUES ('Get a grip', 14, 'Rock', 2, '1993', 'Gaffen Records'),
		   ('I dont want to miss a thing', 3, 'Rock', 2, '1998', 'Decca Records'),
		   ('Aerosmith', 8, 'Rock', 2, '1973', 'Columbia Records');
           
INSERT INTO disco (dis_titulo, dis_n_canciones, dis_genero, dis_id_interprete, dis_anio, dis_productora)
	VALUES ('De hoy en adelante, que te vaya bien', 12, 'Banda', 3, '2022', 'Universal Music Group'),
		   ('Soy lo que quiero.. indispensable', 12, 'Banda', 3, '2013', 'Universal Music Group'),
		   ('Ni diablo ni santo', 13, 'Banda', 3, '2017', 'Universal Music Group');

INSERT INTO disco (dis_titulo, dis_n_canciones, dis_genero, dis_id_interprete, dis_anio, dis_productora)
	VALUES ('Viaggio italiano', 16, 'Clásica', 4, '1995', 'Polydor B.V.'),
		   ('Amore', 15, 'Clásica', 4, '2006', 'Verve Records'),
		   ('Love in portofino', 15, 'Clásica', 4, '2013', 'Verve Records');
           
# 3 canciones para discos de cada género (4 géneros x 3 canciones = 12 canciones en total).

INSERT INTO cancion (can_titulo, can_id_disco, can_n_pista, can_duracion)
	VALUES ('Si tu supieras', 1, 15, '00:03:17'),
		   ('Si te la encuentras por ahí', 2, 6, '00:03:12'),
		   ('Ateo', 3, 2, '00:02:19');
           
INSERT INTO cancion (can_titulo, can_id_disco, can_n_pista, can_duracion)
	VALUES ('Crazy', 4, 8, '00:05:17'),
		   ('I dont want to miss a thing', 5, 1, '00:04:59'),
		   ('Dream on', 6, 4, '00:04:27');
           
INSERT INTO cancion (can_titulo, can_id_disco, can_n_pista, can_duracion)
	VALUES ('Aquí algo cambio', 7, 4, '00:02:46'),
		   ('Y me da vergüenza', 8, 7, '00:03:02'),
		   ('Afuera está lloviendo', 9, 4, '00:03:00');
           
INSERT INTO cancion (can_titulo, can_id_disco, can_n_pista, can_duracion)
	VALUES ('Ave Maria', 10, 7, '00:04:26'),
		   ('Bésame mucho', 11, 7, '00:04:01'),
		   ('Quizás, quizás, quizás', 12, 7, '00:03:18');
    
/*
# 3. BORRADO
# Borrar datos en la BD de catálogo musical:

# Borrar canciones cuyo titulo termine en la palabra 'feliz'.
DELETE FROM cancion
	WHERE can_titulo LIKE '%feliz';
    
# Borrar canciones de un disco cualquiera con id específico (dado por ti) que tengan una duración de menos de 3 minutos
DELETE FROM cancion
	WHERE can_id_disco = 3
		AND can_duracion < '00:03:00';
        
# Borrar canciones que estén el número de pista 5 sean del género clásica o reguetón. **** Revisar
DELETE FROM cancion
	WHERE can_n_pista = 5
		AND ((can_id_disco BETWEEN 1 AND 3) OR (can_id_disco BETWEEN 10 AND 12));

# Borrar un disco cualquiera con título específico (dado por ti).
DELETE FROM disco
	WHERE dis_titulo = 'Ni diablo ni santo';

# Borrar discos con años entre 2010 y 2011 del género rock o banda.
DELETE FROM disco
	WHERE dis_anio BETWEEN 2010 AND 2011
		AND (dis_genero = 'Rock' OR dis_genero = 'Banda');
    
# Borrar discos de un sello específico (dado por ti) y un año específico (dado por ti).
DELETE FROM disco
	WHERE dis_productora = 'Universal Music Latino'
		AND dis_anio = 2021;

# Borrar un intérprete cualquiera con nombre específico (dado por ti).
DELETE FROM interprete
	WHERE inte_nombre = 'Feid';
    
# Borrar intérpretes cuyos nombres contengan el string 'de' en cualquier parte.
DELETE FROM interprete
	WHERE inte_nombre LIKE '%de%';
*/


# 4. ACTUALIZACIÓN
# Modificar datos en la BD de catálogo musical:

# Cambiar el nombre de un intérprete cualquiera con un id específico (dado por ti)
UPDATE interprete
	SET inte_nombre = 'Ferxxo'
	WHERE inte_id = 1;

# Decrementar en uno el año de todos los discos de género reguetón que estén entre los años 2010 y 2020.
UPDATE disco
	SET dis_anio = (dis_anio - 1)
    WHERE dis_genero = 'Reggaeton'
		AND dis_anio BETWEEN 2010 AND 2020;

# Cambiar el género de un disco cualquiera con título específico (dado por ti)
UPDATE disco
	SET dis_genero = 'Clásica'
    WHERE dis_titulo = 'I dont want to miss a thing';

# Cambiar el sello discográfico de todos los discos de un año cualquiera (dado por ti) para un intérprete cualquiera con id específico (dado por ti)
UPDATE disco
	SET dis_productora = 'Universal Music Latino'
    WHERE dis_anio = '2022'
		AND dis_id_interprete = 3;

# Cambiar el género para los discos de género rock a metal para todos los discos de un sello cualquiera (dado por ti) que sean a años anteriores a 1990.
UPDATE disco
	SET dis_genero = 'Metal'
    WHERE dis_genero = 'Rock'
		AND dis_productora = 'Columbia Records'
        AND dis_anio < 1990;

# Cambiar el título y el número de pista para una canción cualquiera con id específico (dado por ti)
UPDATE cancion
	SET can_titulo = 'Normal', can_n_pista = 14
    WHERE can_id = 1;

# Incrementar en 1 minuto la duración de todas las canciones para un disco cualquiera con id específico y cuya duración esté entre 2 y 3 minutos.
UPDATE cancion
	SET can_duracion = ADDTIME(can_duracion, '00:01:00')
    WHERE can_id_disco = 3
		AND can_duracion BETWEEN '00:02:00' AND '00:03:00';

# Incrementar en 1 la pista de todas las canciones que tengan la palabra 'amor' en su título y que tengan una duración menor a 3 minutos.
UPDATE cancion
	SET can_n_pista = (can_n_pista + 1)
    WHERE can_titulo LIKE '%amor%'
		AND can_duracion < '00:03:00';
        
# 5. CONSULTAS 1
# Consultar datos en la BD de catálogo musical:

# Recuperar todos los atributos de los intérpretes para aquellos cuyo nombre termine en el string 'es'.
SELECT *
	FROM interprete
    WHERE inte_nombre LIKE '%es';

# Recuperar todos los atributos de los discos del género 'clásica'.
SELECT *
	FROM disco
    WHERE dis_genero = 'Clásica';

# Recuperar todos los atributos de los discos hechos en alguno de los cinco años: 1970, 1980, 1985, 1990 y 1995.
SELECT *
	FROM disco
    WHERE dis_anio IN ('1970', '1980', '1985', '1990', '1995');

# Recuperar el título, el género y el año de los discos que tengan en su título el string 'amor' o el string 'love' .
SELECT dis_titulo, dis_genero, dis_anio
	FROM disco
	WHERE (dis_titulo LIKE '%amor%' OR dis_titulo LIKE '%love%');
    
# Recuperar el título, el género y el año de los discos que tengan en su título la palabra 'amor' y que sean del género 'reguetón' o 'banda'.
SELECT dis_titulo, dis_genero, dis_anio
	FROM disco
	WHERE dis_titulo LIKE '%amor%'
		AND dis_genero IN ('Reggaeton', 'Banda');

# Recuperar todos los atributos de los discos para un intérprete cualquiera con id específico (dado por ti).
SELECT *
	FROM disco
    WHERE dis_id_interprete = 1;
    
# Recuperar el título, el sello y el género para los discos de género 'rock' o 'banda' de los años: 1990, 1999 y 2005.
SELECT dis_titulo, dis_productora, dis_genero
	FROM disco
	WHERE dis_genero IN ('Rock', 'Banda')
		AND dis_anio IN ('1990', '1999', '2005');
        
# Recuperar el título, el número de pista y la duración de las canciones con duración menor o igual a 2 minutos.
SELECT can_titulo, can_n_pista, can_duracion
	FROM cancion
	WHERE can_duracion <= '00:02:00';
    
# Recuperar título, el número de pista y la duración de las canciones que tengan en su título el string 'suerte' o el string 'luck' y que tengan duración mayor a 2 minutos.
SELECT can_titulo, can_n_pista, can_duracion
	FROM cancion
	WHERE (can_titulo LIKE '%suerte%' OR can_titulo LIKE '%luck%')
		AND can_duracion > '00:02:00';
    
# Recuperar todos los atributos de las canciones para un disco cualquiera con id específico (dado por ti).
SELECT *
	FROM cancion
	WHERE can_id_disco = 1;

# Recuperar título, el número de pista y la duración de las canciones que tengan en su título el string 'suerte' o el string 'luck' para discos con ids entre 1 y 10.
SELECT can_titulo, can_n_pista, can_duracion
	FROM cancion
	WHERE (can_titulo LIKE '%suerte%' OR can_titulo LIKE '%luck%')
		AND can_id_disco BETWEEN 1 AND 10;

# CROSS JOIN

# Recuperar los nombres de los intérpretes y el título, el género y el año de sus discos.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio
	FROM interprete, disco
	WHERE interprete.inte_id = disco.dis_id_interprete;

# Recuperar el título y el año de los discos que sean de género 'rock' junto con el nombre del interpréte de cada disco.
SELECT disco.dis_titulo, disco.dis_anio, interprete.inte_nombre
	FROM disco, interprete
    WHERE disco.dis_id_interprete = interprete.inte_id
		AND disco.dis_genero = 'Rock';

# Recuperar el título y la duración de las canciones junto con el nombre y el género del disco, para las canciones que tengan duración menor o igual a 2 minutos.
SELECT cancion.can_titulo, cancion.can_duracion, disco.dis_titulo, disco.dis_genero
	FROM cancion, disco
	WHERE cancion.can_id_disco = disco.dis_id
		AND cancion.can_duracion <= '00:02:00';
    
# Recuperar el título, el género y el año de los discos junto con el título, la duración y el número de pista de las canciones de cada disco.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM disco, cancion
	WHERE disco.dis_id = cancion.can_id_disco;

# Recuperar el título, el género y el año de los discos junto con el título, la duración y el número de pista de las canciones de cada disco, pero solo para los discos de los años 2000, 2003 y 2006.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM disco, cancion
	WHERE disco.dis_id = cancion.can_id_disco
		AND disco.dis_anio IN ('2000', '2003', '2006');
    
# Recuperar el título, el género y el año de los discos junto con el título, la duración y el número de pista de las canciones de cada uno, pero solo para los discos de género 'rock' o 'salsa' entre los años 1990 y 2000 y para las canciones con duración de 1, 2 y 3 minutos.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM disco, cancion
	WHERE disco.dis_id = cancion.can_id_disco
		AND disco.dis_genero IN ('Rock', 'Salsa')
		AND disco.dis_anio BETWEEN '1990' AND '2000'
        AND cancion.can_duracion IN ('00:01:00', '00:02:00', '00:03:00');


# 6. CONSULTAS 2 | ORDER BY y LIMIT
# Consultar datos en la BD de catálogo musical:

# Recuperar todos los atributos de los discos de los géneros 'clásica' y 'reguetón'. Devolver el resultado ordenado por año de forma ascendente.
SELECT *
	FROM disco
    WHERE dis_genero IN ('Clásica', 'Reggaeton')
    ORDER BY dis_anio ASC;

# Recuperar todos los atributos de los discos hechos en alguno de los cinco años: 1970, 1980, 1985, 1990 y 1995. Devolver el resultado ordenado primero por año de forma ascendente y luego por título de forma descendente.
SELECT *
	FROM disco
    WHERE dis_anio IN (1970, 1980, 1985, 1990, 1995)
    ORDER BY dis_anio ASC, dis_titulo DESC;
    
# Recuperar el título, el género, el año y la productora de los discos que tengan en su título el string 'amor' o el string 'love'. Devolver el resultado ordenado primero por género de forma ascendente y luego por título de forma ascendente.
SELECT dis_titulo, dis_genero, dis_anio, dis_productora
	FROM disco
    WHERE (dis_titulo LIKE '%amor%' OR dis_titulo LIKE '%love%')
    ORDER BY dis_genero ASC, dis_titulo ASC;
    
# Recuperar el título, el número de pista y la duración de las canciones que tengan en su título el string 'suerte' o el string 'luck' y que tengan duración entre 1 y 4 minutos. Devolver el resultado ordenado primero por duración de forma ascendente y luego por título de forma descendente. Devolver solo 4 registros a partir de la posición 2.
SELECT can_titulo, can_n_pista, can_duracion
	FROM cancion
    WHERE (can_titulo LIKE '%suerte%' OR can_titulo LIKE '%luck%')
		AND can_duracion BETWEEN '00:01:00' AND '00:04:00'
	ORDER BY can_duracion ASC, can_titulo DESC
    LIMIT 2, 4;
        
# Recuperar todos los atributos de las canciones para los discos con ids 3, 5 y 6. Devolver el resultado ordenado primero id del disco de forma descendente y luego título de forma ascendente. Devolver solo los primeros 10 registros.
SELECT *
	FROM cancion
    WHERE can_id_disco IN (3, 5, 6)
    ORDER BY can_id_disco DESC, can_titulo ASC
    LIMIT 10;

# CROSS JOIN

# Recuperar los nombres de los intérpretes y el título, el género y el año de sus discos. Devolver el resultado ordenado primero por título de forma ascendente. Devolver solo 3 registros a partir de la posición 4.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio
	FROM interprete, disco
    WHERE interprete.inte_id = disco.dis_id_interprete
    ORDER BY disco.dis_titulo ASC
    LIMIT 4, 3;
    
# Recuperar el título, la productora y el año de los discos que sean de género 'rock' o 'clásica' junto con el nombre del interpréte de cada disco. Devolver el resultado ordenado primero por año del disco de forma ascendente y luego por nombre de forma descendente.
SELECT disco.dis_titulo, disco.dis_productora, disco.dis_anio, interprete.inte_nombre
	FROM disco, interprete
    WHERE disco.dis_id_interprete = interprete.inte_id
		AND disco.dis_genero IN ('Rock', 'Clásica')
    ORDER BY disco.dis_anio ASC, interprete.inte_nombre DESC;
    
# Recuperar el título, el número de pista y la duración de las canciones junto con el título y el género del disco, para las canciones que tengan duración entre 2 y 4 minutos. Devolver el resultado ordenado por duración de forma ascendente. Devolver solo los primeros 5 registros.
SELECT cancion.can_titulo, cancion.can_n_pista, cancion.can_duracion, disco.dis_titulo, disco.dis_genero
	FROM cancion, disco
    WHERE cancion.can_id_disco = disco.dis_id
		AND can_duracion BETWEEN '00:02:00' AND '00:04:00'
    ORDER BY cancion.can_duracion ASC
    LIMIT 5;
    
# Recuperar el título, el género y el año de los discos, junto con el título, la duración y el número de pista de las canciones de cada disco, para los discos de géneros 'rock', 'reguetón' y 'banda'. Devolver el resultado ordenado primero por género del disco de forma ascendente y luego por título de la canción de forma descendente. Devolver solo 5 registros a partir de la posición 5.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM disco, cancion
    WHERE disco.dis_id = cancion.can_id_disco
		AND disco.dis_genero IN ('Rock', 'Reggaeton', 'Banda')
    ORDER BY disco.dis_genero ASC, cancion.can_titulo DESC
    LIMIT 5, 5;
    
# Recuperar el nombre del intérprete, el título, el género y el año de los discos de cada intérprete; el título, la duración y el número de pista de las canciones de cada disco, para los intérpretes que tengan en su nombre el string 'bunny', 'fernandez' o 'juan'. Devolver el resultado ordenado primero por género de forma descendente y luego por título del disco de forma ascendente.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM interprete, disco, cancion
    WHERE ((interprete.inte_id = disco.dis_id_interprete) AND (disco.dis_id = cancion.can_id_disco))
		AND ((interprete.inte_nombre LIKE '%Bunny%') OR (interprete.inte_nombre LIKE '%Fernandez%') OR (interprete.inte_nombre LIKE '%Juan%'))
    ORDER BY disco.dis_genero DESC, disco.dis_titulo ASC;


# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT) ORDER BY, LIMIT
# Consultar datos en la BD de catálogo musical:

# Recuperar el nombre del intérprete, junto con el título, género y año de cada uno de sus discos. Incluir los intérpretes que no tienen discos.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio
	FROM interprete
	LEFT JOIN disco
		ON interprete.inte_id = disco.dis_id_interprete;

# Recuperar el título, género, año y productora de los discos, junto con el título, pista y duración de las canciones de cada disco. Incluir los discos que no tienen canciones.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, disco.dis_productora, cancion.can_titulo, cancion.can_n_pista, cancion.can_duracion
	FROM disco
	LEFT JOIN cancion
		ON disco.dis_id = cancion.can_id_disco;

# Recuperar el nombre del intérprete, junto con el título, género y año de cada uno de sus discos. Incluir los discos que no tienen un intérprete asignado.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio
	FROM interprete
	RIGHT JOIN disco
		ON disco.dis_id_interprete = interprete.inte_id;

# Recuperar el nombre del intérprete; el título, género y año de cada uno de sus discos; y el título, pista y duración de las canciones de cada disco.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_n_pista, cancion.can_duracion
	FROM interprete
	INNER JOIN disco
		ON interprete.inte_id = disco.dis_id_interprete
	INNER JOIN cancion
		ON disco.dis_id = cancion.can_id_disco;

# Recuperar el nombre del intérprete; el título, género y año de cada uno de sus discos; y el título, pista y duración de las canciones de cada disco. Incluir los intérpretes que no tengan discos y los discos que no tengan canciones.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_n_pista, cancion.can_duracion
	FROM interprete
	LEFT JOIN disco
		ON interprete.inte_id = disco.dis_id_interprete
	LEFT JOIN cancion
		ON disco.dis_id = cancion.can_id_disco;
	
# ORDER BY, LIMIT

# Recuperar los nombres de los intérpretes y el título, el género y el año de sus discos. Devolver el resultado ordenado primero por título de forma ascendente. Devolver solo 3 registros a partir de la posición 4.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio
	FROM interprete
	INNER JOIN disco
		ON interprete.inte_id = disco.dis_id_interprete
	ORDER BY disco.dis_titulo ASC
    LIMIT 4, 3;

# Recuperar el título, la productora y el año de los discos que sean de género 'rock' o 'clásica' junto con el nombre del interpréte de cada disco. Devolver el resultado ordenado primero por año del disco de forma ascendente y luego por nombre de forma descendente.
SELECT disco.dis_titulo, disco.dis_productora, disco.dis_anio, interprete.inte_nombre
	FROM disco
	INNER JOIN interprete
		ON disco.dis_id_interprete = interprete.inte_id
	WHERE disco.dis_genero IN ('Rock', 'Clásica')
    ORDER BY disco.dis_anio ASC, interprete.inte_nombre DESC;

# Recuperar el título, el número de pista y la duración de las canciones junto con el título y el género del disco, para las canciones que tengan duración entre 2 y 4 minutos. Devolver el resultado ordenado por duración de forma ascendente. Devolver solo los primeros 5 registros.
SELECT cancion.can_titulo, cancion.can_n_pista, cancion.can_duracion, disco.dis_titulo, disco.dis_genero
	FROM cancion
	INNER JOIN disco
		ON cancion.can_id_disco = disco.dis_id
	WHERE cancion.can_duracion BETWEEN '00:02:00' AND '00:04:00'
    ORDER BY cancion.can_duracion ASC
    LIMIT 5;

# Recuperar el título, el género y el año de los discos, junto con el título, la duración y el número de pista de las canciones de cada disco, para los discos de géneros 'rock', 'reguetón' y 'banda'. Devolver el resultado ordenado primero por género del disco de forma ascendente y luego por título de la canción de forma descendente. Devolver solo 5 registros a partir de la posición 5.
SELECT disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM disco
	INNER JOIN cancion
		ON disco.dis_id = cancion.can_id_disco
	WHERE disco.dis_genero IN ('Rock', 'Reggaeton', 'Banda')
    ORDER BY disco.dis_genero ASC, cancion.can_titulo DESC
    LIMIT 5, 5;

# Recuperar el nombre del intérprete, el título, el género y el año de los discos de cada intérprete; el título, la duración y el número de pista de las canciones de cada disco, para los intérpretes que tengan en su nombre el string 'bunny', 'fernandez' o 'juan'. Devolver el resultado ordenado primero por género de forma descendente y luego por título del disco de forma ascendente.
SELECT interprete.inte_nombre, disco.dis_titulo, disco.dis_genero, disco.dis_anio, cancion.can_titulo, cancion.can_duracion, cancion.can_n_pista
	FROM interprete
	INNER JOIN disco
		ON interprete.inte_id = disco.dis_id_interprete
	INNER JOIN cancion
		ON disco.dis_id = cancion.can_id_disco
	WHERE ((interprete.inte_nombre LIKE '%Bunny%') OR (interprete.inte_nombre LIKE '%Fernandez%') OR (interprete.inte_nombre LIKE '%Juan%'))
    ORDER BY disco.dis_genero DESC, disco.dis_titulo ASC;


# 8. CONSULTAS 4 | GROUP BY (CON HAVING)
# Consultar datos en la BD de catálogo musical:

# Recuperar el número de intérpretes por los cinco primeros caracteres de su nombre (SUBSTR(str, pos, n))
SELECT COUNT(SUBSTR(inte_nombre, 1, 5)) AS numero_interpretes
	FROM interprete;
    
# Recuperar el número de discos por interprete id.
SELECT dis_id_interprete, COUNT(dis_id_interprete) AS numero_discos
	FROM disco
    GROUP BY dis_id_interprete;
    
# Recuperar el número de discos por año y ordenar de mayor a menor.
SELECT dis_anio, COUNT(dis_anio) AS numero_discos
	FROM disco
    GROUP BY dis_anio
    ORDER BY numero_discos DESC;
    
# Recuperar el número de discos la combinación de sello y año y ordenar de menor a mayor.
SELECT COUNT(*) AS numero_discos, CONCAT(dis_productora, ' ', dis_anio) AS productora_anio
	FROM disco
    GROUP BY productora_anio
	ORDER BY numero_discos ASC;

# Recuperar el número de discos la combinación de género y año y ordenar de menor a mayor, pero solo aquellas combinaciones que tengan al menos 2 discos.
SELECT COUNT(*) AS numero_discos, CONCAT(dis_genero, ' ', dis_anio) AS genero_anio
	FROM disco
    GROUP BY genero_anio
    HAVING numero_discos >= 2
    ORDER BY numero_discos ASC;
    
# Recuperar el número de discos por género y ordenar de mayor a menor, pero solo aquellos géneros que tengan 2 y 4 discos.
SELECT dis_genero, COUNT(dis_genero) AS numero_discos
	FROM disco
    GROUP BY dis_genero
    HAVING numero_discos BETWEEN 2 AND 4
    ORDER BY numero_discos DESC;

# Recuperar el número de canciones por disco id y ordenar de mayor a menor, pero solo aquellos con entre 7 y 10 canciones.
SELECT can_id_disco, COUNT(can_id_disco) AS numero_canciones
	FROM cancion
    GROUP BY can_id_disco
    HAVING numero_canciones BETWEEN 7 AND 10
    ORDER BY numero_canciones DESC;

# Recuperar el disco id y el promedio de duración para las canciones de cada disco id, luego ordenar de mayor a menor
SELECT can_id_disco, AVG(can_duracion) AS duracion_promedio
	FROM cancion
    GROUP BY can_id_disco
    ORDER BY duracion_promedio DESC;

# Recuperar el disco id y el promedio de duración para las canciones de cada disco id, luego ordenar de mayor a menor, pero solo aquellos discos cuyas canciones duren en promedio 2 minutos o 4 minutos.
SELECT can_id_disco, AVG(can_duracion) AS duracion_promedio
	FROM cancion
    GROUP BY can_id_disco
    HAVING duracion_minima >= '00:02:00'
    ORDER BY duracion_promedio DESC;
    
# Recuperar el disco id y la duración mínima y máxima de las canciones de cada disco, pero solo cuando la duración mínima sea de 2 minutos o más.
SELECT can_id_disco, MIN(can_duracion) AS duracion_minima, MAX(can_duracion) AS duracion_maxima
	FROM cancion
    GROUP BY can_id_disco
    HAVING duracion_minima >= '00:02:00';
