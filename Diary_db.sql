#Empezamos con DDL: Data definition Language
#Para crear la crear la estructura de la base de datos
#Vamos a traducir el diagrama que hicimos en draw.io a instrucciones en el lenguaje SQL
#SQL es un lenguaje interpretado, no tiene una fase de análisis y compilado
#no genera directamente el ejecutable, en vez de eso interpreta y ejecuta cada línea de código una por una
#Si hay un error en el código, todas las líneas previas a él se pueden ejecutar

#----------------------------

#created by:  Anguiano Cabrera Keyla Leilani
#Date: 07/02/2023
#definition: Crear una base de datos para controlar la información de una agenda básica

#Crear el edificio (o el espacio) en el que colocaremos las tablas
CREATE DATABASE IF NOT EXISTS agenda_db;

#Abrir la base datos para poner cosas dentro de ella
USE agenda_db;


#-------Análisis de llaves en cada tabla--------
#Super llaves en la tabla contacto
# correo, telefono, [nombre, telefono], [dirección, correo], [nombre, telefono, direccion], 
#[telefono, direccion, correo], [nombre, telefono, dirección, correo]

#Llaves candidatas
# correo, telefono

#Llave primaria
# [correo]

# Llaves alternas
# [telefono]
#Agregar tablas dentro de la base de datos

#Crear la tabla contacto
CREATE TABLE IF NOT EXISTS contacto (
	con_id INT NOT NULL AUTO_INCREMENT, #Atributo creado  para funcionar como llave primaria, no sirve para nada más
	con_nombre VARCHAR (50) NOT NULL,
	con_telefono VARCHAR(10),
	con_direccion VARCHAR(60),
	con_correo VARCHAR(25), 
    
    PRIMARY KEY (con_id), #Llave primaria artificial, llave primaria sencila
    
    UNIQUE uni_correo (con_correo),
    UNIQUE uni_telefono (con_telefono), #Genera un índice para el teléfono
    UNIQUE uni_nombre (con_nombre) #Este atributo es auxiliar para la búsqueda
);

# El indice ayuda a agilizar las búsquedas por uno o varios atributos, suelen indexar los atributos que se pueden
# utilizar de manera frecuente en búsquedas/consultas

# Nota 1: Se tiene que tener cuidado con qué atributos se seleccionan cómo índice, no es conveniente indexar todos
#		  los atributos.

#Nota 2: Una llave primaria, por definición también es un índice. Es decir que se crea un índice para los atributos
#		 que forman la llave primaria. Además, el índice de la llave primaria es único (los valores no se repiten)

#AUTO_INCREMENT genera un valor incremental de manera automática para un atributo. Es usado principalmente para llaves
#primarias artificial,  NO puede haber dos atributos con la propiedad incremental en la misma tabla. el primer
#registro que se inserta en la tabla tendrá el valor 1, y se

# Super Llaves para la tabla citas
# [fecha, hora], [fecha, hora, lugar], [fecha, hora, lugar, contacto]

# Llaves candidatas
# [fecha, hora] 

# Llave primaria
# [fecha, hora]

# Llave alterna
# No hay

# Crear tabla cita
CREATE TABLE  IF NOT EXISTS cita(
	cit_id INT NOT NULL AUTO_INCREMENT,
    cit_fecha DATE NOT NULL,
    cit_hora TIME NOT NULL,
    cit_lugar VARCHAR(60),
    cit_con_id INT,

    PRIMARY KEY (cit_id), #Llave Primaria Artificial Sencilla

    UNIQUE uni_fec_hor (cit_fecha, cit_hora),
    
    INDEX idx_fecha (cit_fecha), #Generaun indice para la fecha
    INDEX idx_contacto (cit_con_id),#Genera un índice para el contacto

    CONSTRAINT fk_con_cit
		FOREIGN KEY (cit_con_id)
        REFERENCES contacto (con_id)
);

#Las instrucciones de SQL aparecen en azul, se escriben en mayúsculas, mientras que las variables
#Estpán en minúsculas

#Los atributos de la tabla se pondrán uno por cada línea, junto con sus propiedades

USE agenda_db;

