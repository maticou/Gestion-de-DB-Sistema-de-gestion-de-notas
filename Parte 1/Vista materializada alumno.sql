CREATE OR REPLACE FUNCTION consulta_vista_cursos_inscritos_por_alumno(
	IN _matricula_id integer
	) RETURNS TABLE (
	    id_instancia integer,
		nombre_del_curso varchar(50),
		seccion varchar(2),
		anio integer,
		semestre tipo_semestre,
		nombre_profesor_encargado varchar(50),
		situacion situacion_matricula
	   ) AS $$
BEGIN
	RETURN QUERY 
	SELECT cursos_de_alumno.id_instancia,
	cursos_de_alumno.nombre_del_curso,
	cursos_de_alumno.seccion,
	cursos_de_alumno.anio,
	cursos_de_alumno.semestre,
	cursos_de_alumno.nombre_profesor_encargado,
	cursos_de_alumno.situacion
	FROM cursos_de_alumno
	WHERE cursos_de_alumno.alumno=_matricula_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION creacion_vista_cursos_inscritos_por_alumno(
	) RETURNS void AS $$
BEGIN   
    execute format('CREATE MATERIALIZED VIEW cursos_de_alumno AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS nombre_profesor_encargado,
	matricula.ref_alumno AS alumno,
	matricula.situacion AS situacion
	FROM matricula, instancia_curso, curso
	WHERE matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo
    WITH DATA');
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION refresh_vista_cursos_inscritos_por_alumno(
	) RETURNS TRIGGER AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_alumno;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER actualizar_vista_cursos_inscritos_por_alumno
AFTER INSERT OR UPDATE OR DELETE ON matricula
FOR EACH ROW EXECUTE FUNCTION refresh_vista_cursos_inscritos_por_alumno()
