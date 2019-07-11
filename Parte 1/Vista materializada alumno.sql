CREATE OR REPLACE FUNCTION primera_creacion_vista_cursos_inscritos_por_alumno(
	IN _matricula_id integer
	) RETURNS void AS $$
BEGIN   
    execute format('CREATE MATERIALIZED VIEW cursos_de_alumno AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS nombre_profesor_encargado
	FROM matricula, instancia_curso, curso
	WHERE matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo
	AND matricula.ref_alumno= %L
    WITH DATA',_matricula_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creacion_vista_cursos_inscritos_por_alumno(
	IN _matricula_id integer
	) RETURNS void AS $$
BEGIN   
	DROP MATERIALIZED VIEW cursos_de_alumno;
    execute format('CREATE MATERIALIZED VIEW cursos_de_alumno AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS nombre_profesor_encargado
	FROM matricula, instancia_curso, curso
	WHERE matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo
	AND matricula.ref_alumno= %L
    WITH DATA',_matricula_id);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION refresh_vista_cursos_inscritos_por_alumno(
	) RETURNS void AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_alumno;
END;
$$ LANGUAGE plpgsql;