/*
ALTER TABLE contacto RENAME amigo; #Cambia el nombre de la tabla contacto a amigo
ALTER TABLE amigo RENAME contacto;
ALTER TABLE contacto DROP COLUMN con_direccion; #Elimina la columna de dirección
ALTER TABLE contacto ADD con_direccion VARCHAR (100); #Agrega la columna dirección al final de la tabla
ALTER TABLE contacto DROP COLUMN con_telefono, DROP COLUMN con_correo; #Elimina las columnas mencionadas
ALTER TABLE contacto ADD con_correo VARCHAR (25) AFTER con_nombre; #Agrega la columna despues de la columna de nombre
ALTER TABLE contacto ADD con_telefono VARCHAR (10) FIRST; #Agrega la columna al inicio de la tabla

ALTER TABLE contacto ADD INDEX idx_correo (con_correo); #Agrega un índice para el correo
ALTER TABLE contacto DROP INDEX idx_correo; #Elimina el índice mencionado
ALTER TABLE contacto ADD UNIQUE uni_telefono (con_telefono); #Agrega la condición de unicidad para la columna mencionada
ALTER TABLE contacto ADD UNIQUE uni_correo (con_correo);
ALTER TABLE contacto CHANGE con_correo con_cor_elect VARCHAR (40); #Renombra la columna y el tipo de dato de ella
ALTER TABLE contacto MODIFY con_cor_elect VARCHAR(35); #Sólo cambia el tipo de dato

#	BORRAR LA LLAVE PRIMARIA
ALTER TABLE cita DROP PRIMARY KEY; #Elimina la llave primaria

# NOTA: ANTES DE PODER BORRAR LA LLAVE PRIMARIA, SE DEBE ASEGURAR QUE EL ATRIBUTO ASOCIADO A LA LLAVE PRIMARIA
# NO TENGA LA PROPIEDAD AUTO_INCREMENT, Y ADEMÁS QUE NO SIRVA DE REFERENCIA PARA UNA LLAVE FORÁNEA DE OTRA TABLA
# EN ESTE CASO SE TIENE QUE CAMBIAR EL TIPO DE DATO DEL ATRIBUTO PARA PODER QUITAR LA LLAVE PRIMARIA

ALTER TABLE cita MODIFY cit_id VARCHAR(1);
ALTER TABLE cita ADD PRIMARY KEY (cit_id);
*/

# En el DML hay cuatro operaciones: Create, Read, Update y Delete --> CRUD
# Create --> INSERT
# Read --> SELECT
# Update --> UPDATE
# Delete --> DELETE


# INSERT

# Inserta (agrega) datos en una tabla de una estructura definida (base de datos)
# Debemos primero insertar datos en las tablas independientes (aquellas que no tengan
# llaves foráneas).

# Insertar datos en la tabla contacto
INSERT INTO contacto (con_nombre, con_telefono, con_direccion, con_correo)
	VALUES ('Raúl Uriel', '4771234567', 'Yeso 224, Col. Estrella', 'ru.s@ugto.mx');

INSERT INTO contacto (con_nombre, con_telefono, con_direccion, con_correo)
	VALUES ('María del Rosario', '4649876543', 'Antares 453, Col. Estrella', 'mrh@ugto.mx');

# Insertar varios contactos al mismo tiempo (todo en una sola instrucción)
INSERT INTO contacto (con_nombre, con_telefono, con_direccion, con_correo)
	VALUES ('Zair Pedro', '4648754692', 'Zapata 231', 'zpaugto.mx'),
		   ('Emilio Martínez', '4795874369', 'Brisas 123', 'emy@ugto.mx'),
		   ('Helio Rafael González', '4641478596', 'Hidalgo 341', 'hrg@gmail.com'),
           ('Paola Arreguín Meléndez', '4641257894', 'Cazadora 56', 'pam@gmail.com'),
           ('Pedro Hernández', '4778541236', 'Estrella 78', 'phk@gmail.com"'),
           ('Claudia Mendoza Huerta', '4425874693', 'Independendia 451', 'cmh@ugto.mx');

# Los valores que se insertan, deben estar en orden (correspondencia) con respecto a las columnas indicadas
# (En principio) no se pueden insertar valores de un tipo en una columna de otro tipo.
# No se puede insertar un valor en una columna AUTO INCREMENT, Marca error
# Si no se indica el nombre de una columna para insertar intormacion, cuando
# se inserte el registro, se le pondrá el valor por detault a esa columna (Puede ser el valor NULL).

# No se especifica la columna con_direccion
INSERT INTO contacto (con_nombre, con_telefono, con_correo)
	VALUES ('Juan Escutia', '4427415892', 'je@gmail.com'); 

# Si no se indica el nombre de la columna, pero se trata de insertar
# un valor adicional en el registro, marca error.
# Error, porque no sabe donde colocar el valor adicional.

# INSERT INTO contacto (con_nombre, con_telefono, con_direccion)
#	VALUES ('Ana Godínez', '4648512789', 'Morelos 27', 'ag@ugto.mx'); 

# Se trata de insertar un valor en la columna con _correo, pero no se
# especifico en la definición.

#Insertar datos en la tabla cita (tabla dependiente)
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2023-03-30', '10:00:001','Altacia', 5);

# Es importante revisar los tipos de datos en los que se van a insertar los valores
# MysQL hace la transformación directa entre tipos VARCHAR y DATE, DATETIME y TIME
# (VARCHAR - -> DATE/DATETIME/TIME): Siempre
# DATE se inserta con el formato:
# "YEAR-MONTH-DAY' (como VARCHAR)
# TIME se inserta con el formato: "HOUR:MINUTES: SECONDS' (como VARCHAR)

# Los tipos numéricos (INT, FLOAT, DECIMAL, etc.) NO SE DEBEN PONER con
# Considerar la tabulación/indentado al momento de definir la inserción
# de los datos

# Insertando varios registro al mismo tiempo
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2023-04-17', '10:00:00', 'Altacia', 1),
		   ('2023-04-17', '11:00:00', 'Altacia', 2),
		   ('2023-04-24', '10:00:00', 'Centro', 2),
		   ('2023-05-01', '12:00:00', 'Vía Alta', 3),
           ('2023-05-03', '16:00:00', 'Centro', 5),
		   ('2023-05-03', '10:00:00', 'Centro', 8),
           ('2023-05-10', '19:00:00', 'Via Alta', 9),
           ('2023-05-23', '12:00:00', 'Centro', 3),
           ('2023-05-23', '17:00:00', 'Centro', 4),
           ('2023-06-25', '16:30:00', 'Vía Alta', 5),
           ('2023-06-30', '14:45:00', 'Via Alta', 5),
           ('2023-06-02', '10:15:00', 'Centro', 1);
           
