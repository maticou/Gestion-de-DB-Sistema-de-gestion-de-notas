CREATE OR REPLACE FUNCTION cursor_verificar_porcentaje(
	IN _id_instancia integer)
RETURNS integer AS $$
DECLARE
	cursor_porcentaje CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = _id_instancia;
	valor RECORD;
BEGIN 
	OPEN cursor_porcentaje;	
	FETCH cursor_porcentaje INTO valor;
	IF (valor.porcentaje_restante = 0) THEN
		RAISE NOTICE 'Se le permite calcular el promedio final';
		RETURN 1;
	ELSE
		RAISE NOTICE 'No puede calcular la nota final porque al curso le faltan evaluaciones. Recuerde que el curso tiene % %% restante', valor.porcentaje_restante;
		RETURN 0;
	END IF;	
END;$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION cursor_verificar_situacion(
	IN _id_instancia integer)
RETURNS integer AS $$
DECLARE
	cursor_promedio CURSOR FOR SELECT nota, exigible
								FROM instancia_evaluacion, evaluacion
								WHERE ref_alumno=_ref_alumno
								AND instancia_evaluacion.ref_instancia_curso=_ref_instancia_curso
								AND ref_evaluacion=codigo;
	valor RECORD;
BEGIN 
	OPEN cursor_promedio;	
	FETCH cursor_promedio INTO valor;
	WHILE (FOUND) LOOP
		IF (valor.exigible = 1) THEN
			IF (valor.nota < 40) THEN
				RAISE NOTICE 'Alumno reprueba por nota inferior a 40 en evaluación exigible';
				RETURN 1;
			ELSE

			END IF;
		ELSE
			RAISE NOTICE 'No puede calcular la nota final porque al curso le faltan evaluaciones. Recuerde que el curso tiene % %% restante', valor.porcentaje_restante;
			RETURN 0;
		END IF;	
		FETCH cursor_promedio INTO valor;
	END LOOP;	
END;$$
LANGUAGE 'plpgsql';