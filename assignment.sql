# Created by: Anguiano Cabrera Keyla Leilani
# Date: 19/05/2023
# Definition: Práctica individual

# LENGUAJE DE DEFINICIÓN DE DATOS

CREATE DATABASE IF NOT EXISTS registro_cursos_db;

USE registro_cursos_db;


# TABLA MAESTRO

# Seleccione una llave primaria artificial, ya que dentro de una escuela pueden laborar una gran cantidad de maestros,
# de los cuales su nombre puede ser idéntico, y el correo que si es un atributo único puede llegar a ser un dato extenso,
# de este modo, al ser un valor que se asigna automáticamente evitamos la posible duplicidad y falta de integridad de los datos.

# Crear tabla de maestro 
CREATE TABLE IF NOT EXISTS maestro(
	mae_nue INT NOT NULL AUTO_INCREMENT,
    mae_nombre VARCHAR (30)  NOT NULL,
    mae_ap_paterno VARCHAR (20) NOT NULL,
    mae_ap_materno VARCHAR (20),
    mae_correo VARCHAR(30) NOT NULL,
    mae_titulo VARCHAR (50) NOT NULL COMMENT 'Indique el grado académico máximo del profesor',
    mae_nombramiento ENUM ('Tiempo Completo', 'Tiempo Parcial', 'Asignatura') NOT NULL,
    
    PRIMARY KEY (mae_nue),
								
    INDEX idx_nombre_completo (mae_ap_paterno, mae_ap_materno, mae_nombre),
    INDEX idx_titulo (mae_titulo),
    INDEX idx_nombramiento (mae_nombramiento),
    
    UNIQUE uni_correo (mae_correo)
    
);


# TABLA DIVISIÓN

# Con esta tabla decidí implementar una llave primaria natural, debido a que la identificación de las divisiones es más practica y eficiente por medio
# de sus iniciales reconocidas, que por una enumeración, además de que evitamos generar un nuevo atributo autoincrementable.

# Crear tabla de división
CREATE TABLE IF NOT EXISTS division(
	div_abrv VARCHAR (7) NOT NULL COMMENT 'Las iniciales de la división, p. ej. DICIS',
    div_nombre VARCHAR(60) NOT NULL,
    div_campus ENUM ('Guanajuato', 'Celaya-Salvatierra', 'Irapuato-Salamanca', 'León') NOT NULL,
    div_sede VARCHAR (15) NOT NULL COMMENT 'La ciudad de la carrera, p. ej. Salamanca',
    
    PRIMARY KEY (div_abrv),
    
    INDEX idx_campus (div_campus),
    INDEX idx_sede (div_sede),
    
    UNIQUE INDEX uni_abrv_nombre (div_abrv, div_nombre),
	UNIQUE INDEX uni_abrv_nombre_campus_sede (div_abrv, div_nombre, div_campus, div_sede)
);


# TABLA CARRERA

# Elegí una llave primaria artificial, debido a que los nombres de las carreras suelen ser muy extensos, además de que
# pueden llegar cambiar, por lo tanto, no se pueden utilizar como identificadores únicos a largo plazo, además, en esta base
# de datos utilizamos frecuentemente a este atributo, por lo cual es máss práctico su uso.

# En las condiciones de ON DELETE y ON UPDATE, las consideré como RESTRICT, debido a que en el caso de que se quisiera dar de baja, 
# o eliminar alguna de las divisiones, debería de asegurarse que no hayan carreras habilitadas o estudiantes dentro de ellas.

# Crear tabla de carrera
CREATE TABLE IF NOT EXISTS carrera(
	car_id INT NOT NULL AUTO_INCREMENT,
    car_iniciales VARCHAR (5) NOT NULL COMMENT 'Las iniciales de la carrera, p. ej. LISC',
    car_nombre VARCHAR (60) NOT NULL COMMENT 'El nombre completo de la carrera, p. ej. Licenciatura  en  Ingenería  en  Sistemas Computacionales',
	car_division_abrv VARCHAR (7) NOT NULL,
  
	PRIMARY KEY (car_id),
  
	INDEX idx_iniciales (car_iniciales),
	INDEX idx_nombre (car_nombre),
    
    CONSTRAINT fk_division_carrera
		FOREIGN KEY (car_division_abrv)
		REFERENCES division(div_abrv)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
  );


# TABLA MATERIA

# En este caso hice uso de una llave primaria natural, la cual es la clave de la materia, ya que identifica de manera única 
# a cada una de las materias debido a su estructura, no hace falta adicionar otro atributo autoincrementable para conservar
# la integridad.

# Crear la tabla materia
CREATE TABLE IF NOT EXISTS materia(
	mat_clave VARCHAR (9) NOT NULL COMMENT 'La clave de la materia, p. ej. IILI06119',
    mat_nombre VARCHAR (50) NOT NULL COMMENT 'El nombre de la materia, p. ej. Sistemas  de  Administración de Datos',
    mat_creditos INT NOT NULL,
    mat_horas INT NOT NULL COMMENT 'Número de horas semanales',
    mat_descripcion VARCHAR (50),
    
	PRIMARY KEY (mat_clave),
  
	INDEX idx_nombre (mat_nombre),
  
	UNIQUE INDEX uni_clave_nombre (mat_clave, mat_nombre)
  );
  