# Insertar un registro para un contacto no existente

# No se puede por la restricción de llave foránea
# Error de referencia, el contacto indicado no existe.
# INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
#	VALUES ('2023-04-18', '10:00:00', 'Galerias', 15); 
    
# Error de referencia, el contacto indicado no existe.
# Error en la entrada, la fecha y hora # están repetidas.
# INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
# 	VALUES ('2023-04-17', '10:00:00', 'Galerías', 9); 

# Intentar insertar un contacto con un teléfono ya existente
# Error en la entrada, el teléfono está repetido
# INSERT INTO contacto (con_nombre, con_telefono, con_direccion, con_correo)
#	VALUES ('Kathia Martinez', ' 4771234567', 'Betelguese 4561', 'km@ugto.mx');

# Intentar insertar un valor NULL en la llave foránea (tabla cita)
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2023-04-18', '10:00:00', 'Galerías', NULL);

# Las llaves foráneas (normalmente) aceptan valores NULL o # se debe insertar un valor válido de la tabla de feferencia.
# AUTO INCREMENT tiene un contador interno que siempre se va a incrementar en
# 1 por cada intento de inserción, aunque no se logre insertar el registro.
# No se puede regresar al contador previo.


# DELETE

# Eliminar (borrar) datos (registros completos) de una tabla
# Dependiendo de la propiedad ON DELETE en las tablas que tienen una llave
# foránea, normalmente primero deberlamos eliminar registros de las
# tablas dependientes con llaves foráneas).

# Eliminar datos de la tabla contacto

# Intenta eliminar un contacto que tenga registros en la tabla cita
# Probar la restricción de la propiedad ON DELETE RESTRICT
# No se debe poder

# Intenta eliminar de la tabla contacto, el contacto con el con_id = 5  
# DELETE FROM contacto
#	WHERE con_id = 5;
    
# Para poder eliminar ese contacto
# Primero hay que eliminar los registro asociado en la tabla cita
# referentes al contacto que queremos eliminar.

# Elimina de la tabla cita, los registros asociados con el cit_con_id = 5
DELETE FROM cita
	WHERE cit_con_id = 5; 

# Segundo, ahora si podemos eliminar el contacto deseado

# Elimina de la tabla contacto, el contacto con el con_id = 5
DELETE FROM contacto
	WHERE con_id = 5; 
    
# Si hubiéramos utilizado la opción ON DELETE CASCADE al borrar el contacto con el con id s de la tabla contacto
# todos los registros asociados en la tabla cita con ese cit_con_1d se hubieran eliminado.
# Las operaciones: DELETE, UPDATE y SELEC Tuncionan de manera basica de forma similar a un ciclo FOR. 
# Evalúan cada registro y determinan si el registro completo cumple con la condición.

/*
# Eliminar datos de la tabla cita

# Elimina las citas de una fecha específica
DELETE FROM cita
	WHERE cit_fecha = '2023-05-23';
    
# Elimina la cita de una fecha y hora específicas
DELETE FROM cita
	WHERE cit_fecha = '2023-04-17'
		AND cit_hora = '11:00:00';
        
# USO DEL OPERADOR LÓGICO AND

# Elimina las citas en un rango de fechas
DELETE FROM cita
	WHERE cit_fecha BETWEEN '2023-05-01' AND '2023-05-10';

# BETWEEN
# [valor _inicial] AND [valor_final] --› Inclusivos
# Similar a cit_fecha ›= '2023-05-01' AND cit_fecha <= '2023-05-10'

# !!! PRECAUCIÓN !!!
# Sin la restriccion del WHERE, todos los registros de la tabla se van a borrar
# DELETE FROM cita;
# DELETE FROM contacto;
*/


# UPDATE

# Actualizar datos de una tabla

# Actualizar datos de la tabla contacto

# Actualiza el teléfono para el contacto con el con_id = 2, utilizamos el id para restringir la modificación
UPDATE contacto
	SET con_telefono = '2225896347'
    WHERE con_id = 2; 
    
# Actualiza el teléfono para el contacto con el Juan Escutia, utilizamos el nombre para restringir la modificación
# No considera mayúsculas o minúsculas
UPDATE contacto
	SET con_telefono = '4421234567'
    WHERE con_nombre = 'Juan Escutia'; 
    
# Actualizar los datos de la tabla cita

# Agrega 2 días al atributo cit_fecha en todos los registros (No hay sección WHERE)
# ADDDATE() agrega la cantidad de días al atributo de tipo DATE o DATETIME
# Los tipos DATE o DATETIME automáticamente consideran las fechas válidas e los calendarios

# UPDATE cita
#	SET cit_fecha = ADDDATE(cit_fecha, 2);
    
# Agrega 2 días al atributo cit_fecha ecuando cit_fecha sea 2023-05-25
UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2)
    WHERE cit_fecha = '2023-05-25';
    
