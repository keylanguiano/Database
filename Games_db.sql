# Created by: Equipo
# Date 09/05/2023
# Definition: Crear una base de datos para controlar la información de un videojuego.

# Crea la bases de datos si no existe, si ya existe, ignora la instruccion
CREATE DATABASE IF NOT EXISTS games_db;

# Selección de la base de datos
USE games_db;


# TABLA USUARIO

# Elegimos una llave primaria artificial (usu_id) para proporcionar una identificación única y numérica a cada usuario. 
# Optamos por esta elección debido a que los nombres de usuario y correos electrónicos pueden cambiar o no ser únicos a largo plazo, 
# lo que los hace inadecuados como claves primarias. 
# Además, utilizamos frecuentemente el atributo usu_id en esta base de datos, lo cual lo hace más práctico su uso.
#En la tabla usuario optamos pedir solamente un usename, en la mayoria de videojuegos nos es irrelevante el nombre real de los usuarios.

CREATE TABLE IF NOT EXISTS usuario (
	usu_id INT NOT NULL AUTO_INCREMENT,
	usu_username VARCHAR(20) NOT NULL,
	usu_correo VARCHAR(50) NOT NULL,
	usu_password VARCHAR(25) NOT NULL,
	usu_genero ENUM('M', 'F', 'X') NOT NULL COMMENT'Masculino,Femenino,Otro',
	usu_fecha_nacimiento DATE NOT NULL,
	usu_fecha_registro DATE NOT NULL,
	usu_creditos INT NOT NULL DEFAULT 100 COMMENT 'La unidad es cr,todos los precios y cantidades son enteras', 
	usu_puntuacion INT NOT NULL DEFAULT 0 COMMENT 'Cantidad entera que representa el poder del usuario', 

	PRIMARY KEY (usu_id),
  
	UNIQUE uni_username (usu_username),
	UNIQUE uni_correo (usu_correo),
    INDEX idx_fecha_registro(usu_fecha_registro)
);


# TABLA PERSONAJE

# Optamos por una llave primaria artificial (per_id) para asignar una identificación única y numérica a cada personaje. 
# Esta elección se basa en que los nombres de personaje pueden cambiar, por lo que no son adecuados como claves primarias. 
# Además, en esta base de datos utilizamos frecuentemente el atributo per_id, lo cual simplifica su uso.

CREATE TABLE IF NOT EXISTS personaje (
	per_id INT NOT NULL AUTO_INCREMENT,
	per_nombre VARCHAR(50) NOT NULL,
    per_velocidad INT NOT NULL COMMENT 'Cantidad entera que representa la velocidad del personaje' ,
    per_vida INT NOT NULL  COMMENT 'Cantidad entera que representa la vida del personaje',
    per_potencial_destruccion INT NOT NULL COMMENT 'Cantidad entera que representa el poder de ataque del personaje',
    per_potencial_defensa INT NOT NULL COMMENT 'Cantidad entera que representa el poder de defensa del personaje',
    per_media DECIMAL(8,2),
  
	PRIMARY KEY (per_id),
  
	UNIQUE uni_nombre (per_nombre),
    INDEX idx_media(per_media)
);


# TABLA ARMA_ACCESORIO

# Hemos elegido una llave primaria artificial (aac_id) para asignar una identificación única y numérica a cada arma/accesorio. 
# Esta elección se basa en que los nombres de armas o accesorios pueden cambiar o no ser únicos a largo plazo, 
# por lo que no son adecuados como claves primarias. 
# Además, utilizamos frecuentemente el atributo aac_id en esta base de datos, lo cual facilita su uso.

# Hay otra opcion que es hacer tres tablas diferentes
CREATE TABLE IF NOT EXISTS arma_accesorio (
	aac_id INT NOT NULL AUTO_INCREMENT,
	aac_nombre VARCHAR(50) NOT NULL,
	aac_clasificacion ENUM('Arma','Accesorio'),
	aac_potencia INT DEFAULT 0 COMMENT 'Cantidad entera que representa el poder de ataque o defensa del personaje,dependiendo de su clasificacion',
	aac_costo INT NOT NULL COMMENT'La unidad es cr,todos los precios y cantidades son enteras' ,
    aac_tienda ENUM('SI','NO') DEFAULT 'SI',
  
	PRIMARY KEY (aac_id),
  
	UNIQUE uni_nombre (aac_nombre),
    INDEX idx_clasificacion(aac_clasificacion)
);


# TABLA USUARIO_PERSONAJE

# Elegimos utilizar una llave primaria artificial (usp_id) en la tabla para evitar tener una llave primaria compuesta por dos atributos. 
# Al utilizar una llave primaria compuesta, se crearía una dependencia adicional con respecto a otras tablas, lo que podría complicar el 
# iseño y el mantenimiento de la base de datos.

