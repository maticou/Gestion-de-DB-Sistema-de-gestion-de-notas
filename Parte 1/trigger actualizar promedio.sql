CREATE TRIGGER modificacion_nota
AFTER UPDATE of nota
ON evaluacion
FOR EACH ROW EXECUTE FUNCTION actualizar_promedio();

CREATE OR REPLACE FUNCTION actualizar_promedio() 
RETURNS trigger AS $$
DECLARE
	promedio_actual integer default 0;
	nota integer default 0;
	porcentaje integer default 0;
	promedio_nuevo integer default 0;
BEGIN
	SELECT nota_final
	FROM matricula
	WHERE matricula.ref_alumno = OLD.ref_alumno
	AND matricula.ref_instancia_curso = OLD.ref_instancia_curso 
	INTO promedio_actual;

	SELECT evaluacion.nota
	FROM evaluacion
	WHERE evaluacion.codigo = OLD.codigo INTO nota;

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
    RETURN OLD;
END ;
$$ LANGUAGE plpgsql;