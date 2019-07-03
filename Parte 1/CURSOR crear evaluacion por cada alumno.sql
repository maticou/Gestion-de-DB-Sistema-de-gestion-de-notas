CREATE OR REPLACE FUNCTION cursor_agregar_evaluacion_por_alumno(
	IN _id_instancia integer,
	IN _fecha date,
	IN _porcentaje integer,
	IN _exigible integer,
	IN _area VARCHAR(20),
	IN _tipo VARCHAR(20),
	IN _prorroga VARCHAR(255),
	IN _ref_profesor VARCHAR(12))
RETURNS text AS $$
DECLARE
	cursor_porcentaje CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = _id_instancia;
	reg RECORD;
	valor RECORD;
	cursor_alumnos CURSOR FOR SELECT *
								FROM alumno, matricula
								WHERE alumno.matricula_id=matricula.ref_alumno
								AND ref_instancia_curso=_id_instancia;
BEGIN 
	OPEN cursor_porcentaje;	
	FETCH cursor_porcentaje INTO valor;
	IF (valor.porcentaje_restante >= _porcentaje) THEN
		OPEN cursor_alumnos;	
		FETCH cursor_alumnos INTO reg;
		UPDATE instancia_curso 
		SET porcentaje_restante=(porcentaje_restante-_porcentaje) 
		WHERE instancia_curso.id = reg.ref_instancia_curso;
		WHILE (FOUND) LOOP
			 CALL crear_evaluacion( _fecha, _porcentaje, _exigible,	_area, _tipo, 
				_prorroga, _ref_profesor, reg.matricula_id, reg.ref_instancia_curso);
			FETCH cursor_alumnos INTO reg;
		END LOOP;
	ELSE
			RAISE NOTICE 'No puede crear esta evaluación con porcentaje %, ya que al curso le queda % %% restante', _porcentaje, valor.porcentaje_restante;
	END IF;
	RETURN reg;
END;$$
LANGUAGE 'plpgsql';