#
UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2)
    WHERE cit_id BETWEEN 2 AND 3;
    
# Sin la claúsula WHERE se actualizan todos los registros de la tabla
# Hay que tener cuidado con los atributos que se quieren actualizar,
# sobre todo cuando hay condiciones de unicidad

# UPDATE contacto
#	SET con_telefono = '1234567890';

# Modifica el teléfono de todos los cobtactos asignándoles a todos el mismo valor dado.
# ERROR. Tenemos definifo el teléfono como UNIQUE, no puede haber dos contactos con el mismo teléfono

# OPERADORES LÓGICOS
# AND
# OR
# NOT

# Agrega 1 día a la fecha para las citas con fecha y hora determinadas en las condiciones.
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha = '2023-05-05'
		AND cit_hora = '16:00:00';
        
#Agrega 1 hora a las citas con las fechas indicadas
# ADDTIME agrega una cantidad de tiempo a un atributo TIME o DATETIME
# Utiliza el formato 'hh:mm:ss'
UPDATE cita 
	SET cit_hora = ADDTIME(cit_hora, '01:00:00')
    WHERE cit_fecha = '2023-05-05'
		OR cit_fecha = '2023-05-12';

# Agrega 1 hora a las citas con las fechas y horas indicadas
# Considerar la agrupación de las condiciones
# Considerar la precedencia de los operadores
UPDATE cita 
	SET cit_hora = ADDTIME(cit_hora, '01:00:00')
    WHERE (cit_fecha = '2023-04-21' AND cit_hora = '11:00:00')
		OR (cit_fecha = '2023-05-27' AND cit_hora = '17:00:00');
        
# Error el reultado de la función da una fecha y hora repetidas
UPDATE cita 
	SET cit_hora = ADDTIME(cit_hora, '02:00:00')
    WHERE cit_fecha = '2023-04-21' AND cit_hora = '10:00:00';

# Quita 1 hora de las citas con fechas y horas inidcadas
UPDATE cita 
	SET cit_hora = ADDTIME(cit_hora, '-01:00:00')
    WHERE (cit_fecha = '2023-04-21' AND cit_hora = '12:00:00')
		OR (cit_fecha = '2023-05-27' AND cit_hora = '18:00:00');
        
# OPERADORES DE PERTENENCIA

# Actualiza los dtos de la cit_fecha, si se encuentra en el rango inidcado
# [valor_inicial] AND [valor_final] Inclusivos
# Equivalente a:
# 	cit_fecha >= valor_inicial AND cit_fecha <= valor_ifinal
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha BETWEEN '2023-05-01' AND '2023-05-31';

# Agrega 1 día a la fecha cuando cit_fecha se encuentre dentro de una lista de valores posibles
# Equivalente a
# WHERE cit_fecha = '2023-04-21' OR cit_fecha = '2023-05-28' OR cit_fecha = '2023-06-04';
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha IN ('2023-04-21', '2023-05-28', '2023-06-04');
    
# OPERADORES RELACIONALES

# Igual 	(prácticamente con cualquier tipo de dato)
# <> o !=	Diferente de (prácticamente con cualquier tipo de dato)
# <			Menor que (númericos y fechas)
# >			Mayor que (númericos y fechas)
# <=		Menor o igual que (númericos y fechas)
# >=		Mayor o igual que (númericos y fechas)

# Agrega 1 día a la fecha de las citas con fechas posteriores a 2023-06-05
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha > '2023-06-05';
    
# Agrega 1 día a la fecha de las citas con fechas anteriores a 2023-05-04 (inclusive)
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha <= '2023-06-04';
    
# Agrega 1 día a la fecha de las citas con fechas diferentes a 2023-04-21
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 1)
    WHERE cit_fecha != '2023-04-21';
    
# Agrega 2 día a la fecha de las citas con fechas que no sean 2023-04-21
UPDATE cita 
	SET cit_fecha = ADDDATE(cit_fecha, 2)
    WHERE NOT cit_fecha = '2023-04-21';
    
# OPERDOR STRING (LIKE) parecido alter

# Evalúa cit_lugar (debe de ser un string) por un patrón (%Alta) para actualizar cit_lugar
# El patrón va a esta compuesto por caracteres y comodines % y _
# En este caso, el comodín '%' considera cualquier string, 
# y el patrón busca si el string a evaluar termina en 'Alta' (p.e. 'Vía Alta' o 'Vista Alta')

# Hay dos comodines para el operador LIKE
# El comodín '%' considera cualquier string (incluido el caracter nulo) 
# El comodín '_' considera cualquier caracter (solo 1 caracter) , no
# considera el caracter nulo

# El resultado del operador LIKE es un valor de verdad (TRUE/FALSE)

# Ejemplos de patrones

# '%Alta' 	El string debe de terminar en la palabra 'Alta', 
# antes de esa palabra puede venir cualquier cantiad de caracteres(los que sean)

# '%Alta%' 	Cualquier cosa, palabra 'Alta', cualquier cosa

# '_Alta' 	El string debe de terminar en la palabra 'Alta', 
# sólo puede tener un caracter (cualquiera)

