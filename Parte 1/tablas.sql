CREATE TABLE alumno
(
	matricula_id integer NOT NULL,
	rut varchar(12) UNIQUE NOT NULL,
	nombre varchar(50) NOT NULL,
	apellido_paterno varchar(50) NOT NULL,
	apellido_materno varchar(50) NOT NULL,
	correo varchar(50) NOT NULL,
	telefono varchar(15) NOT NULL,
    estado integer DEFAULT 1 NOT NULL,
	PRIMARY KEY (matricula_id)	
);

CREATE TABLE profesor
(	
	rut varchar(12) NOT NULL,
	nombre varchar(50) NOT NULL,
	apellido varchar(50) NOT NULL,	
	correo varchar(50) NOT NULL,
	telefono varchar(15) NOT NULL,
	estado integer DEFAULT 1 NOT NULL,
	PRIMARY KEY (rut)
);

CREATE TABLE curso
(	
	codigo integer NOT NULL GENERATED ALWAYS AS IDENTITY,
	nombre varchar(50) NOT NULL,
	carrera varchar(50) NOT NULL,
	ref_profesor_encargado varchar(12) REFERENCES profesor(rut),	
	PRIMARY KEY (codigo)	
);

CREATE TYPE tipo_semestre AS ENUM ('1', '2');

CREATE TABLE instancia_curso
(
	id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
	periodo integer NOT NULL,
	seccion varchar(2) NOT NULL,
	anio integer NOT NULL,
	semestre tipo_semestre NOT NULL,
	ref_profesor varchar(12) REFERENCES profesor(rut),
	ref_curso integer NOT NULL REFERENCES curso(codigo),
	PRIMARY KEY (id)	
);

CREATE TYPE situacion_matricula AS ENUM ('APROBADO', 'REPROBADO');

CREATE TABLE matricula
(
	codigo_matricula integer NOT NULL GENERATED ALWAYS AS IDENTITY,
	nota_final integer NOT NULL DEFAULT 0,
	ref_alumno integer NOT NULL REFERENCES alumno(matricula_id),
	ref_instancia_curso integer NOT NULL REFERENCES instancia_curso(id),
	situacion situacion_matricula NULL,
	PRIMARY KEY (codigo_matricula)
);

CREATE TABLE evaluacion
(
	codigo bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	fecha date NULL,
	porcentaje integer NOT NULL,
	exigible integer NOT NULL,
	area varchar(20) NOT NULL,
	tipo varchar(20) NOT NULL,
	prorroga varchar(255) NULL,
	nota integer NULL,
	ref_profesor varchar(12) NOT NULL REFERENCES profesor(rut),
	ref_alumno integer NOT NULL REFERENCES alumno(matricula_id),
	ref_instancia_curso integer NOT NULL REFERENCES instancia_curso(id),
	PRIMARY KEY (codigo)
);

CREATE TABLE log
(
	id_log bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	operacion varchar(15) NOT NULL,
	stamp timestamp NOT NULL,
	user_id text NOT NULL,
	nombre_tabla varchar(50) NOT NULL,
	PRIMARY KEY (id_log)
);