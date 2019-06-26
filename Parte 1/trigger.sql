CREATE OR REPLACE FUNCTION actualizacion_nota() 
RETURNS trigger AS $$
BEGIN
    RAISE NOTICE 'Se actualizo una nota del alumno';
    RETURN NEW;
END ;
$$ LANGUAGE plpgsql;

CREATE TRIGGER modificacion_nota
AFTER UPDATE of nota
ON evaluacion
FOR EACH ROW EXECUTE FUNCTION actualizacion_nota();

  