# '_Alta_' 	Un caracter, palabra 'Alta', un caracter 
# '__Alta__' Dos caracteres, palabra 'Alta', dos caracteres

UPDATE cita 
	SET cit_lugar = 'Plazoleta'
    WHERE cit_lugar LIKE '%Alta';
    
    
# SELECT

# Leer (consultar o recuperar) datos de una tabla (query)

# Leer los datos de3 la tabla contacto
USE agenda_db;
# Recupera todas las columnas de todos los registros de la tabla contacto
# El comodín asterísco indica todas las columnas 
SELECT *
	FROM contacto;

# Recupera todas las columnas de todos los registros de la tabla cita
SELECT *
	FROM cita;
    
# Recupera la columna con_nombre de todos los registros de la tabla contacto
SELECT con_nombre
	FROM contacto;

# Recupera las columnas con_nombre y con_correo de todos los registros de la tabla contacto
SELECT con_nombre, con_correo
	FROM contacto;

# Recupera las columnas cit_fecha y cit_lugar de todos los registros de la tabla cita
SELECT cit_fecha, cit_lugar
	FROM cita;

# Recupera la columna cit_lugar y cit_fecha de todos los registros de la tabla cita
# El orden de recuperación de las columnas, depende de como se indique en la instrucción
SELECT cit_lugar, cit_fecha
	FROM cita;
    
# Recupera la columna cit_fecha, cit_hora y cit_lugar de todos los registros de la tabla cita
SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita;
    
# En los ejemplos previos estamos restringiendo las columnas (atributos)alter

# Puedo tambien restringir los registros, através de la sección WHERE
# WHERE ayuda a restringir el resultado de la consulta

# WHERE [condición]
# Condición es una expresión que se debe evaluar como verdadera para cada registro que queremos recuperar, alter

# El uso del WHERE es similar a utilizar un ciclo FOR donde cada registro se evalúa con la condición definida
# Si el registro cumple la condición devuelve, si no la cumple, se ignora

# La instrucción SELECT utiliza los mismos operadores en la sección WHERE que las instruccciones DELETE y UPDATE

# Recupera todas las columnas para los registros cuyo con_nombre termine en 'ez' en la tabla contacto
SELECT *
	FROM contacto
    WHERE con_nombre LIKE '%ez';

# Recupera las columnas con_nombre y con_correo para los registros cuyo con_nombre termine en 'ez' en la tabla contacto
SELECT con_nombre, con_correo
	FROM contacto
    WHERE con_nombre LIKE '%ez';
    
# Recupera las columnas con_nombre y con_correo para los registros cuyo con_nombre termine en 'uyt' en la tabla contacto
# Si no hay ningúun registro que cumpla la condición, me devuelve una tabla vacía
SELECT con_nombre, con_correo
	FROM contacto
    WHERE con_nombre LIKE '%uyt';
    
# Recupera las columnas cit_fecha, cit_hora y cit_lugar para los registros que sean del mes de mayo del 2023 o posteriores de la tabla cita
SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita
    WHERE cit_fecha >= '2023-05-01';
    
# Recupera la columna cit_fecha, cit_hora y cit_lugar para los registros que sean del mes de mayo 2023 de la tabla cita
# WHERE cit_fecha LIKE '%05%' no se puede utilizar, porque cit_fecha es un tipo DATE, LIKE es para STRINGS (VARCHAR)
SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita
    WHERE cit_fecha BETWEEN '2023-05-01' AND '2023-05-31';
    
    
# REFERENCIAS A TABLAS Y COLUMNAS (Aplica para todas las instrucciones INSERT, DELETE, UPDATE, SELECT)

# Podemos referirnos a una tabla de la base de daros actual(abierta) con [nombre_tabla] 
# o podemos especificar la base de datos de forma explícita con [nombre_base].[nombre_tabla] (Notación punto)

# Cuando se hace referencia de forma explícita a la base de datos que contiene la tabla, 
# no es necesario que la base de datos esté abierta

# Recupera todas las columnas de todos los registros de la tabla pelicula de la base de datos peliculas_db
# Aunque tenga abierta la base de datos agenda_db
SELECT *
	FROM peliculas_db.pelicula;

# Intenta recuperar todas las columnas de todos los registros de la tabala pelicula
# Marca error, porque la tabla pelicula no esta en la base de datos abierta (agenda_db)
#Si no soy explícto sobre la base de datos, va a buscar la tabla/atributos en la base de datos abierta
# SELECT *
#	FROM pelicula;
    
# Recupera las columnas con_nombre y con_correo de todos los registros de la tabla contacto de la base de datos agenda_db
SELECT con_nombre, con_correo
	FROM agenda_db.contacto;
    
# Igual que arriba, aquí si funciona porque la base de datos agenda_db esta abierta y contiene la tabla contacto
SELECT con_nombre, con_correo
	FROM contacto;
    
# Podemos referirnos a una columa con [noombre_columna] o con [nombre_tabla].[nombre_columna] o con [nombre_base].[nombre_tabla].[nombre_columna]
# Somos explícitos con la base de datos que contiene la tabla, y con la base de datos y la tabla que contiene a las columnas
SELECT agenda_db.contacto.con_nombre, agenda_db.contacto.con_correo
	FROM agenda_db.contacto;

