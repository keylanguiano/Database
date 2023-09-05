# Created by: Anguiano Cabrera Keyla Leilani
# date 14/03/23
# Definition: Crear una base de datos una base de datos encargada de controlar 
# la información de préstamos en una biblioteca.

CREATE DATABASE IF NOT EXISTS biblioteca_db; # Crea la bases de datos si no existe
											 # si ya existe, ignora la instruccion
# Abrir la base de de datos para poner cosas dentro de 
# ella (manipular su estructura o sus datos)

USE biblioteca_db;

# Super llaves
# [correo], [nombre, correo], [apellido paterno, correo], [apellido paterno, apellido materno, correo]
# [nombre, carrera, correo], [nombre, apellido paterno, correo], [nombre, apellido paterno, apellido materno, correo], 
# [nombre, apellido paterno, carrera, correo], [nombre, apellido paterno, apellido materno, carrera, correo]

# Llaves candidatas
# [correo]

# Llave primaria
# [nua]

# Llaves alternativas
# [correo]

#crear tabla de estudiantes 
CREATE TABLE IF NOT EXISTS estudiante(
	est_nua INT NOT NULL AUTO_INCREMENT,
    est_nombre VARCHAR (30)  NOT NULL,
    est_ap_paterno VARCHAR(30) NOT NULL,
    est_ap_materno VARCHAR(30) NOT NULL,
    est_carrera  VARCHAR(7) NOT NULL COMMENT 'Sólo almacenar las siglas de la carrera, LISC o ',
    est_correo VARCHAR(25) NOT NULL,
    est_activo ENUM('S', 'N') NOT NULL,
    
    PRIMARY KEY (est_nua),
								
    INDEX idx_nombre (est_nombre),
    INDEX idx_correo (est_correo),
    INDEX idx_apellido_paterno (est_ap_paterno),
    
    UNIQUE uni_correo (est_correo)
);

# Super llaves
# [isbn], [isbn, autor], [isbn, titulo], [isbn, genero], [isbn, editorial], [isbn, fecha] 
# [isbn, autor, titulo], [isbn, titulo, genero], [isbn, genero, editorial], [isbn, editorial, fecha]
# [titulo, autor, fecha publicacion], [titulo, fecha publicacion, genero]

# Llaves candidatas
# [isbn]

# Llaves primaria
# [isbn]

# Llaves alternas
# No hay

CREATE TABLE IF NOT EXISTS libro (
	lib_id INT NOT NULL AUTO_INCREMENT,
    lib_titulo VARCHAR (30) NOT NULL,
    lib_autor VARCHAR (60) NOT NULL,
    lib_editorial VARCHAR (20) NOT NULL,
    lib_edicion VARCHAR (20) NOT NULL,
    lib_isbn INT NOT NULL,
    lib_fecha_publicacion DATE NOT NULL,
    lib_pais_edicion VARCHAR (20) NOT NULL,
    lib_genero VARCHAR (20) NOT NULL,         
    lib_paginas INT NOT NULL,
    
    PRIMARY KEY (lib_id),
								
    INDEX idx_titulo (lib_titulo),
    INDEX idx_autor (lib_autor),
    INDEX idx_editorial (lib_editorial),
    INDEX idx_genero (lib_genero),
    
	UNIQUE uni_titulo_autor_fecha (lib_titulo, lib_autor, lib_fecha_publicacion),
	UNIQUE uni_titulo_fecha_genero (lib_titulo, lib_fecha_publicacion, lib_genero)
    
);
    
# Crear la tabla prestamo
CREATE TABLE IF NOT EXISTS prestamo (
	pre_id INT NOT NULL AUTO_INCREMENT,
	pre_est_nua INT NOT NULL,
	pre_fecha_prestamo DATE NOT NULL,
	pre_fecha_max_devolucion DATE NOT NULL,
    
    PRIMARY KEY (pre_id),
    
    INDEX idx_fecha (pre_fecha_prestamo),
        
	CONSTRAINT fk_pre_est
		FOREIGN KEY (pre_est_nua)
		REFERENCES estudiante (est_nua)
        
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


# Crear la tabla detalle
CREATE TABLE IF NOT EXISTS detalle (
	det_pre_id INT NOT NULL,
    det_lib_id INT NOT NULL,
    det_fecha_devolucion DATE NOT NULL,
    det_multa DECIMAL(7, 2),
    
    PRIMARY KEY(det_pre_id, det_lib_id),
    
    INDEX idx_fecha (det_fecha_devolucion),
    
     CONSTRAINT fk_det_pre
		FOREIGN KEY (det_pre_id)
		REFERENCES prestamo (pre_id)
        
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_det_lib
		FOREIGN KEY (det_lib_id)
		REFERENCES libro (lib_id)
        
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_carrera, est_activo)
	VALUES ('Zair Pedro', 'Gomez', 'Meléndez', 'zpgm@ugto.mx', 'LISC', 'S'),
		   ('Emilio', 'Martínez', 'López', 'eml@ugto.mx', 'LICE', 'S');
           
INSERT INTO libro (lib_titulo, lib_autor, lib_editorial, lib_edicion, lib_isbn, lib_fecha_publicacion, lib_pais_edicion, lib_genero, lib_paginas)
	VALUES ('Python', 'Karla', 'McGrawHill', 1, '0091', '2003-01-01', 'Estados Unidos', 'Programación', 300),
		   ('MySQL', 'Tania', 'Pearson', 5, '0005', '2003-12-31', 'México', 'BD', 300);
           
INSERT INTO prestamo (pre_est_nua, pre_fecha_prestamo, pre_fecha_max_devolucion)
	VALUES (1, '2023-01-01', '2023-02-01');