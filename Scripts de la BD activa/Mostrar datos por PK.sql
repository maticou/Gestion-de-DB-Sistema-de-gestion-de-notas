CREATE OR REPLACE FUNCTION mostrar_alumno_por_pk(
	IN _matricula_id integer
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
	FROM alumno
	WHERE alumno.matricula_id=_matricula_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_profesor_por_pk(
	IN _rut varchar(12)
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
	FROM profesor
	WHERE profesor.rut=_rut;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_curso_por_pk(
	IN _codigo integer
	) RETURNS TABLE (
 	   codigo_curso integer,
	   nombre_curso varchar(50),
	   carrera_curso varchar(50),
	   profesor_encargado varchar(12)
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	curso.ref_profesor_encargado AS profesor_encargado
	FROM curso
	WHERE curso.codigo=_codigo;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_instancia_curso_por_pk(
	IN _id integer
	) RETURNS TABLE (
 	    id integer,
		periodo integer,
		seccion varchar(2),
		anio integer,
		semestre tipo_semestre,
		ref_profesor varchar(12),
		ref_curso integer,
		porcentaje_restante integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_curso.id AS id,
		instancia_curso.periodo AS periodo,
		instancia_curso.seccion AS seccion,
		instancia_curso.anio AS anio,
		instancia_curso.semestre AS semestre,
		instancia_curso.ref_profesor AS ref_profesor,
		instancia_curso.ref_curso AS ref_curso,
		instancia_curso.porcentaje_restante AS porcentaje_restante
	FROM instancia_curso
	WHERE instancia_curso.id=_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_matricula_por_pk(
	IN _codigo_matricula integer
	) RETURNS TABLE (
 	    codigo_matricula integer,
		nota_final integer,
		ref_alumno integer,
		ref_instancia_curso integer,
		situacion situacion_matricula
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT matricula.codigo_matricula AS codigo_matricula,
		matricula.nota_final AS nota_final,
		matricula.ref_alumno AS ref_alumno,
		matricula.ref_instancia_curso AS ref_instancia_curso,
		matricula.situacion AS situacion
	FROM matricula
	WHERE matricula.codigo_matricula=_codigo_matricula;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_evaluacion_por_pk(
	IN _codigo bigint
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
	FROM evaluacion
	WHERE evaluacion.codigo=_codigo;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION mostrar_instancia_evaluacion_por_pk(
	IN _codigo_intancia_evaluacion bigint
	) RETURNS TABLE (
 	    codigo_intancia_evaluacion bigint,
		ref_alumno integer,
		ref_evaluacion bigint,
		nota integer,
		ref_instancia_curso integer
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_evaluacion.codigo_intancia_evaluacion AS codigo_intancia_evaluacion,
		instancia_evaluacion.ref_alumno AS ref_alumno,
		instancia_evaluacion.ref_evaluacion AS ref_evaluacion,
		instancia_evaluacion.nota AS nota,
		instancia_evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM instancia_evaluacion
	WHERE instancia_evaluacion.codigo_intancia_evaluacion=_codigo_intancia_evaluacion;
END;
$$ LANGUAGE plpgsql;