# Se debe ser explícito con la base de datos, cuando queremos trabajar con ella sin abrirla (sin usar USE)
SELECT peliculas_db.pelicula.pel_titulo, peliculas_db.pelicula.pel_genero
	FROM peliculas_db.pelicula;
    
# Se debe ser explícito con las tablas o con las bases de datos, cuando dos columnas tienen el mismo nombre
# en dos tablas/bases diferentes y estamos usando ambas tablas/bases en la misma instrucción
# Ejempplo ficticio
# SELECT cliente.nombre, empleado.nombre
#	FROM cliente, empleado;
    
# No es necesario ser explícito en la referencia a las tablas o bases de datos, pero es recomendable (o necesario)
# cuando la referencia pueda ser ambigua o la base de datos no esté abierta


# UNIÓN BÁSICA DE TABLAS

# Unión cruzada directa (Cross Join)

# Recupera todas las columnas de todos los registros de la tabla cita en combinación
# (unión / join) con todas las columnas de todos los registros de la tabla contacto
SELECT cita.*, contacto.*
	FROM cita, contacto;
    
# Agregar un WHERE para restringir el resultado (los registros a recuperar) de la cruza directa
SELECT cita.*, contacto.*
	FROM cita, contacto
	WHERE cita.cit_con_id = contacto.con_id;
    
# La unión cruzada como la vimos arriba hace dos pasos:
# Paso 1: Obtiene el resultado completo de la cruza directa
# Paso 2: Con el WHERE restringe que registros se devuelven finalmente
# La condición en este caso es que el id del contacto en la cita (cit_id),
# sea igual al id del contacto en la tabla contacto (con_id)

# Podemos también restringir las columnas a recuperar
SELECT cita.cit_fecha, cita.cit_hora, cita.cit_lugar, contacto.con_nombre, contacto.con_telefono
	FROM cita, contacto
    WHERE cita.cit_con_id = contacto.con_id;
    
# Cambiando el orden de las columnas en el resultado
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM cita, contacto
    WHERE cita.cit_con_id = contacto.con_id;
    
# Cambiando el orden de las tablas
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto, cita
    WHERE cita.cit_con_id = contacto.con_id;
    
# USO DE ALIAS EN LAS TABLAS (o consultas)

# Cambiar el nombre de una tabla (o resultado de una consulta) de forma temporal dentro de una consulta
# A la referencia de una tabla se le puede poner un alias usando la palabra
# AS (o también directamente)

# El alias se puede utilizar dentro de la estructura actual (consulta)
SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
	FROM cita AS t1, contacto AS t2
	WHERE t1.cit_id = t2.con_id;

# La palabra AS es opcional
# Igual que arriba, pero sin la palabra AS

SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
	FROM cita t1, contacto t2
    WHERE t1.cit_con_id = t2.con_id;

# Nota: El uso de la palabra AS es indistinto (opcional)
# pero se recomienda usarlo (ser explícito)

# Usando el resultado de una consulta como una tabla temporal
SELECT resultado.* 
	FROM
		(SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
			FROM cita AS t1, contacto AS t2
			WHERE t1.cit_id = t2.con_id) AS resultado;
            
# Devuelve todos los atributos de la tabla temporal llamada resltado
# Reultado contiene los atributos indicados en la consulta interna
# cit_fecha, cit_hora, cit_lugar, con_nombre, con_telefono
SELECT resultado.cit_fecha, resultado.cit_hora, resultado.cit_lugar, resultado.con_nombre , resultado.con_telefono
	FROM
		(SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
			FROM cita AS t1, contacto AS t2
			WHERE t1.cit_id = t2.con_id) AS resultado;
            
# Devuelve todos los atributos de la tabla temporal llamada resltado
# Reultado contiene los atributos indicados en la consulta interna
# cit_fecha, con_nombre
SELECT resultado.cit_fecha, resultado.con_nombre
	FROM
		(SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
			FROM cita AS t1, contacto AS t2
			WHERE t1.cit_id = t2.con_id) AS resultado;
            
# SELECCIONAR REGISTROS DIFERENTES (DISTINTOS)

# Elimina registros repetidos del resultado de la consulta

# Devuelve cit_fecha para todos los registros de la tabla cita
SELECT DISTINCT cit_fecha
	FROM cita;
    
# Devuelve cit_fecha para todos los registros de la tabla cita, sólo aquellos registros que son diferentes
SELECT DISTINCT cit_fecha
	FROM cita;
    
# Devuelve cit_fecha y cit_con_id para todos los registros de la tabla cita, sólo aquellos registros que son diferentes
SELECT DISTINCT cit_fecha, cit_con_id
	FROM cita;
    
    
# USO DE UNA FUNCIÓN BÁSICA CON SELECT

# CONCATENAMIENTO DE COLUMNAS

# Se concatenan dos atributos de tipo VARCHAR (strings)
# Se generan dos columnas (temporales / virtuaales) que contienen la concatenación 
# de los atributos / columnas indicados

# Cada columna lleva el nombre de la función aplicada
# Columna 1: CONCAT(con_nombre, '----', con_correo, '++++')
# Columna 2: CONCAT(con_direccion, '*****', con_telefono)
SELECT CONCAT(con_nombre, '----', con_correo, '++++'),
	   CONCAT(con_direccion, '*****', con_telefono)
       FROM contacto;

