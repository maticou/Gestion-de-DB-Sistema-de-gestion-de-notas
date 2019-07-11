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


CREATE OR REPLACE FUNCTION reporte_porcentaje_aprovado_y_reprovado_de_una_seccion(
	IN _id_instancia integer
) RETURNS INTEGER AS $$
DECLARE
	nombre_curso varchar(50) default 0;
	seccion_curso varchar(2) default 0;
	alumnos_aprobados INTEGER default 0;
	alumnos_reprobados INTEGER default 0;
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

	RAISE NOTICE 'El porcentaje de alumnos aprovados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_aprobados*100)/(alumnos_aprobados+alumnos_reprobados));
	RAISE NOTICE 'El porcentaje de alumnos reprovados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_reprobados*100)/(alumnos_aprobados+alumnos_reprobados));
	RETURN (alumnos_aprobados+alumnos_reprobados);
END;
$$ LANGUAGE plpgsql;