--*************************SELECT***************

CREATE OR REPLACE FUNCTION notas_alumno_todas(
	IN _matricula integer
) RETURNS TABLE (
 	   matricula integer,
	   nombre varchar(50),
	   apellido_paterno varchar(50),
	   curso varchar(50),
	   seccion varchar(2),
	   tipo_evaluacion varchar(50),
	   nota integer) 
	   AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.nombre AS nombre,
	alumno.apellido_paterno AS apellido_paterno,
	curso.nombre AS curso,
	instancia_curso.seccion AS seccion,
	evaluacion.tipo AS tipo_evaluacion,
	evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion
	WHERE alumno.matricula_id=2013407015
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION notas_alumno_curso(
	IN _matricula integer,
	IN _nombre_curso varchar(50)
) RETURNS TABLE (
 	   matricula integer,
	   nombre varchar(50),
	   apellido_paterno varchar(50),
	   curso varchar(50),
	   seccion varchar(2),
	   tipo_evaluacion varchar(50),
	   nota integer) 
	   AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.nombre AS nombre,
	alumno.apellido_paterno AS apellido_paterno,
	curso.nombre AS curso,
	instancia_curso.seccion AS seccion,
	evaluacion.tipo AS tipo_evaluacion,
	evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion
	WHERE alumno.matricula_id=2013407015
	AND curso.nombre=_nombre_curso
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION numero_alumnos_matriculados(
	IN _id_instancia integer
) RETURNS INTEGER AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	SELECT COUNT(alumno.matricula_id)
	FROM instancia_curso, alumno, matricula
	WHERE instancia_curso.id = matricula.ref_instancia_curso
	AND matricula.ref_alumno = _id_instancia INTO num_alumnos;

	RETURN num_alumnos;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION alumno_habilitado(
	IN _matricula integer
) RETURNS INTEGER AS $$
DECLARE
	estado_alumno INTEGER default 0;
BEGIN
	SELECT alumno.estado
	FROM alumno
	WHERE alumno.matricula_id = _matricula INTO estado_alumno;

	IF(estado_alumno = 1) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION profesor_habilitado(
	IN _rut_profesor varchar(12)
) RETURNS INTEGER AS $$
DECLARE
	estado_profesor INTEGER default 0;
BEGIN
	SELECT profesor.estado
	FROM profesor
	WHERE profesor.rut = _rut_profesor INTO estado_profesor;

	IF(estado_profesor = 1) THEN
		RETURN 1; 
	ELSE
		RETURN 0;
	END IF;
END;
$$ LANGUAGE plpgsql;