# La función se aplica sobre cada registro de la(s) tabla(s) como en un ciclo FOR

# Usando un alias para cambiar el nombre de la columna resultado en una función

# Se cambia el nombre de la columna temporal resultante de la función
SELECT CONCAT(con_nombre, '----', con_correo, '++++') AS nombre_correo,
	   CONCAT(con_direccion, '*****', con_telefono) AS dir_tel
       FROM contacto;
       
       
# ORDEN DE RECUPERACIÓN DE LOS DATOS

# El orden incial en el que SELECT recupera los fatos es el orden original
# el que fueron insertados en las tablas

# Cambiar el orden de recuperación de los datos
# ORDER BY [nombre_columna1] [ASC|DESC], 
#  		   [nombre_columna2] [ASC|DESC], 
# 		   [nombre_columna3] [ASC|DESC], 
# 		   ....

# Ordena el resultado de la consulta, de acuerdo con una o más columnas indicadas.
# Por default el orden ASC (ascendente) (menor a mayor)
# DESC = descendente (mayor a menor)

# Devuelve las columnas indicadas para todos los registros de la tabla cita, ordenados de acuerdo
# con el atributo cit_fecha de forma ascendente 
# Las fechas más antiguas al final, las fechas más recinetes al final.
# Si no se específica el tpo de orden (ASC|DESC) siempre será ASC
SELECT 
    cit_fecha, cit_hora, cit_lugar
FROM
    cita
ORDER BY cit_fecha ASC;

# Devuelve las columnas indicadas para todos los registros de la tabla cita, ordenados de acuerdo
# con el atributo cit_fecha de forma descendente 
# Las fechas más antiguas al inicio, las fechas más recinetes al final.
# Si no se específica el tpo de orden (ASC|DESC) siempre será ASC
SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita
    ORDER BY cit_fecha DESC;

# Usando un alias para llamar al ORDER BY

# Igual que arriba pero cambiando el nombre de las columnas a recuperar de forma temporal utilizando un alias
# Esto cambia el título de las columnas en la tabla resultante.
# Puedo utilizar el nombre temporal dentro de la sección ORDER BY
SELECT cit_fecha AS fecha, cit_hora AS hora, cit_lugar AS lugar
	FROM cita
    ORDER BY fecha, hora DESC;
    
# NOTA: El nombre temporal de las columnas se puede utilizar en varias secciones del SELECT

# Devuelve las columnas indicadas, incluyendo el resultado de la función
# CONCAT, y les cambia el nombre a las columnas de forma temporal, usando
# un alias, para todos los registros de la tabla contacto.
# El resultado lo ordena de acuerdo con la columna nombre_correo,
# que es el resultado de la función CONCAT, de forma descendente.
SELECT CONCAT(con_nombre, '		', con_correo) AS nombre_correo, con_telefono AS telefono
	FROM contacto
    ORDER BY nombre_correo DESC;
    
# Incluyendo el WHERE para restringir qué registros quiero recuperar
# Nota 1: El ORDER BY va después del WHERE
# Nota 2: No se puede utilizar el alias de las columnas en el WHERE
SELECT cit_fecha AS fecha, cit_hora AS hora, cit_lugar AS lugar
	FROM cita
	WHERE cit_lugar = 'Centro'
	ORDER BY fecha DESC, hora ASC;
    
# Incluyendo más condiciones en el WHERE
SELECT cit_fecha AS fecha, cit_hora AS hora, cit_lugar AS lugar
	FROM cita
	WHERE (cit_lugar = 'Centro') AND (cit_hora BETWEEN '10:00:00' AND '16:00:00')
	ORDER BY fecha DESC, hora ASC;

# Nota: Es recomendable agrupar las condiciones en el WHERE con paréntesis,
# para evitar problemas con la precedencia de los operadores.

# (cit_lugar = 'Centro') AND (cit_hora BETWEEN 10:00:00° AND 16:00:00') AND (cit_ fecha = '2023-04-05')

# (ci_lugar = 'Centro' OR cit_lugar = 'Vía Alta') AND (cit_hora BETWEEN '09:00:00' AND '12:00:00')
# AND (cit fecha IN ('2023-04-05', '2023-05-05'))


# LIMITAR EL NÚMERO DE REGISTROS A RECUPERAR

# LIMIT [numero1], [numero2]
# Limita el número de registros que recupera la sentencia SELECT
# Con un número, recupera los n primeros registros a partir del registro 0.
# Si se le dan dos números, el primer número indica la # posición del primer registros a recuperar (iniciando en 0).
# El segundo número indica el máximo número de registros a recuperar.

# Recupera los 3 primeros registros de la tabla cita
SELECT *
	FROM cita
	LIMIT 3;
    
# Nota (CUIDADO): No hay una garantía de que siempre vaya a recuperar los mismos registros.
# Esto depende de cómo es que MySQL está guardando internamente los datos.
# Puede moverIel orden para hacerlo más eficiente.

# Recupera 5 registros de la tabla cita, a partir de la posición 2, contando desde 0.
SELECT *
	FROM cita
    LIMIT 2, 5;
    