# TABLA SEMESTRE

# Para esta tabla elegí una llave primaria natural compuesta por la combinación del año y las iniciales del curso,
# es un atributo con el cual ya contabamos, y cumple con la necesidad de ser única en cada caso, por lo cual no se 
# requiere generar un atributo adicional.

# Crear la tabla semestre
CREATE TABLE IF NOT EXISTS semestre(
	sem_clave VARCHAR (7) NOT NULL COMMENT 'Con el formato del año y las iniciales del curso, p. ej. 2023EJ',
    sem_nombre VARCHAR (30) NOT NULL COMMENT 'La descripción del semestre, p. ej. Semestre enero-junio 2023',
    
    PRIMARY KEY (sem_clave)
);


# TABLA ESTUDIANTE

# Seleccione una llave primaria artificial, ya que dentro de una escuela asisten grandes cantidades de alumnos,
# de los cuales, lo más probable es que existan nombres repetidos, y el correo que si es un atributo único puede llegar a ser un dato extenso,
# de este modo, al ser un valor que se asigna automáticamente evitamos la posible duplicidad y falta de integridad de los datos.

# En las condiciones de ON DELETE y ON UPDATE, las consideré como RESTRICT, esto debido a que si se pretendiera eliminar o dar de baja alguna
# de las carreras registradas, se debería de respetar la continuidad de los estudiantes que ya se encuentran inscritos en ella, no se debería
# permitir su eliminación sin antes asegurarse de que los alumnos de ella se encuentren graduados.

# Crear tabla de estudiante
CREATE TABLE IF NOT EXISTS estudiante(
	est_nua INT NOT NULL AUTO_INCREMENT,
    est_nombre VARCHAR (30)  NOT NULL,
    est_ap_paterno VARCHAR (20) NOT NULL,
    est_ap_materno VARCHAR (20),
    est_correo VARCHAR (30) NOT NULL,
    est_promedio DECIMAL (3.1) NOT NULL COMMENT 'Indique el puntaje del estudiante a lo largo de todos sus cursos',
    est_semestre INT NOT NULL COMMENT 'Indique el semestre actual del estudiante',
    est_carrera_id INT NOT NULL,
    est_telefono VARCHAR (10) NOT NULL,
    
    PRIMARY KEY (est_nua),
								
    INDEX idx_nombre_completo (est_ap_paterno, est_ap_materno, est_nombre),
    INDEX idx_semestre (est_semestre),
    INDEX idx_carrera (est_carrera_id),
    
    UNIQUE uni_correo (est_correo),
    UNIQUE uni_telefono (est_telefono), 
    
    CONSTRAINT fk_estudiante_carrera
		FOREIGN KEY (est_carrera_id)
		REFERENCES carrera(car_id)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT    
);


# TABLA INSCRIPCION

# Seleccione una llave primaria natural para esta tabla para contar con un mayor control de los datos, en este caso se realizarían bastantes inserciones
# por lo cual obtenemos mayor integridad, esta llave depende de la relación semestre, ya que solo debería existir un proceso de inscripción por semestre para
# los alumnos.

# En las condiciones de ON DELETE y ON UPDATE, las consideré como RESTRICT, debido a que si por alguna situación de la escuela en cuestión, se decidiese 
# cancelar las clases durante algún semestre, debería de revisar los datos de incripcion ya registrados.

# Crear la tabla inscripción
CREATE TABLE IF NOT EXISTS inscripcion(
	ins_semestre_clave VARCHAR (7) NOT NULL,
    ins_costo DECIMAL (6.2) NOT NULL COMMENT 'El monto que el estudiante está pagando por la inscripción al semestre actual en pesos mexicanos',
	ins_fecha_inicio DATE NOT NULL COMMENT 'La fecha inicial para la inscripción al semestre actual',
    ins_fecha_fin DATE NOT NULL COMMENT 'La fecha final para la inscripción al semestre actual',
    
    PRIMARY KEY (ins_semestre_clave),
    
    INDEX idx_semestre (ins_semestre_clave),
    
    UNIQUE uni_semestre_fecha_inicio_fin (ins_semestre_clave, ins_fecha_inicio, ins_fecha_fin),
    
    CONSTRAINT fk_inscripcion_semestre
		FOREIGN KEY (ins_semestre_clave)
		REFERENCES semestre(sem_clave)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);


# TABLA CARRERA

# Hice uso de una llave primaria artificial, en este caso existía otra llaves candidata posible, la cual englobara a las llaves foráneas que
# contiene, sin embargo, era una combinación muy extensa y su uso provoca la implementación de múltiples ligas para posteriores relacioes.

# En todas las condiciones de ON DELETE y ON UPDATE, las consideré como RESTRICT, en el primer caso donde se relaciona el curso con el semestre,
# En el caso del curso y la materia, lo consideré de esa forma ya que si en el momento se pretendiera eliminar una materia, se estuviese 
# impartiendo un curso de la misma, no debería permitirse su eliminación.
# Entre el curso y la materia igualmente lo contemplé como RESTRICT debido a que si un curso ya está siendo impartido de acuerdo a cierta materia,
# no debería de interrumpirse, solo se permitiría en el caso de que no esté activa dentro de alguno de ellos.
# En cuestión del curso y el maestro, consideré que para que se pudiese dar de baja a algún maestro debería culminar con los cursos que ya tiene 
# contemplados.

