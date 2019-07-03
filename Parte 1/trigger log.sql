CREATE OR REPLACE FUNCTION proceso_agregar_log() 
RETURNS TRIGGER AS $log$
BEGIN 
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla) 
		VALUES ('DELETE', now(), user, TG_TABLE_NAME);
	ELSEIF (TG_OP = 'UPDATE') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla) 
		VALUES ('UPDATE', now(), user, TG_TABLE_NAME);
	ELSEIF (TG_OP = 'INSERT') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla) 
		VALUES ('INSERT', now(), user, TG_TABLE_NAME);
	END IF;
	RETURN NULL;
END;
$log$ LANGUAGE plpgsql;


CREATE TRIGGER agregar_log_alumno
AFTER INSERT OR UPDATE OR DELETE ON alumno
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()

CREATE TRIGGER agregar_log_profesor
AFTER INSERT OR UPDATE OR DELETE ON profesor
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()

CREATE TRIGGER agregar_log_curso
AFTER INSERT OR UPDATE OR DELETE ON curso
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()

CREATE TRIGGER agregar_log_evaluacion
AFTER INSERT OR UPDATE OR DELETE ON evaluacion
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()

CREATE TRIGGER agregar_log_instancia_curso
AFTER INSERT OR UPDATE OR DELETE ON instancia_curso
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()

CREATE TRIGGER agregar_log_matricula
AFTER INSERT OR UPDATE OR DELETE ON matricula
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()
