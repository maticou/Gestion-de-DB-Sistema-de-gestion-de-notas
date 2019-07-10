CREATE OR REPLACE FUNCTION actualizar_promedio() 
RETURNS trigger AS $$
DECLARE
	promedio_actual integer default 0;
	nota integer default 0;
	porcentaje integer default 0;
	promedio_nuevo integer default 0;
	_id_curso integer default 0;
BEGIN
	SELECT ref_instancia_curso
	FROM matricula
	WHERE matricula.ref_alumno = OLD.ref_alumno
	AND matricula.ref_instancia_curso = OLD.ref_instancia_curso 
	INTO _id_curso;

	IF ((SELECT cursor_verificar_porcentaje(_id_curso)) = 1) THEN
		SELECT nota_final
		FROM matricula
		WHERE matricula.ref_alumno = OLD.ref_alumno
		AND matricula.ref_instancia_curso = OLD.ref_instancia_curso 
		INTO promedio_actual;

		SELECT instancia_evaluacion.nota
		FROM instancia_evaluacion, evaluacion
		WHERE evaluacion.codigo = OLD.codigo INTO nota
		AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo;

		SELECT evaluacion.porcentaje
		FROM evaluacion
		WHERE evaluacion.codigo = OLD.codigo INTO porcentaje;

		IF(promedio_actual = null) THEN
			promedio_actual:= 0;
		ELSE
		END IF;

		promedio_nuevo := ((nota * porcentaje) / 100) + promedio_actual;
		
	    UPDATE matricula 
		SET nota_final = promedio_nuevo 
	    WHERE ref_alumno = OLD.ref_alumno
	    AND ref_instancia_curso = OLD.ref_instancia_curso;
	     
	    RAISE NOTICE 'Se actualizo una nota del alumno';
	END IF;
    RETURN OLD;
END ;
$$ LANGUAGE plpgsql;

CREATE TRIGGER modificacion_nota
AFTER UPDATE of nota
ON instancia_evaluacion
FOR EACH ROW EXECUTE FUNCTION actualizar_promedio();