# Crear la tabla curso
CREATE TABLE IF NOT EXISTS curso(
	cur_id INT NOT NULL AUTO_INCREMENT,
	cur_semestre_clave VARCHAR (7) NOT NULL,
    cur_materia_clave VARCHAR (9) NOT NULL,
    cur_maestro_nue INT NOT NULL,
    cur_dias VARCHAR (30) NOT NULL COMMENT 'Los días en que se imparte el curso, p. ej. Lun-Vie (para Lunes y Viernes), Mar-Jue (para Martes y Jueves)',
    cur_horario VARCHAR (11) NOT NULL COMMENT 'El horario en que se imparte el curso, p. ej. 08.00-10.00',
    cur_grupo ENUM ('A', 'B', 'C', 'D', 'E') NOT NULL,
    cur_salon VARCHAR (10) NOT NULL COMMENT 'El aula donde se imparte el curso p. ej. Aula 101',
	
    PRIMARY KEY (cur_id),
    
    INDEX idx_materia (cur_materia_clave),
    INDEX idx_maestro (cur_maestro_nue),
    INDEX idx_dias (cur_dias),
    INDEX idx_salon (cur_salon),
    
    UNIQUE uni_semestre_maestro_dias_horario (cur_semestre_clave, cur_maestro_nue, cur_dias, cur_horario),
    UNIQUE uni_semestre_dias_horario_salon (cur_semestre_clave, cur_dias, cur_horario, cur_salon),
    UNIQUE uni_semestre_materia_grupo (cur_semestre_clave, cur_materia_clave, cur_grupo),
    
    CONSTRAINT fk_curso_semestre
		FOREIGN KEY (cur_semestre_clave)
		REFERENCES semestre(sem_clave)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
    
    CONSTRAINT fk_curso_materia
		FOREIGN KEY (cur_materia_clave)
		REFERENCES materia(mat_clave)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
    
    CONSTRAINT fk_curso_maestro
		FOREIGN KEY (cur_maestro_nue)
		REFERENCES maestro(mae_nue)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);


# TABLA REGISTRO

# En este caso elegí una llave artificial para interpretarla como los folios que se suelen asignar en este tipo de 
# procesos, ya que proporcionan un mejor control con las grandes cantidades de información que pueden llegar a contener.

# En las condiciones de ON DELETE y ON UPDATE, la primera la consideré como RESTRICT, debido a que si se quisieran eliminar los
# datos de una inscripción, debería de revisar los registros ya existentes en ella, no se debe permitir ese tipo de eliminación
# de forma directa.
# Con respecto al estudiante, de igual forma que en el caso anterior lo propuse como RESTRICT, ya que de eliminar o darse de baja 
# en todas las demás ligas relacionadas a los cursos, debería de proceder a darse de baja de la inscripción del semestre.

# Crear la tabla registro
CREATE TABLE IF NOT EXISTS registro(
	reg_id INT NOT NULL AUTO_INCREMENT,
	reg_semestre_clave VARCHAR (7) NOT NULL,
    reg_estudiante_nua INT NOT NULL,
    reg_fecha DATE NOT NULL,
    
    PRIMARY KEY (reg_id),
    
    INDEX idx_estudiante (reg_estudiante_nua),
    INDEX idx_inscripcion_estudiante (reg_semestre_clave, reg_estudiante_nua),
    
    UNIQUE uni_inscripcion_estudiante (reg_semestre_clave, reg_estudiante_nua),
    UNIQUE uni_inscripcion_fecha (reg_semestre_clave, reg_fecha),
    
    CONSTRAINT fk_registro_inscripcion
		FOREIGN KEY (reg_semestre_clave)
		REFERENCES inscripcion(ins_semestre_clave)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
        
	CONSTRAINT fk_registro_estudiante
		FOREIGN KEY (reg_estudiante_nua)
		REFERENCES estudiante(est_nua)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);


# TABLA ALTA

# Decidí utilizar una llave primaria artificial al igual que en el caso anterior para contar con un mejor control de la información,
# ya que también podía crearse una llave compuesta por el nua del estudiante y el curso, al no seleccionarlo lo indique como una
# combinación única, además, en este caso, se suelen llegar a realizar demasiadas inserciones, y una llave arfificial es más 
# recomendable para ello.

# En las condiciones de ON DELETE y ON UPDATE, en ambos casos las consideré como RESTRICT, debido a que si un estudiante quisiera darse
# de baja de la escuela, primeramente debería de darse de baja en cada uno de los cursos en los que se dio de alta por cuestiones administrativas,
# tanto de la organización de la escuela, como del control de información de los maestros.
# En cuestión de los cursos, si hay estudiantes dados de alta en cursos específicos, no debería permitirse la eliminación de ellos, para considerar 
# la correcta continuidad escolarizada de los alumnos.
	
