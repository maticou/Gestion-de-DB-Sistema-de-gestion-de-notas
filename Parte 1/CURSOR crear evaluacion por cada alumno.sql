CREATE OR REPLACE FUNCTION cursor_agregar_evaluacion_por_alumno()
RETURNS TRIGGER AS $$
DECLARE
	cursor_porcentaje_a CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = NEW.ref_instancia_curso;
	reg RECORD;
	valor RECORD;
	cursor_alumnos CURSOR FOR SELECT *
								FROM alumno, matricula
								WHERE alumno.matricula_id=matricula.ref_alumno
								AND ref_instancia_curso=NEW.ref_instancia_curso;
BEGIN 
	OPEN cursor_porcentaje_a;	
	FETCH cursor_porcentaje_a INTO valor;
	IF (valor.porcentaje_restante >= NEW.porcentaje) THEN
		OPEN cursor_alumnos;	
		FETCH cursor_alumnos INTO reg;
		UPDATE instancia_curso 
		SET porcentaje_restante=(porcentaje_restante-NEW.porcentaje) 
		WHERE instancia_curso.id = reg.ref_instancia_curso;
		WHILE (FOUND) LOOP
			CALL crear_instancia_evaluacion(reg.matricula_id, NEW.codigo, NEW.ref_instancia_curso);
			FETCH cursor_alumnos INTO reg;
		END LOOP;
	ELSE
			RAISE NOTICE 'No puede crear esta evaluación con porcentaje %, ya que al curso le queda % %% restante', NEW.porcentaje, valor.porcentaje_restante;
	END IF;
	RETURN NEW;
END;$$
LANGUAGE 'plpgsql';

CREATE TRIGGER agregar_evaluacion_por_alumno
AFTER INSERT ON evaluacion
FOR EACH ROW EXECUTE FUNCTION cursor_agregar_evaluacion_por_alumno();


CREATE OR REPLACE FUNCTION cursor_actualizar_evaluacion_por_alumno()
RETURNS TRIGGER AS $$
DECLARE
	cursor_porcentaje_a CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = NEW.ref_instancia_curso;
	reg RECORD;
	valor RECORD;
	cursor_alumnos CURSOR FOR SELECT *
								FROM alumno, matricula
								WHERE alumno.matricula_id=matricula.ref_alumno
								AND ref_instancia_curso=NEW.ref_instancia_curso;
BEGIN 	
	OPEN cursor_porcentaje_a;	
	FETCH cursor_porcentaje_a INTO valor;
	OPEN cursor_alumnos;	
	FETCH cursor_alumnos INTO reg;
	IF (OLD.porcentaje < NEW.porcentaje) THEN	
		IF ((valor.porcentaje_restante-NEW.porcentaje) < 0) THEN
			RAISE NOTICE 'No se puede modificar evaluación con tan alto porcentaje';
		ELSE
			UPDATE instancia_curso 
			SET porcentaje_restante=(valor.porcentaje_restante-NEW.porcentaje) 
			WHERE instancia_curso.id = NEW.ref_instancia_curso;	
			RAISE NOTICE 'Evaluación modificada correctamente';			
		END IF;			
	ELSE
		IF ((valor.porcentaje_restante+(OLD.porcentaje-NEW.porcentaje)) < 101) THEN
			UPDATE instancia_curso 
			SET porcentaje_restante=(valor.porcentaje_restante+(OLD.porcentaje-NEW.porcentaje))
			WHERE instancia_curso.id = NEW.ref_instancia_curso;	
			RAISE NOTICE 'Evaluación modificada correctamente';
		ELSE
			RAISE NOTICE 'No se puede modificar evaluación con tan alto porcentaje';
		END IF;
	END IF;
	RETURN NEW;
END;$$
LANGUAGE 'plpgsql';


CREATE TRIGGER actualizar_evaluacion_por_alumno
AFTER UPDATE ON evaluacion
FOR EACH ROW EXECUTE FUNCTION cursor_actualizar_evaluacion_por_alumno();