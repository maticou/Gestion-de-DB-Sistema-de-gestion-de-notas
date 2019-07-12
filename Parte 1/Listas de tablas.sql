CREATE OR REPLACE FUNCTION lista_cursos(
	) RETURNS TABLE (
 	   codigo_curso integer,
	   nombre_curso varchar(50),
	   carrera_curso varchar(50),
	   profesor_rut varchar(12),
	   profesor_nombre varchar(50),
	   profesor_apellido varchar(50)
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	profesor.rut AS profesor_rut,
	profesor.nombre AS profesor_nombre,
	profesor.apellido AS profesor_apellido
	FROM curso, profesor
	WHERE profesor.rut=curso.ref_profesor_encargado;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_alumnos(
	) RETURNS TABLE (
 	   matricula integer,
	   rut varchar(12),
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   apellido_materno varchar(50),
	   correo_alumno varchar(50),
	   telefono_alumno varchar(15),
	   estado_alumno integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.rut AS rut,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	alumno.apellido_materno AS apellido_materno,
	alumno.correo AS correo_alumno,
	alumno.telefono AS telefono_alumno,
	alumno.estado AS estado_alumno
	FROM alumno;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_profesores(
	) RETURNS TABLE (
	   rut varchar(12),
	   nombre_profesor varchar(50),
	   apellido varchar(50),
	   correo_profesor varchar(50),
	   telefono_profesor varchar(15),
	   estado_profesor integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	profesor.correo AS correo_profesor,
	profesor.telefono AS telefono_profesor,
	profesor.estado AS estado_profesor
	FROM profesor;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_curso_con_instancias(
	) RETURNS TABLE (
	   seccion_id integer,
	   nombre_curso varchar(50),
	   seccion varchar(2),
	   periodo integer,
	   anio integer,
	   semestre tipo_semestre,
	   porcentaje_restante integer,
	   profesor_rut varchar(12),
	   nombre_profesor varchar(50),
	   apellido varchar(50)
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_curso.id AS seccion_id,
	curso.nombre AS nombre_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.periodo AS periodo,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	instancia_curso.porcentaje_restante AS porcentaje_restante,
	profesor.rut AS profesor_rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido
	FROM curso, instancia_curso, profesor
	WHERE curso.codigo=instancia_curso.ref_curso
	AND instancia_curso.ref_profesor=profesor.rut;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_evaluaciones_por_instancia_curso(
	IN _id integer
	) RETURNS TABLE (
	    codigo bigint,
		fecha date,
		porcentaje integer,
		exigible integer,
		area area_evaluacion,
		tipo tipo_evaluacion,
		prorroga varchar(255),	
		ref_profesor varchar(12),	
		ref_instancia_curso integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM evaluacion, instancia_curso
	WHERE evaluacion.ref_instancia_curso=instancia_curso.id
	AND evaluacion.ref_instancia_curso=_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_evaluaciones_por_instancia_curso_por_alumno(
	IN _id integer,
	IN _matricula_id integer
	) RETURNS TABLE (
	    codigo bigint,
		fecha date,
		porcentaje integer,
		exigible integer,
		area area_evaluacion,
		tipo tipo_evaluacion,
		prorroga varchar(255),	
		ref_profesor varchar(12),	
		ref_instancia_curso integer,
		nota integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso,
		instancia_evaluacion.nota AS nota
	FROM evaluacion, instancia_curso, matricula, instancia_evaluacion
	WHERE evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.id= _id
	AND evaluacion.ref_instancia_curso=_id
	AND instancia_evaluacion.ref_instancia_curso=_id
	AND matricula.ref_instancia_curso=_id
	AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo
	AND matricula.ref_alumno=_matricula_id
	AND instancia_evaluacion.ref_alumno=_matricula_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lista_alumnos_en_instancia_curso(
	IN _id integer
	) RETURNS TABLE (
 	   matricula integer,
	   rut varchar(12),
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   apellido_materno varchar(50),
	   correo_alumno varchar(50),
	   telefono_alumno varchar(15),
	   estado_alumno integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.rut AS rut,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	alumno.apellido_materno AS apellido_materno,
	alumno.correo AS correo_alumno,
	alumno.telefono AS telefono_alumno,
	alumno.estado AS estado_alumno
	FROM alumno, matricula, instancia_curso
	WHERE alumno.matricula_id=matricula.ref_alumno
	AND matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.id=_id;
END;
$$ LANGUAGE plpgsql;