# Crear la tabla alta
CREATE TABLE IF NOT EXISTS alta(
	alt_id INT NOT NULL AUTO_INCREMENT,
	alt_estudiante_nua INT NOT NULL,
    alt_curso_id INT NOT NULL,
    alt_promedio DECIMAL (3.1),
    
    PRIMARY KEY (alt_id),
    
    INDEX idx_estudiante (alt_estudiante_nua),
    INDEX idx_curso (alt_curso_id),
    INDEX idx_estudiante_curso (alt_estudiante_nua, alt_curso_id),
    INDEX idx_estudiante_curso_promedio (alt_estudiante_nua, alt_curso_id, alt_promedio),
    
    UNIQUE uni_estudiante_curso (alt_estudiante_nua, alt_curso_id),
    
    CONSTRAINT fk_alta_estudiante
		FOREIGN KEY (alt_estudiante_nua)
		REFERENCES estudiante(est_nua)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
        
	CONSTRAINT fk_alta_curso
		FOREIGN KEY (alt_curso_id)
		REFERENCES curso(cur_id)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);


# TABLA AREA_MATERIA

# Decidí utilizar una llave primaria natural, ya que en este caso no suele contarse con una gran cantidad de registros, con lo 
# cual podemos evitarnos generar un atributo autoincrementable, además de que es más fácil la identificación de los datos de esa manera. 

# Crear la tabla area_materia
CREATE TABLE IF NOT EXISTS area_materia(
	are_abrv VARCHAR (2) NOT NULL,
    are_nombre VARCHAR (25) NOT NULL,
    
    PRIMARY KEY (are_abrv),
    
    UNIQUE area_abrv_nombre (are_abrv, are_nombre)
);
    

# TABLA MALLA

# Para esta tabla preferí adicionar otro atributo que fuera autoincrementable para que fuése la llave primaria, ya que considere
# que dentro de las escuelas que poseen varias sedes, con carreras compartidas, pueden existir variaciones con las materias que
# se integran, por lo cual sería necesario contar con varias mallas aunque sea la misma carrera.
# También en los casos en que se actualiza la carga de materias para próximas generaciones, sería necesario generar una nueva malla,
# ya que los alumnos que ingresaron con esa planeación no se les debería modificar.

# En las condiciones de ON DELETE y ON UPDATE, en los primeros dos casos las consideré como CASCADE, debido a que si se eliminará alguna 
# de las carreras después de pasar los otros 'filtros', si se debería permitir la eliminación automática de los registros relacionados a ella,
# ya que en este caso solamente es la clasificación en la que pueden entrar, y de esta pueden ser varias.
# Con respecto a la materia consideré las mismas condicionantes practicamente, ya que una vez que se permitiese eliminar la carrera, en este caso
# ya no sería importante contar con ese registro.
# Con respecto al área en que se identifica la carrera la consideré como RESTRICT, ya que los registros que cuenten con la clasificación que se
# desea eliminar deberían revisarse antes, generalmente no se debería de realizar este proceso, posiblemente sólo deberían actualizarse.

# Crear la tabla malla
CREATE TABLE IF NOT EXISTS malla(
	mall_id INT NOT NULL AUTO_INCREMENT,
    mall_materia_clave VARCHAR (9) NOT NULL,
    mall_carrera_id INT NOT NULL,
    mall_area_abrv VARCHAR (2) NOT NULL,
    
    PRIMARY KEY (mall_id),
    
    INDEX idx_abrv (mall_area_abrv),
    
    UNIQUE uni_materia_area (mall_materia_clave, mall_area_abrv),
    
    CONSTRAINT fk_malla_carrera
		FOREIGN KEY (mall_carrera_id)
		REFERENCES carrera(car_id)
		
		ON DELETE CASCADE
		ON UPDATE CASCADE,
        
    CONSTRAINT fk_malla_materia
		FOREIGN KEY (mall_materia_clave)
		REFERENCES materia(mat_clave)
		
		ON DELETE CASCADE
		ON UPDATE CASCADE,
        
	CONSTRAINT fk_malla_area
		FOREIGN KEY (mall_area_abrv)
		REFERENCES area_materia(are_abrv)
		
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
);


# 2. LENGUAJE DE MAIPULACIÓN DE DATOS

# 1. Insert at least 10 records of data in each table.

INSERT INTO maestro ( mae_nombre, mae_ap_paterno, mae_ap_materno, mae_correo, mae_titulo, mae_nombramiento)
	VALUES ('Juan Carlos', 'Gómez', 'Carranza', 'jc.gomezcarranza@ugto.mx', 'Doctorado en Informática', 'Tiempo Completo'),
		   ('Mario Alberto', 'Ibarra', 'Manzano', 'ma.ibarramanzano@ugto.mx', 'Doctorado en Microelectrónica y Microsistemas', 'Tiempo Completo'),
           ('Fernando Enrique', 'Correa', 'Tome', 'fe.correatome@ugto.mx', 'Doctorado en Ingeniería Eléctrica', 'Tiempo Completo'),
           ('José Luis', 'Luviano', 'Ortíz', 'j.luvianoortiz@ugto.mx', 'Doctorado en Ingeniería Mecánica', 'Tiempo Completo'),
           ('Raúl Enrique', 'Sanchéz', 'Yañez', 're.sanchezyañez@ugto.mx', 'Ingeniero en Fisica', 'Tiempo Completo'),
           ('José Luis', 'Contreras', 'Hernández', 'jl.contrerashernandez@ugto.mx', 'Doctorado en Ingeniería Eléctrica', 'Tiempo Completo'),
           ('Brenda', 'Gómez', 'Villanueva', 'b.gomezvillanueva@ugto.mx', 'Licenciatura en Diseño Gráfico y Animación', 'Tiempo Completo'),
           ('Saskia', 'Van', 'Amerongen', 's.vanamerongen@ugto.mx', 'Doctorado en Lingüística', 'Tiempo Completo'),
           ('Pedro José', 'Albertos', 'Alpuche', 'pj.albertosalpuche@ugto.mx', 'Doctorado en Veterinaria', 'Tiempo Completo'),
           ('Fernando', 'Contreras', 'Zavala', 'f.contreraszavala@ugto.mx', 'Doctorado en Ciencias de la Salud', 'Tiempo Completo');

