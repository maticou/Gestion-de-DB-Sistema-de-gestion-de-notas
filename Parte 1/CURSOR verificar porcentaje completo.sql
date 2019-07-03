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