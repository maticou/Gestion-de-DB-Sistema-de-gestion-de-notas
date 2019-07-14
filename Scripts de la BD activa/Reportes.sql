CREATE OR REPLACE FUNCTION reporte_promedio_de_una_seccion(
	IN _id_instancia integer
) RETURNS INTEGER AS $$
DECLARE
	nombre_curso varchar(50) default 0;
	seccion_curso varchar(2) default 0;
	promedio_seccion INTEGER default 0;
BEGIN
	SELECT curso.nombre
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO nombre_curso;

	SELECT instancia_curso.seccion
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO seccion_curso;

	SELECT AVG(nota_final)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia INTO promedio_seccion;

	RAISE NOTICE 'El promedio del curso % sección % es %', nombre_curso, seccion_curso, promedio_seccion;
	RETURN promedio_seccion;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_porcentaje_aprobado_y_reprobado_de_una_seccion(
	IN _id_instancia integer
) RETURNS RECORD AS $$
DECLARE
	nombre_curso varchar(50) default 0;
	seccion_curso varchar(2) default 0;
	alumnos_aprobados INTEGER default 0;
	alumnos_reprobados INTEGER default 0;
	rec RECORD;
BEGIN
	SELECT curso.nombre
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO nombre_curso;

	SELECT instancia_curso.seccion
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO seccion_curso;

	SELECT COUNT(situacion)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia
	AND situacion='APROBADO' INTO alumnos_aprobados;

	SELECT COUNT(situacion)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia
	AND situacion='REPROBADO' INTO alumnos_reprobados;
	IF ((alumnos_aprobados+alumnos_reprobados) > 0) THEN		
		SELECT 
		((alumnos_aprobados*100)/(alumnos_aprobados+alumnos_reprobados)) AS alumnos_aprobados,
		((alumnos_reprobados*100)/(alumnos_aprobados+alumnos_reprobados)) AS alumnos_reprobados INTO rec;

		RAISE NOTICE 'El porcentaje de alumnos aprobados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_aprobados*100)/(alumnos_aprobados+alumnos_reprobados));
		RAISE NOTICE 'El porcentaje de alumnos reprobados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_reprobados*100)/(alumnos_aprobados+alumnos_reprobados));
		RETURN rec;
	ELSE
		RAISE NOTICE 'Todavía hay alumnos cursando ramos. Espere a que se cierre el semestre';
		RETURN rec;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_porcentaje_alumnos_que_toman_cursos(
) RETURNS INTEGER AS $$
DECLARE
	numero_alumnos integer default 0;
	numero_matriculados integer default 0;
BEGIN
	SELECT COUNT(alumno.matricula_id)
	FROM alumno INTO numero_alumnos;

	SELECT DISTINCT COUNT(matricula.ref_alumno)
	FROM matricula INTO numero_matriculados;

	IF (numero_alumnos > 0) THEN
		RAISE NOTICE 'El porcentaje de alumnos matriculados es % %%', ((numero_matriculados*100)/(numero_alumnos));	
		RETURN ((numero_matriculados*100)/(numero_alumnos));
	ELSE
		RAISE NOTICE 'No hay alumnos en el sistema';	
		RETURN 0;
	END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION reporte_alumnos_con_mejor_promedio(
	) RETURNS TABLE (
	   matricula_alumno integer,
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   promedio_final bigint
	   ) AS $$
BEGIN
	IF ((SELECT COUNT(T1.cantidad_notas)
		FROM (SELECT COUNT(matricula.nota_final) AS cantidad_notas
			FROM matricula, alumno
			WHERE matricula.ref_alumno=alumno.matricula_id
			GROUP BY (alumno.matricula_id)) AS T1
		WHERE T1.cantidad_notas=0) = 0) THEN
	
		RETURN QUERY 	
		SELECT alumno.matricula_id AS matricula_alumno,
		alumno.nombre AS nombre_alumno,
		alumno.apellido_paterno AS apellido_paterno,
		(SUM(matricula.nota_final)/COUNT(matricula.nota_final)) AS promedio_final
		FROM matricula, alumno
		WHERE matricula.ref_alumno=alumno.matricula_id
		GROUP BY (alumno.matricula_id)
		ORDER BY (promedio_final) DESC;
	ELSE
		RAISE NOTICE 'No se puede generar este reporte porque aún hay alumnos sin todas sus notas finales';
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_alumnos_con_peor_promedio(
	) RETURNS TABLE (
	   matricula_alumno integer,
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   promedio_final bigint
	   ) AS $$