INSERT INTO division (div_abrv, div_nombre, div_campus, div_sede)
	VALUES ('DICIS', 'División de Ingenierías', 'Irapuato-Salamanca', 'Salamanca'),
		   ('DICIVA', 'División de Ciencias de la Vida', 'Irapuato-Salamanca', 'Irapuato'),
           ('DCSH', 'División de Ciencias Sociales y Humanidades', 'Guanajuato', 'Guanajuato'),
		   ('DICS', 'División de Ciencias de la Salud', 'León', 'León'),
           ('DCEA', 'División de Ciencias Económico Administrativas', 'Guanajuato', 'Guanajuato'),
		   ('DCNE', 'División de Ciencias Naturales y Exactas', 'Guanajuato', 'Guanajuato'),
		   ('DDPG', 'División De Derecho, Política Y Gobierno', 'Guanajuato', 'Guanajuato'),
		   ('DAAD', 'División de Arquitectura, Arte y Diseño', 'Guanajuato', 'Guanajuato'),
           ('DCSI', 'División de Ciencias de la Salud e Ingenierías', 'Celaya-Salvatierra', 'Salvatierra'),
		   ('DCI', 'División de Ciencias e Ingenierías', 'León', 'León');

INSERT INTO carrera (car_iniciales, car_nombre, car_division_abrv)
	VALUES ('LISC', 'Licenciatura en Ingeniería en Sistemas Computacionales', 'DICIS'),
           ('LIE', 'Licenciatura en Ingeniería Eléctrica', 'DICIS'),
           ('LIMT', 'Licenciatura en Ingeniería en Mecatronica','DICIS'),
           ('LIME', 'Licenciatura en Ingeniería en Mecánica', 'DICIS'),
		   ('LICE', 'Licenciatura en Ingeniería en Comunicaciones y Electrónica', 'DICIS'),
           ('LIDIA', 'Licenciatura en Ingeniería en Datos e Ingeniería Artifícial', 'DICIS'),
           ('LAD', 'Licenciatura en Ingeniería en Artes Digitales', 'DICIS'),
           ('LGE', 'Licenciatura en Gestión Empresarial', 'DICIS'),
           ('LMVZ', 'Licenciatura en Médico Veterinaria y Zootecnia', 'DICIVA'),
           ('LEO', 'Licenciatura en Enfermería y Obstetrícia', 'DICIVA');
           
INSERT INTO materia (mat_clave, mat_nombre, mat_creditos, mat_horas, mat_descripcion)
	VALUES ('IILI06119', 'Sistemas de Administración de Datos', 6, 4, ''),
		   ('NELI04011', 'Métodos Númericos', 4, 3, ''),
           ('IILI06127', 'Sistemas Operativos', 6, 4, ''),
           ('SHLI03019', 'Mecánica de fluidos', 6, 4, ''),
           ('IILI06053', 'Electrónica Digital', 3, 2, ''),
           ('SHLI03020', 'Señales y Sistemas', 4, 4, ''),
           ('SHLI03129', 'Fundamentos del Diseño y Objetos Vectoriales', 6, 4, ''),
           ('SHLI03055', 'Formación Cultural e Intercultural', 3, 2, ''),
           ('SHLI03211', 'Zootecnia General', 6, 4, ''),
           ('SHLI03210', 'Obstetricia', 6, 4, '');

INSERT INTO semestre (sem_clave, sem_nombre)
	VALUES ('2019EJ', 'Semestre Enero-Junio 2019'),
		   ('2019AD', 'Semestre Agosto-Diciembre 2019'),
           ('2020EJ', 'Semestre Enero-Junio 2020'),
		   ('2020AD', 'Semestre Agosto-Diciembre 2020'),
           ('2021EJ', 'Semestre Enero-Junio 2021'),
		   ('2021AD', 'Semestre Agosto-Diciembre 2021'),
           ('2022EJ', 'Semestre Enero-Junio 2022'),
		   ('2022AD', 'Semestre Agosto-Diciembre 2022'),
           ('2023EJ', 'Semestre Enero-Junio 2023'),
		   ('2023AD', 'Semestre Agosto-Diciembre 2023');
    