# En principio, los registros no tienen orden determinado, más allá del que internamente les da MySQL. 
# Pero este orden puede cambiar según se inserten, modifiquen o borren registros.
# Si se quiere tener un orden garantizado para limitar los registros a recuperar, se debe utilizar primero un ORDER BY

# Nota: LIMIT va después de ORDER BY

# Paso 1: Recupera todas las columnas de la tabla contacto
# Paso 2: Las ordena por con_ nombre de forma descendente
# Paso 3: Limita el resultado de la consulta a solo 3 registros a partir de la posición 2 (contando desde 9)
SELECT *
	FROM contacto
	ORDER BY con_nombre DESC
	LIMIT 2, 3;

# Secuencia de las secciones del SELECT
# WHERE: 		Filtrar registros
# ORDER BY: 	Ordenar
# LIMIT: 		Limitar

SELECT *
	FROM contacto
	WHERE con_correo LIKE '%ugto.mx'
	ORDER BY con_nombre DESC
	LIMIT 2, 3;


# 7. CONSULTAS 3 | JOINS (INNER, LEFT, RIGHT)
# Consultar datos en la BD de agenda:

# Recuperar el nombre y teléfono de los contactos, junto con la fecha, hora y lugar de cada una de sus citas.
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto
	INNER JOIN cita
		ON contacto.con_id = cita.cit_con_id;

# Recuperar el nombre y teléfono de los contactos, junto con la fecha, hora y lugar de cada una de sus citas. Incluir a  los contactos que no tengan citas.
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto
	LEFT JOIN cita
		ON contacto.con_id = cita.cit_con_id;
        
# Recuperar el nombre y teléfono de los contactos, junto con la fecha, hora y lugar de cada una de sus citas. Incluir a las citas que no tengan un contacto asignado.
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto
	RIGHT JOIN cita
		ON contacto.con_id = cita.cit_con_id;
        
# Recuperar el nombre y teléfono de los contactos, junto con la fecha, hora y lugar de cada una de sus citas, pero solo aquellos contactos cuyo teléfono inicie con '442' o '464'. Incluir a  los contactos que no tengan citas.
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto
	LEFT JOIN cita
		ON contacto.con_id = cita.cit_con_id
	WHERE (contacto.con_telefono LIKE '442%' OR contacto.con_telefono LIKE '464%');
        
# Recuperar el nombre y teléfono de los contactos, junto con la fecha, hora y lugar de cada una de sus citas, pero solo aquellas citas que sean de los meses abril o mayo. Incluir a las citas que no tengan un contacto asignado.
SELECT contacto.con_nombre, contacto.con_telefono, cita.cit_fecha, cita.cit_hora, cita.cit_lugar
	FROM contacto
	RIGHT JOIN cita
		ON contacto.con_id = cita.cit_con_id
	WHERE MONTH(cita.cit_fecha) IN ('04', '05');


# 8 CONSULTAS 4 | GROUP BY (CON HAVING)
# Consultar datos en la BD de agenda:

# Recuperar el número de contactos por los tres primeros dígitos del teléfono. Usar la función SUBSTR(str, pos, n) aplicada sobre el télefono.
#		SUBSTR extrae un substring de un string
#		str: el string original
#		pos: la posición a partir de la cual extraer el substring
#		n: el número de caracteres del substring a extraer
SELECT SUBSTR(con_telefono, 1, 3) AS lada, COUNT(*) AS numero_contactos
	FROM contacto
    GROUP BY lada;

# Recuperar el número de citas que tiene cada id de usuario.
SELECT cit_con_id, COUNT(cit_con_id) AS numero_citas
	FROM cita
    GROUP BY cit_con_id;

# Recuperar el número de citas que tiene cada id de usuario pero solo los que tengan 2, 4 o 6 citas.
SELECT cit_con_id, COUNT(cit_con_id) AS numero_citas
	FROM cita
    GROUP BY cit_con_id
    HAVING numero_citas IN (2, 4, 6);
    
# Recuperar el número de citas por fecha.
SELECT cit_fecha, COUNT(cit_fecha) AS numero_citas
	FROM cita
    GROUP BY cit_fecha;
    
# Recuperar el número de citas por año.
SELECT YEAR(cit_fecha) AS anio, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY anio;
    
# Recuperar el número de citas por mes.
SELECT MONTH(cit_fecha) AS mes, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY mes;
    
# Recuperar el número de citas por lugar y ordenar de mayor a menor.
SELECT cit_lugar, COUNT(cit_lugar) AS numero_citas
	FROM cita
    GROUP BY cit_lugar
    ORDER BY numero_citas DESC;
    
# Recuperar el número de citas por lugar, ordenar de menor a mayor y limitar a los 2 primeros registros.
SELECT cit_lugar, COUNT(cit_lugar) AS numero_citas
	FROM cita
    GROUP BY cit_lugar
    ORDER BY numero_citas ASC
    LIMIT 2;
    
# Recuperar el número de citas por la combinación de mes y lugar, ordenar de menor a mayor.
SELECT CONCAT(MONTH(cit_fecha), '	', cit_lugar) AS mes_lugar, COUNT(*) AS numero_citas
	FROM cita
    GROUP BY mes_lugar
    ORDER BY numero_citas ASC;
