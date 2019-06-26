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

--listo!!!!!!!!!!!!!!!!!!!!!!!1
CREATE TRIGGER agregar_log_alumno
AFTER INSERT OR UPDATE OR DELETE ON alumno
FOR EACH ROW EXECUTE FUNCTION proceso_agregar_log()
--listo!!!!!!!!!!!!!!!!!!!!!!!1