INSERT INTO estudiante (est_nombre, est_ap_paterno, est_ap_materno, est_correo, est_promedio, est_semestre, est_carrera_id, est_telefono )
	VALUES ('Keyla Leilani', 'Anguiano', 'Cabrera', 'kl.anguianocabrera@ugto.mx', 9.3, 1, 1, 4622650412),
		   ('Jean David', 'García', 'Jaime', 'jd.garciajaime@ugto.mx', 8.9, 2, 2, 4621136579),
		   ('Fernando', 'Romero', 'Torres', 'f.romerotorres@ugto.mx', 9.3, 3, 3, 4641080308),
		   ('Jonathan Esaú', 'Arriaga', 'Saldaña', 'je.arriagasaldaña@ugto.mx', 8.5, 4, 4, 4641917579),
           ('Diego', 'Díaz', 'Segovia', 'd.diazsegovia@ugto.mx', 9.0, 5, 5, 4621924779),
		   ('María Guadalupe', 'Prieto', 'Pantoja', 'mg.prietopantoja@ugto.mx', 9.0, 6, 6, 4641034539),
		   ('Pedro Ángel', 'Lopéz', 'Vargas', 'pa.lopezvargas@ugto.mx', 8.0, 7, 7, 4642295961),
		   ('Erick Armando', 'Lopéz', 'Ramírez', 'ea.lopezramirez@ugto.mx', 8.3, 8, 8, 4623333133),
           ('Jonathan Uriel', 'Pérez', 'Vargas', 'ju.perezvargas@ugto.mx', 8.0, 9, 9, 4771979706),
		   ('Nicholas Andrew', 'Guido', 'Arroyo', 'na.guidoarroyo@ugto.mx', 8.1, 10, 10, 4771503950),
           ('Keyla Leilan', 'Anguian', 'Cabrer', 'kl.anguianocabrera@ugto.m', 9, 1, 1, 462265041),
           ('Jean Davi', 'Garcí', 'Jaim', 'jd.garciajaime@ugto.m', 8, 2, 2, 462113657),
           ('K L', 'A', 'C', 'kl.anguianocabrera@ugto', 1, 1, 1, 46226504),
           ('J D', 'G', 'J', 'jd.garciajaime@ugto', 1, 2, 2, 46211365),
           ('K', 'A', 'C', 'kl.anguianocabrera@', 3, 1, 1, 4622654),
           ('J', 'G', 'J', 'jd.garciajaime@', 3, 2, 2, 4621136);
           
INSERT INTO inscripcion (ins_semestre_clave, ins_costo, ins_fecha_inicio, ins_fecha_fin)
	VALUES ('2019EJ', 1550, '2019-01-15', '2019-01-20'),
		   ('2019AD', 1550, '2019-07-15', '2019-07-20'),
           ('2020EJ', 1600, '2020-01-15', '2020-01-20'),
		   ('2020AD', 1600, '2020-07-15', '2020-07-20'),
           ('2021EJ', 1650, '2021-01-15', '2021-01-20'),
		   ('2021AD', 1650, '2021-07-15', '2021-07-20'),
           ('2022EJ', 1700, '2022-01-15', '2022-01-20'),
		   ('2022AD', 1700, '2022-07-15', '2022-07-20'),
           ('2023EJ', 1750, '2023-01-15', '2023-01-20'),
		   ('2023AD', 1750, '2023-07-15', '2023-07-20');
           
           
INSERT INTO curso (cur_semestre_clave, cur_materia_clave, cur_maestro_nue, cur_dias, cur_horario, cur_grupo, cur_salon)
	VALUES ('2019EJ', 'IILI06119', 000001, 'Mar-Vie', '10:00-12:00', 'A', 'Aula 310'),
		   ('2019AD', 'NELI04011', 000002, 'Mie', '08:00-11:00', 'A', 'Aula 309'),
           ('2020EJ', 'IILI06127', 000003, 'Lun-Jue', '10:00-12:00', 'B', 'Lab A'),
		   ('2020AD', 'SHLI03019', 000004, 'Mar-Vie', '10:00-12:00', 'B', 'Lab B'),
           ('2021EJ', 'IILI06053', 000005, 'Lun-Jue', '14:00-16:00', 'C', 'Aula 303'),
		   ('2021AD', 'SHLI03020', 000006, 'Lun-Mie-Jue', '12:00-14:00','C', 'Aula 210'),
           ('2022EJ', 'SHLI03129', 000007, 'Lun-Jue', '14:00-16:00', 'D', 'Aula 101'),
		   ('2022AD', 'SHLI03055', 000008, 'Mie', '10:00-12:00', 'D', 'Aula 309'),
           ('2023EJ', 'SHLI03211', 000009, 'Lun-Jue', '12:00-14:00', 'A', 'Aula 201'),
		   ('2023AD', 'SHLI03210', 000010, 'Mar-Vie', '08:00-10:00', 'A', 'Aula 305'),
           ('2022EJ', 'SHLI03211', 000009, 'Lun-Jue', '12:00-14:00', 'A', 'Aula 201'),
		   ('2022AD', 'SHLI03210', 000010, 'Mar', '08:00-10:00', 'A', 'Aula 305');
           
INSERT INTO registro (reg_semestre_clave, reg_estudiante_nua, reg_fecha)
	VALUES ('2019EJ', 1, '2019-01-15'),
		   ('2019AD', 2, '2019-07-15'),
           ('2020EJ', 3, '2020-01-16'),
		   ('2020AD', 4, '2020-07-16'),
           ('2021EJ', 5, '2021-01-17'),
		   ('2021AD', 6, '2021-07-17'),
           ('2022EJ', 7, '2022-01-18'),
		   ('2022AD', 8, '2022-07-18'),
           ('2023EJ', 9, '2023-01-19'),
		   ('2023AD', 10, '2023-07-19'),
           ('2022EJ', 9, '2022-01-19'),
		   ('2022AD', 10, '2022-07-19');
           
