CREATE OR REPLACE FUNCTION consulta_vista_cursos_inscritos_por_profesor(
	IN _rut varchar(12)
	) RETURNS TABLE (
	    id_instancia integer,
		nombre_del_curso varchar(50),
		seccion varchar(2),
		anio integer,
		semestre tipo_semestre
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT cursos_de_profesor.id_instancia,
	cursos_de_profesor.nombre_del_curso,
	cursos_de_profesor.seccion,
	cursos_de_profesor.anio,
	cursos_de_profesor.semestre
	FROM cursos_de_profesor
	WHERE cursos_de_profesor.profesor=_rut;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creacion_vista_cursos_dados_por_profesor(
	) RETURNS void AS $$
BEGIN   
    execute format('CREATE MATERIALIZED VIEW cursos_de_profesor AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS profesor
	FROM instancia_curso, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
    WITH DATA');
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION refresh_vista_cursos_dados_por_profesor(
	) RETURNS TRIGGER AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_profesor;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER actualizar_vista_cursos_dados_por_profesor
AFTER INSERT OR UPDATE OR DELETE ON instancia_curso
FOR EACH ROW EXECUTE FUNCTION refresh_vista_cursos_dados_por_profesor()