# Para la tabla usuario_personaje establecimos llaves foráneas con las tablas usuario y personaje con las acciones ON DELETE RESTRICT y 
# ON UPDATE CASCADE. Esto significa que no se permitira eliminar a un personaje o usuario si estan relacionados en la tabla 
# usuario personaje, se pusieron actualizacion en cascada ya que si se hacen cambios en la tabla principal deben ser actualizados 
# en la tabla secondaria.
# Esta configuración garantiza la integridad referencial y evita la existencia de registros erróneos en nuestra tabla.

CREATE TABLE IF NOT EXISTS usuario_personaje (
	usp_id INT NOT NULL AUTO_INCREMENT,
    usp_usu_id INT NOT NULL,
    usp_per_id INT NOT NULL,
    usp_fecha_adquisicion DATETIME NOT NULL,
    usp_hora_adquisicion TIME NOT NULL,
	
    PRIMARY KEY (usp_id),
  
	UNIQUE idx_usuario_personaje (usp_usu_id,usp_per_id),
	
    CONSTRAINT fk_usuario_usp
		FOREIGN KEY (usp_usu_id) 
		REFERENCES usuario(usu_id) 
        
		ON DELETE RESTRICT 
		ON UPDATE CASCADE,
    
    CONSTRAINT fk_personaje_usp
		FOREIGN KEY (usp_per_id) 
		REFERENCES personaje(per_id) 
        
		ON DELETE RESTRICT
		ON UPDATE CASCADE
    
);


# TABLA TRANSACCION

# La tabla transaccion genera un id de transaccion cuando el usuario realiza la compra de articulos para uno de sus personajes,
# aqui se alojan los datos que nos puedan ser de utilidad en un futuro, como lo es el monto total y la fecha en que se realizo

# Se selecciono una llave primaria artificial (tra_id) en la tabla para contar con un indicador numérico único para cada transacción, 
# lo que mejora la eficiencia en la identificación, ordenamiento y gestión de las operaciones en la tabla. 
# Esto evita la necesidad de una clave primaria compuesta y simplifica el seguimiento y referencia de transacciones específicas.

# Las claves foráneas en las tablas transaccion y arsenal se configuran con las acciones ON DELETE y ON UPDATE CASCADE para garantizar la integridad referencial. 
# Esto evita la existencia de registros vacíos y mantiene la coherencia de los datos. 
# Al eliminar o actualizar registros en las tablas relacionadas, estas acciones se aplican en cascada, asegurando que los datos relacionados se actualicen o eliminen 
# de manera consistente en las operaciones.