INSERT INTO alta (alt_estudiante_nua, alt_curso_id, alt_promedio)
	VALUES (1, 1, 10),
		   (2, 2, 10),
           (3, 3, 9.5),
           (4, 4, 9.5),
           (5, 5, 9),
           (6, 6, 9),
           (7, 7, 8.5),
           (8, 8, 8.5),
           (9, 9, 8),
           (10, 10, 8),
           (9, 7, 3),
           (10, 8, 3),
           (11, 1, 5),
		   (12, 2, 5),
           (13, 1, 1),
		   (14, 2, 1),
           (13, 11, 1),
		   (14, 12, 1),
		   (7, 12, 1),
		   (6, 12, 1);

INSERT INTO area_materia (are_abrv, are_nombre)
	VALUES('AB', 'Área Básica Básica'),
		  ('AD', 'Área Básica Disciplinar'),
          ('AP', 'Área de Profundización'),
          ('AG', 'Área Gneral'),
          ('AC', 'Área Complementaria');

    
INSERT INTO malla (mall_materia_clave, mall_carrera_id, mall_area_abrv)
	VALUES ('IILI06119', 1, 'AD'),
		   ('NELI04011', 2, 'AB'),
		   ('IILI06127', 3, 'AD'),
		   ('SHLI03019', 4, 'AD'),
		   ('IILI06053', 5, 'AD'),
		   ('SHLI03020', 6, 'AD'),
		   ('SHLI03129', 7, 'AD'),
		   ('SHLI03055', 8, 'AG'),
		   ('SHLI03211', 9, 'AD'),
		   ('SHLI03210', 10, 'AP');
           
           
# 2. Add +1 to the semester of students of licenciatura eningeniería en sistemas computacionales(use  only  the identificador  
# de  la  carrerato  identify  the carrera, do not cross with the table carrera);that are in semesters 1 or 3, or between 8 and 11;
# whose promediogeneralis 6, 8 o 9;and one of the two things occurs: his/her apellido paternocontains any of the following strings: 
# ‘na’, ‘tr’ or ‘ez’or his/her apellido materno contains any  of  the  following strings: ‘tr’, ‘lr’ or ‘pl’.
UPDATE estudiante
	SET est_semestre = est_semestre + 1
    WHERE est_carrera_id = 1
		AND ((est_semestre = 1 OR est_semestre = 3) OR  (est_semestre BETWEEN 8 AND 11))
        AND est_promedio IN (6, 8, 9)
        AND (((est_ap_paterno LIKE '%na%') OR (est_ap_paterno LIKE '%tr%') OR (est_ap_paterno LIKE '%ez%')) OR ((est_ap_materno LIKE '%tr%') OR (est_ap_materno LIKE '%lr%') OR (est_ap_materno LIKE '%pl%')));
        
        
# 3. Return the nombre of the materia, the  concatenation  of  (nombre, apellido paterno, apellido materno)of the maestro, the días de la semana,
# horas de la semana and salon for each cursohe is teaching for each materia, and the nua and the concatenation of(nombre, apellido paterno, apellido materno)
# for  all  the estudiantes in  each curso of each maestro of each materia. Sort the result first by nombre of the materia in ascending order, 
# then by nombre of the maestro in ascending order.
SELECT materia.mat_nombre, CONCAT(maestro.mae_nombre, ' ', maestro.mae_ap_paterno, ' ', maestro.mae_ap_materno) AS nombre_completo_maestro, curso.cur_dias, curso.cur_horario, curso.cur_salon, estudiante.est_nua, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo_estudiante
	FROM materia
    INNER JOIN curso
		ON materia.mat_clave = curso.cur_materia_clave
	INNER JOIN maestro
        ON curso.cur_maestro_nue = maestro.mae_nue
	INNER JOIN alta
		ON curso.cur_id = alta.alt_curso_id
	INNER JOIN estudiante
        ON alta.alt_estudiante_nua = estudiante.est_nua
    ORDER BY materia.mat_nombre ASC, nombre_completo_maestro ASC;

# 4. Return the nombre de carrera, numero de semestre, the number of estudiantes per the combination of(carrera, numero de semestre), 
# and the minimum, the maximum, and the average of promedio general per the combination of (carrera, numero de semestre).   
# Return  only for the combinations of (carrera, numero de semestre) with more than 5 estudiantes. 
# Sort the result first in descending order according to the nombre de carrera in descending order, second by the numero de semestre in asceding order, 
# then by the number of estudiantes in each combination of (numero de semestre, carrera)in ascending order.
SELECT carrera.car_nombre, estudiante.est_semestre, COUNT(*) AS numero_estudiantes, MIN(estudiante.est_promedio) AS promedio_minimo, MAX(estudiante.est_promedio) AS promedio_maximo, AVG(estudiante.est_promedio) AS promedio_promedio
	FROM carrera
    INNER JOIN estudiante
		ON  carrera.car_id = estudiante.est_carrera_id
    GROUP BY carrera.car_nombre, estudiante.est_semestre
    HAVING numero_estudiantes > 5
    ORDER BY carrera.car_nombre DESC, estudiante.est_semestre ASC, numero_estudiantes ASC;
    
    
