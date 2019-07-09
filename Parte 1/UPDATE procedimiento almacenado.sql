--*************************UPDATE***************

CREATE OR REPLACE PROCEDURE modificar_alumno(
	IN _matricula integer,
	IN _rut VARCHAR(12),
	IN _nombre VARCHAR(50),
	IN _apellido_paterno VARCHAR(50),
	IN _apellido_materno VARCHAR(50),
	IN _correo VARCHAR(50),
	IN _telefono VARCHAR(15)
) AS $$
BEGIN 
	UPDATE alumno
	SET matricula_id = _matricula,
		rut = _rut,
		nombre = _nombre,
		apellido_paterno = _apellido_paterno,
		apellido_materno = _apellido_materno,
		correo = _correo,
		telefono = _telefono
	WHERE alumno.matricula_id = _matricula;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_profesor(
	IN _rut VARCHAR(12),
	IN _nombre VARCHAR(50),
	IN _apellido VARCHAR(50),
	IN _correo VARCHAR(50),
	IN _telefono VARCHAR(15)
) AS $$
BEGIN 
	UPDATE profesor
	SET rut = _rut,
		nombre = _nombre,
		apellido = _apellido,
		correo = _correo,
		telefono = _telefono
	WHERE profesor.rut = _rut;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_curso(
	IN _codigo integer,
	IN _nombre VARCHAR(50),
	IN _carrera VARCHAR(50),
	IN _ref_profesor_encargado varchar(12)
) AS $$
BEGIN 
	UPDATE curso
	SET nombre = _nombre,
		carrera = _carrera,
		ref_profesor_encargado = _ref_profesor_encargado
	WHERE curso.codigo = _codigo;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_instancia(
	IN _id integer,
	IN _periodo integer,
	IN _seccion VARCHAR(2),
	IN _ref_profesor VARCHAR(12),
	IN _ref_curso integer,
	IN _anio integer,
	IN _semestre tipo_semestre
) AS $$
BEGIN
    UPDATE instancia_curso
	SET periodo = _periodo,
		seccion = _seccion,
		ref_profesor = _ref_profesor,
		ref_curso = _ref_curso,
		anio = _anio,
		semestre = _semestre
	WHERE id = _id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_matricula(
	IN _codigo_matricula integer,	
	IN _ref_alumno integer,
	IN _ref_instancia_curso integer,
	IN _nota_final integer
) AS $$
BEGIN
    UPDATE matricula
	SET nota_final = _nota_final,
		ref_alumno = _ref_alumno,
		ref_instancia_curso = _ref_instancia_curso
	WHERE codigo_matricula = _codigo_matricula;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_evaluacion(
	IN _codigo integer,
	IN _fecha date,
	IN _porcentaje integer,
	IN _exigible integer,
	IN _area VARCHAR(20),
	IN _tipo VARCHAR(20),
	IN _prorroga VARCHAR(255),	
	IN _ref_profesor VARCHAR(12),
	IN _ref_alumno integer,
	IN _ref_instancia_curso integer
) AS $$ 
BEGIN
	IF (_porcentaje>0 AND _porcentaje<101) THEN
		UPDATE evaluacion
		SET fecha = _fecha,
			porcentaje = _porcentaje,
			exigible = _exigible,
			area = _area,
			tipo = _tipo,
			prorroga = _prorroga,
			ref_profesor = _ref_profesor,
			ref_alumno = _ref_alumno,
			ref_instancia_curso = _ref_instancia_curso
		WHERE codigo = _codigo;
		RAISE NOTICE 'La evaluación fue modificada correctamente';
	ELSE
		RAISE NOTICE 'No se modificar la evaluación porque el porcentaje no está en el rango [1,100]';		
	END IF;	    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE modificar_nota(
	IN _nota integer,
	IN _ref_evaluacion integer,
	IN _ref_alumno integer,
	IN _ref_instancia_curso integer
) AS $$
BEGIN
	IF (_nota>9 AND _nota<71) THEN
		UPDATE evaluacion
		SET nota = _nota
		WHERE evaluacion.ref_alumno = _ref_alumno
		AND evaluacion.ref_instancia_curso = _ref_instancia_curso
		AND evaluacion.codigo = _ref_evaluacion;
		RAISE NOTICE 'Se modificó la nota correctamente a %', _nota;
	ELSE
		RAISE NOTICE 'No se pudo modificar la nota porque no está dentro del rango permitido [10,70]';
	END IF;    
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE asignar_profesor_curso(
	_rut_profesor varchar(12),
	_id_instancia integer
) AS $$
BEGIN
	IF(profesor_habilitado(_rut_profesor) = 1) THEN
		UPDATE instancia_curso SET ref_profesor = _rut_profesor
		WHERE instancia_curso.id = _id_instancia;
	ELSE
		RAISE NOTICE 'El profesor no esta habilitado para dictar cursos.';
	END IF;
END;
$$ LANGUAGE plpgsql;