BEGIN
	IF ((SELECT COUNT(T1.cantidad_notas)
		FROM (SELECT COUNT(matricula.nota_final) AS cantidad_notas
			FROM matricula, alumno
			WHERE matricula.ref_alumno=alumno.matricula_id
			GROUP BY (alumno.matricula_id)) AS T1
		WHERE T1.cantidad_notas=0) = 0) THEN
	
		RETURN QUERY 	
		SELECT alumno.matricula_id AS matricula_alumno,
		alumno.nombre AS nombre_alumno,
		alumno.apellido_paterno AS apellido_paterno,
		(SUM(matricula.nota_final)/COUNT(matricula.nota_final)) AS promedio_final
		FROM matricula, alumno
		WHERE matricula.ref_alumno=alumno.matricula_id
		GROUP BY (alumno.matricula_id)
		ORDER BY (promedio_final) ASC;
	ELSE
		RAISE NOTICE 'No se puede generar este reporte porque aún hay alumnos sin todas sus notas finales';
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_alumnos_con_mayor_numero_cursos_reprobados(
	) RETURNS TABLE (
	   matricula_alumno integer,
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   cantidad_cursos_reprobados bigint
	   ) AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.matricula_id AS matricula_alumno,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	COUNT(matricula.situacion) AS cantidad_cursos_reprobados
	FROM matricula, alumno
	WHERE matricula.ref_alumno=alumno.matricula_id
	AND matricula.situacion='REPROBADO'
	GROUP BY (matricula_alumno)
	ORDER BY (cantidad_cursos_reprobados) DESC;	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_alumnos_con_mayor_numero_cursos_aprobados(
	) RETURNS TABLE (
	   matricula_alumno integer,
	   nombre_alumno varchar(50),
	   apellido_paterno varchar(50),
	   cantidad_cursos_aprobados bigint
	   ) AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.matricula_id AS matricula_alumno,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	COUNT(matricula.situacion) AS cantidad_cursos_aprobados
	FROM matricula, alumno
	WHERE matricula.ref_alumno=alumno.matricula_id
	AND matricula.situacion='APROBADO'
	GROUP BY (matricula_alumno)
	ORDER BY (cantidad_cursos_aprobados) DESC;	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_numero_cursos_dictados_por_profesor(
	) RETURNS TABLE (
	   rut varchar(12),
	   nombre_profesor varchar(50),
	   apellido varchar(50),
	   cantidad_cursos_dictados bigint
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(instancia_curso.id) AS cantidad_cursos_dictados
	FROM profesor, instancia_curso
	WHERE profesor.rut=instancia_curso.ref_profesor	
	GROUP BY (profesor.rut)
	ORDER BY profesor.nombre;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_profesores_con_numero_de_reprobados(
	) RETURNS TABLE (
	   rut varchar(12),
	   nombre_profesor varchar(50),
	   apellido varchar(50),
	   cantidad_alumnos_reprobados bigint
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_reprobados
	FROM profesor, instancia_curso, matricula
	WHERE profesor.rut=instancia_curso.ref_profesor	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='REPROBADO'
	GROUP BY (profesor.rut)
	ORDER BY cantidad_alumnos_reprobados DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reporte_profesores_con_numero_de_aprobados(
	) RETURNS TABLE (
	   rut varchar(12),
	   nombre_profesor varchar(50),
	   apellido varchar(50),
	   cantidad_alumnos_aprobados bigint
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_aprobados
	FROM profesor, instancia_curso, matricula
	WHERE profesor.rut=instancia_curso.ref_profesor	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='APROBADO'
	GROUP BY (profesor.rut)
	ORDER BY cantidad_alumnos_aprobados DESC;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION reporte_cursos_con_porcentaje_de_reprobados(
	) RETURNS TABLE (
	   codigo_del_curso integer,
	   nombre_del_curso varchar(50),
	   porcentaje_alumnos_reprobados bigint
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT T1.codigo_curso AS codigo_del_curso,
	T1.nombre_curso AS nombre_del_curso,
	((T1.cantidad_alumnos_reprobados*100)/T2.cantidad_alumnos) AS porcentaje_alumnos_reprobados
	FROM 
	(SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_reprobados
	FROM instancia_curso, matricula, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='REPROBADO'
	GROUP BY (curso.codigo)
	ORDER BY cantidad_alumnos_reprobados DESC) AS T1,  
	(SELECT curso.codigo AS codigo_curso,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos
	FROM instancia_curso, matricula, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
	AND instancia_curso.id=matricula.ref_instancia_curso
	GROUP BY (curso.codigo)
	ORDER BY cantidad_alumnos DESC) AS T2
	WHERE T1.codigo_curso=T2.codigo_curso;
END;
$$ LANGUAGE plpgsql;