# 5. Return the concatenation of (nombre, apellido  paterno, apellido materno), the nombre completo of carrera, the numero de semestre, the fecha de
# inscripcion for the current semestre(2023EJ) of each estudiante; the nombre of the materia, the dias de clase, horas de clase, grupo, salon and the 
# concatenation of (nombre, apellido paterno, apellido materno) of the maestro for each curso that each estudiante is taking in the current semestre(2023EJ).
SELECT CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo_estudiante, carrera.car_nombre, estudiante.est_semestre, registro.reg_fecha, materia.mat_nombre, curso.cur_dias, curso.cur_horario, curso.cur_grupo, curso.cur_salon, CONCAT(maestro.mae_nombre, ' ', maestro.mae_ap_paterno, ' ', maestro.mae_ap_materno) AS nombre_completo_maestro
	FROM carrera
    INNER JOIN estudiante
		ON carrera.car_id = estudiante.est_carrera_id
	INNER JOIN registro
		ON estudiante.est_nua = registro.reg_estudiante_nua
	INNER JOIN alta
		ON estudiante.est_nua = alta.alt_estudiante_nua
    INNER JOIN curso
		ON alta.alt_curso_id = curso.cur_id
    INNER JOIN maestro
		ON curso.cur_maestro_nue = maestro.mae_nue
	 INNER JOIN materia
        ON curso.cur_materia_clave = materia.mat_clave
	WHERE registro.reg_semestre_clave = '2023EJ';


# 6.Return all the  attributes  for  each carrera; the nua, the  concatenation  of(nombre, apellido paterno, apellido materno), 
# the promedio general and the numero de semestre for the estudiantes with the highest promedio general and the lowest promedio general for each carrera;
# and all the data of the curso seach one of those estudiantes has taken. Return the corresponding estudiantes, even if they haven’t taken any curso.
SELECT carrera.car_id, carrera.car_iniciales, carrera.car_nombre, carrera.car_division_abrv, estudiante.est_nua, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo_estudiante, estudiante.est_promedio, estudiante.est_semestre, curso.cur_semestre_clave, curso.cur_materia_clave, curso.cur_maestro_nue, curso.cur_dias, curso.cur_horario, curso.cur_salon
	FROM carrera
	INNER JOIN (
		SELECT est_carrera_id, MAX(est_promedio) AS promedio_maximo, MIN(est_promedio) AS promedio_minimo
		FROM estudiante
		GROUP BY est_carrera_id
	) AS promedio 
		ON carrera.car_id = promedio.est_carrera_id
	INNER JOIN estudiante 
		ON carrera.car_id = estudiante.est_carrera_id 
			AND (estudiante.est_promedio = promedio.promedio_maximo OR estudiante.est_promedio = promedio.promedio_minimo)
	LEFT JOIN alta 
		ON estudiante.est_nua = alta.alt_estudiante_nua
	LEFT JOIN curso 
		ON alta.alt_curso_id = curso.cur_id
	ORDER BY carrera.car_id ASC, estudiante.est_nua ASC;


# 7. Return the clave del semestre, the nombre of the materia, the dias de clase, the horas de clase and grupo for each curso; the nua, 
# the concatenation of (nombre, apellido paterno, apellido materno), the numero de semestre, the promedio general, 
# and the nombre completo of the carrera for the estudiantes with the highest promedio general and the lowest promedio general for each curso 
# in two  semesters defined by you(e.g., 2022AD and 2023EJ).The output must be for all the estudiantes but could serve to reproduce
# Table 1if we filter the resultfor onespecificestudiante.
SELECT curso.cur_semestre_clave, materia.mat_nombre, curso.cur_dias, curso.cur_horario, curso.cur_grupo, estudiante.est_nua, CONCAT(estudiante.est_nombre, ' ', estudiante.est_ap_paterno, ' ', estudiante.est_ap_materno) AS nombre_completo_estudiante, estudiante.est_semestre, estudiante.est_promedio, carrera.car_nombre
	FROM curso
	INNER JOIN alta
		ON curso.cur_id = alta.alt_curso_id
	INNER JOIN estudiante 
		ON alta.alt_estudiante_nua = estudiante.est_nua
	INNER JOIN carrera 
		ON estudiante.est_carrera_id = carrera.car_id
	INNER JOIN materia 
		ON curso.cur_materia_clave = materia.mat_clave
	INNER JOIN (
		SELECT curso.cur_id, MAX(estudiante.est_promedio) AS promedio_maximo, MIN(estudiante.est_promedio) AS promedio_minimo
		FROM curso
		  INNER JOIN alta 
			ON curso.cur_id = alta.alt_curso_id
		  INNER JOIN estudiante 
			ON alta.alt_estudiante_nua = estudiante.est_nua
		GROUP BY curso.cur_id
	) AS promedio
		ON curso.cur_id = promedio.cur_id 
			AND (estudiante.est_promedio = promedio.promedio_maximo OR estudiante.est_promedio = promedio.promedio_minimo)
	WHERE curso.cur_semestre_clave IN ('2022AD', '2023AD')
	ORDER BY curso.cur_id ASC, estudiante.est_promedio DESC;