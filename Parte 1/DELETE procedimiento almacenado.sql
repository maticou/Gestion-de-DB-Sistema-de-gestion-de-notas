--*************************DELETE***************

CREATE OR REPLACE PROCEDURE deshabilitar_alumno(
	_matricula_id integer
) AS $$
BEGIN 
	UPDATE alumno SET estado=0 WHERE alumno.matricula_id=_matricula_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE deshabilitar_profesor(
	_rut integer
) AS $$
BEGIN 
	UPDATE profesor SET estado=0 WHERE profesor.rut=_rut;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE eliminar_instancia_curso(
	_id_instancia integer
) AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	SELECT numero_alumnos_matriculados(_id_instancia) INTO num_alumnos;

	IF(num_alumnos < 10) THEN 
		DELETE FROM instancia_curso WHERE instancia_curso.id = _id_instancia;
	ELSE
		RAISE NOTICE 'La instancia tiene mas de 10 alumnos, por lo que no se puede eliminar';
	END IF;
END;
$$ LANGUAGE plpgsql;