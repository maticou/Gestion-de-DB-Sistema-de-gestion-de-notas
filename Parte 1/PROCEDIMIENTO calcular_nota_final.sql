CREATE OR REPLACE PROCEDURE calcular_nota_final(id_alumno integer,
id_instancia_curso integer)
LANGUAGE plpgsql
AS $$
DECLARE
	promedio_final INTEGER default 0;
	id_curso INTEGER default 0;
	valor_verificar_situacion INTEGER default 0;
BEGIN
	IF ((SELECT cursor_verificar_porcentaje(id_instancia_curso)) = 1) THEN	
		IF (SELECT verificar_instancia_evaluacion(id_instancia_curso, id_alumno)) THEN						
			SELECT SUM(T2.nota) AS Promedio_final
			FROM (SELECT ((T1.evaluacion * T1.porcentaje)/100) AS nota
				FROM (
					SELECT matricula_id AS matricula_alumno, 
					alumno.nombre AS alumno, curso.nombre AS curso, 
					seccion, nota AS evaluacion, porcentaje
					FROM alumno, instancia_curso, evaluacion, curso, instancia_evaluacion
					WHERE alumno.matricula_id=id_alumno			
					AND instancia_curso.id=id_instancia_curso			
					AND alumno.matricula_id=instancia_evaluacion.ref_alumno
					AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo
					AND evaluacion.ref_instancia_curso=instancia_curso.id
					AND instancia_curso.ref_curso=curso.codigo) AS T1) AS T2 INTO promedio_final;				

			IF (promedio_final > 39) THEN
				SELECT cursor_verificar_situacion(
					id_alumno,id_instancia_curso) INTO valor_verificar_situacion;
				IF (valor_verificar_situacion = 1) THEN
					UPDATE matricula
					SET nota_final=39, situacion='REPROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_instancia_curso;
					RAISE NOTICE 'Alumno reprobado porque una evaluación exigible tiene nota menor a 40, se le modifica el promedio a nota 39';
				ELSE
					UPDATE matricula
					SET nota_final=promedio_final, situacion='APROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_instancia_curso;
					RAISE NOTICE 'Alumno aprobado con nota %', promedio_final;
				END IF;
			ELSE
				UPDATE matricula
				SET nota_final=promedio_final, situacion='REPROBADO'
				WHERE matricula.ref_alumno=id_alumno 
				AND matricula.ref_instancia_curso=id_instancia_curso;
				RAISE NOTICE 'Alumno reprobado con promedio %', promedio_final;
			END IF;			
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
	FROM evaluacion, instancia_curso, instancia_evaluacion
	WHERE instancia_curso.id=evaluacion.ref_instancia_curso
	AND instancia_evaluacion.ref_alumno=_id_alumno
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








	
	
	