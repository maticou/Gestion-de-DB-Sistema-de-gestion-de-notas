CREATE OR REPLACE PROCEDURE calcular_nota_final(id_alumno integer,
 nombre_curso varchar(50), periodo_curso integer)
LANGUAGE plpgsql
AS $$
DECLARE
	promedio_final INTEGER default 0;
	id_curso INTEGER default 0;
BEGIN
	SELECT DISTINCT instancia_curso.id
	FROM alumno, instancia_curso, evaluacion, curso
	WHERE alumno.matricula_id=evaluacion.ref_alumno		
	AND alumno.matricula_id=evaluacion.ref_alumno 
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo 
	AND curso.nombre=nombre_curso		
	AND instancia_curso.periodo=periodo_curso
	AND alumno.matricula_id=id_alumno INTO id_curso;

	IF ((SELECT cursor_verificar_porcentaje(id_curso)) = 1) THEN	
		IF (SELECT verificar_instancia_evaluacion(id_curso, id_alumno)) THEN						
			SELECT SUM(T2.nota) AS Promedio_final
			FROM (SELECT ((T1.evaluacion * T1.porcentaje)/100) AS nota
				FROM (
					SELECT matricula_id AS matricula_alumno, 
					alumno.nombre AS alumno, curso.nombre AS curso, 
					seccion, nota AS evaluacion, porcentaje
					FROM alumno, instancia_curso, evaluacion, curso
					WHERE alumno.matricula_id=id_alumno
					AND curso.nombre=nombre_curso			
					AND instancia_curso.periodo=periodo_curso			
					AND alumno.matricula_id=evaluacion.ref_alumno 
					AND evaluacion.ref_instancia_curso=instancia_curso.id
					AND instancia_curso.ref_curso=curso.codigo) AS T1) AS T2 INTO promedio_final;				

			UPDATE matricula
			SET nota_final=promedio_final
			WHERE matricula.ref_alumno=id_alumno 
			AND matricula.ref_instancia_curso=id_curso;
		ELSE
			RAISE NOTICE 'No hay evaluaciones en el curso';		
		END IF;	
	END IF;	
END;
$$;


CREATE OR REPLACE FUNCTION verificar_instancia_evaluacion(
	IN _id_instancia integer,
	IN _id_alumno integer
) RETURNS INTEGER AS $$
DECLARE
	cantidad_evaluaciones INTEGER default 0;
	_rec record;
BEGIN
    SELECT COUNT(evaluacion.codigo)
	FROM evaluacion, instancia_curso
	WHERE instancia_curso.id=evaluacion.ref_instancia_curso
	AND evaluacion.ref_alumno=_id_alumno
	AND instancia_curso.id=_id_instancia INTO cantidad_evaluaciones;
	
	SELECT instancia_curso.id AS codigo, 
	instancia_curso.seccion AS seccion,
	curso.nombre AS curso
	FROM curso, instancia_curso
	WHERE instancia_curso.ref_curso=curso.codigo
	AND instancia_curso.id=_id_instancia INTO _rec;
	
	IF (cantidad_evaluaciones = 0) THEN
		RAISE NOTICE 'No hay evaluaciones en el curso % sección % con código %', _rec.curso, _rec.seccion, _rec.codigo;		
		RETURN 0;
	ELSE
		RAISE NOTICE 'Hay % evaluaciones en el curso % sección % con código %', cantidad_evaluaciones, _rec.curso, _rec.seccion, _rec.codigo;
		RETURN 1;
	END IF;
END;
$$ LANGUAGE plpgsql;








	
	
	