CREATE TABLE IF NOT EXISTS transaccion(
	tra_id INT NOT NULL AUTO_INCREMENT,
    tra_fecha_realizada DATETIME NOT NULL,
    tra_hora_realizada TIME NOT NULL,
    tra_monto_total INT NOT NULL COMMENT'La unidad es cr,todos los precios y cantidades son enteras',
    tra_usu_id INT NOT NULL,
    tra_usp_id INT NOT NULL,
    
    PRIMARY KEY(tra_id), 
    
    INDEX idx_usuario(tra_usu_id),
    INDEX idx_personaje(tra_usp_id),
    
    CONSTRAINT fk_usp_transaccion
		FOREIGN KEY (tra_usp_id)
		REFERENCES usuario_personaje(usp_id)
        
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


# TABLA COMPRA

# La tabla compra muestra los articulos que fueron comprados en cada transaccion ademas de su precio unitario

# En la tabla se utilizó una llave primaria compuesta formada por los identificadores de transacción (com_tra_id) y 
# arma_accesorio (com_aac_id). Esta elección garantiza la unicidad de cada compra y asegura la integridad de los datos. 
# Al no requerir una llave adicional autoincrementable, se simplifica la estructura de la tabla, además, esta configuración permite 
# registrar en una misma transacción la adquisición de varios productos, ya que la llave primaria compuesta permite tener múltiples 
#registros de compras asociados a una única transacción. 

# Se estableció que la liga entre la tabla transacción y la tabla compra cuente con las acciones ON DELETE y ON UPDATE CASCADE. 
# Esto implica que si se elimina o actualiza un registro en la tabla de referencia (transacción), se aplicarán las mismas operaciones en
# la tabla compra. De esta manera, se asegura la integridad referencial y se mantiene la consistencia de los datos entre ambas tablas.

# Por otro lado, la liga entre la tabla arma_accesorio y la tabla compra tiene definidas las acciones ON DELETE RESTRICT y ON UPDATE 
# CASCADE Esto significa que si se intenta eliminar un registro en la tabla de arma_accesorio, se restringirá dicha operación si existen 
# registros en la tabla compra que hacen referencia a ese valor, la actualizacion en cascada nos permite actualizar los datos de la 
# tabla principal para que no se pierda la integrida referencial. 

CREATE TABLE IF NOT EXISTS compra (
	com_tra_id INT NOT NULL,
	com_aac_id INT NOT NULL,
	com_precio_unidad INT NOT NULL COMMENT'La unidad es cr,todos los precios y cantidades son enteras',
    
    PRIMARY KEY (com_tra_id, com_aac_id),
    
    INDEX idx_articulo(com_aac_id),
    
	CONSTRAINT fk_transaccion_compra
		FOREIGN KEY (com_tra_id) 
        REFERENCES transaccion(tra_id) 
        
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_acc_compra
		FOREIGN KEY (com_aac_id) 
        REFERENCES arma_accesorio(aac_id)
        
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


# TABLA ARSENAL

# Utilizamos una llave primaria artificial (ars_id) para garantizar la unicidad de cada registro, esta elección simplifica
# la estructura de la tabla y evita la necesidad de llaves primarias compuestas. 
# El atributo ars_id será utilizado frecuentemente en la base de datos, lo que lo convierte en un dato práctico y eficiente 
# para realizar operaciones de búsqueda, actualización y referencia en la tabla.

# Se estableció que las acciones ON UPDATE para ambas claves foráneas sean CASCADE,la llave foranea de usuario_personaje conserva estos cambios,
# sin embargo la llave forane de arma_accesorio lleva un RESTRICT. 
# Esto implica que si se actualiza un registro en la tabla de referencia (usuario_personaje o arma_accesorio), 
# se llevarán a cabo las mismas operaciones en la tabla arsenal al igual que si se elimina algun personaje del usuario,
# el restrict en la llave foranea de arma_accesorio no permite eliminar armas si es que algun usuario compro alguna. 
# Esta configuración asegura la integridad referencial y evita la presencia de registros huérfanos en la tabla arsenal.

CREATE TABLE IF NOT EXISTS arsenal (
	  ars_id INT NOT NULL AUTO_INCREMENT,
	  ars_usp_id INT NOT NULL,
	  ars_aac_id INT NOT NULL,
	  
	  PRIMARY KEY (ars_id),
	  
	  INDEX idx_articulo (ars_aac_id),
      
      CONSTRAINT fk_usp_arsenal
		FOREIGN KEY (ars_usp_id) 
		REFERENCES usuario_personaje(usp_id) 
        
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	
    CONSTRAINT fk_acc_arsenal
		FOREIGN KEY (ars_aac_id) 
		REFERENCES arma_accesorio (aac_id) 
        
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);  


# TABLA CLAN

# Hemos elegido una llave primaria artificial (cla_id) para proporcionar una identificación única y numérica a cada clan. 
# Esta elección se basa en que no existe una clave primaria natural evidente en esta tabla.

# En las condiciones ON DELETE y ON UPDATE, hemos utilizado CASCADE para mantener la integridad referencial. 
# Si se elimina o actualiza un clan, todas las referencias a ese clan en otras tablas también se eliminarán o actualizarán en cascada.

CREATE TABLE IF NOT EXISTS clan (
	cla_id INT NOT NULL AUTO_INCREMENT,
	cla_nombre VARCHAR(50) NOT NULL,
	cla_descripcion VARCHAR(100) NOT NULL,
	cla_puntuacion INT NOT NULL DEFAULT 0 COMMENT'Cantidad entera que representa el poder del clan',
	PRIMARY KEY (cla_id),
  
	UNIQUE (cla_nombre),
	INDEX idx_cla_puntuacion (cla_puntuacion)
);


# TABLA CLAN_MIEMBRO

# Se eligió una llave primaria artificial utilizando el atributo clm_id con la opción AUTO_INCREMENT. 
# Esta elección se basa en la necesidad de tener identificadores únicos para cada registro en la tabla clan_miembro. 
# Al utilizar una llave primaria artificial, se asegura la unicidad de los registros y se facilitan las operaciones
# de búsqueda y manipulación de datos.

# Se especificó que las acciones ON DELETE y ON UPDATE para ambas claves foráneas sean CASCADE. 
# Esto significa que si se elimina o actualiza un registro en la tabla referenciada (usuario o clan), 
# se aplicarán las mismas operaciones en la tabla clan_miembro. Esta configuración garantiza la integridad referencial 
# y evita la existencia de registros huérfanos en la tabla clan_miembro.

CREATE TABLE IF NOT EXISTS clan_miembro (
	clm_id INT NOT NULL AUTO_INCREMENT,
	clm_usuario_id INT NOT NULL,
	clm_clan_id INT NOT NULL,
	clm_fecha_ingreso DATETIME NOT NULL,
	clm_usuario_puntuacion INT NOT NULL DEFAULT 0 COMMENT'Cantidad entera que representa el poder del usuario dentro del clan',
	clm_rango ENUM('Jefe','General','Peón') NOT NULL,
  
	PRIMARY KEY (cLm_id),

	INDEX idx_rango(clm_rango),
    
    CONSTRAINT fk_usuario_clm
		FOREIGN KEY (clm_usuario_id) 
		REFERENCES usuario(usu_id) 
		
        ON DELETE CASCADE 
		ON UPDATE CASCADE,
        
	CONSTRAINT fk_clan_clm
		FOREIGN KEY (clm_clan_id) 
		REFERENCES clan(cla_id) 
		
        ON DELETE CASCADE 
		ON UPDATE CASCADE
);

ALTER TABLE usuario_personaje
	ADD usp_potencial_destruccion INT;

ALTER TABLE usuario_personaje
	ADD usp_potencial_defensa INT;

ALTER TABLE clan_miembro
	ADD CONSTRAINT uni_clan_miembro UNIQUE (clm_usuario_id);

INSERT INTO usuario (usu_username, usu_correo, usu_password, usu_genero, usu_fecha_nacimiento, usu_fecha_registro, usu_creditos, usu_puntuacion)
	VALUES('admin', 'admin@example.com', 'admin123', 'F', '2003-10-20', '2023-06-05', 100, 0),
		  ('usuario1', 'usuario1@example.com', 'contraseña1', 'F', '1990-01-01', '2023-06-05', 2000, 0),
		  ('usuario2', 'usuario2@example.com', 'contraseña2', 'M', '1992-03-15', '2023-06-05', 100, 0),
          ('usuario3', 'usuario3@example.com', 'contraseña3', 'X', '1995-07-20', '2023-06-05', 100, 0),
          ('usuario4', 'usuario4@example.com', 'contraseña4', 'F', '1988-12-10', '2023-06-05', 100, 0);
          
INSERT INTO personaje (per_nombre, per_velocidad, per_vida, per_potencial_destruccion, per_potencial_defensa, per_media)
	VALUES ('Personaje1', 80, 100, 90, 80, 87.5),
	       ('Personaje2', 70, 120, 80, 100, 92.5),
	       ('Personaje3', 90, 80, 100, 70, 85);

INSERT INTO arma_accesorio (aac_nombre, aac_clasificacion, aac_potencia, aac_costo, aac_tienda)
	VALUES ('Espada', 'Arma', 50, 200, 'SI'),
	       ('Escudo', 'Accesorio', 0, 150, 'SI'),
	       ('Arco', 'Arma', 70, 300, 'SI'),
	       ('Poción de curación', 'Accesorio', 0, 50, 'SI');

INSERT INTO clan (cla_nombre, cla_descripcion)
	VALUES ('Clan 1', 'Descripción del Clan 1'),
		   ('Clan 2', 'Descripción del Clan 2'),
           ('Clan 3', 'Descripción del Clan 3');
           
INSERT INTO usuario_personaje (usp_usu_id, usp_per_id, usp_fecha_adquisicion, usp_hora_adquisicion, usp_potencial_destruccion, usp_potencial_defensa)
	VALUES (2, 1, '2023-06-06 12:00:00', '12:00:00', 140, 80),
		   (2, 2, '2023-06-06 13:00:00', '13:00:00', 150, 100),
		   (3, 1, '2023-06-06 14:00:00', '14:00:00', 90, 80),
		   (3, 3, '2023-06-06 15:00:00', '15:00:00', 100, 70),
		   (4, 2, '2023-06-06 16:00:00', '16:00:00', 80, 100),
		   (4, 3, '2023-06-06 17:00:00', '17:00:00', 100, 70),
		   (5, 1, '2023-06-06 18:00:00', '18:00:00', 90, 8),
		   (5, 2, '2023-06-06 19:00:00', '19:00:00', 80, 100);
           
INSERT INTO arsenal (ars_usp_id, ars_aac_id)
	VALUES (1, 1), 
		   (1, 2), 
           (2, 3), 
           (2, 4),
           (3, 1), 
		   (3, 2), 
           (4, 3), 
           (4, 4);

INSERT INTO clan_miembro (clm_usuario_id, clm_clan_id, clm_fecha_ingreso, clm_usuario_puntuacion, clm_rango)
	VALUES (2, 1, '2023-06-05 12:00:00', 0, 'Jefe'),
		   (3, 1, '2023-06-05 12:00:00', 0, 'General'),
           (4, 2, '2023-06-05 12:00:00', 0, 'Peón'),
           (5, 2, '2023-06-05 12:00:00', 0, 'Peón');
