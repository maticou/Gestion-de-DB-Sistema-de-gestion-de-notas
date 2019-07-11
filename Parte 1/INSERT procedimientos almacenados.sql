--*************************INSERT***************

CREATE OR REPLACE PROCEDURE agregar_alumno(
	IN _matricula integer,
	IN _rut VARCHAR(12),
	IN _nombre VARCHAR(50),
	IN _apellido_paterno VARCHAR(50),
	IN _apellido_materno VARCHAR(50),
	IN _correo VARCHAR(50),
	IN _telefono VARCHAR(15)
) AS $$
BEGIN
  INSERT INTO alumno (matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo,telefono) 
  VALUES (_matricula, _rut, _nombre, _apellido_paterno, _apellido_materno, _correo, _telefono);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE registrar_profesor(
	IN _rut VARCHAR(12),
	IN _nombre VARCHAR(50),
	IN _apellido VARCHAR(50),
	IN _correo VARCHAR(50),
	IN _telefono VARCHAR(15)
) AS $$
BEGIN
  INSERT INTO profesor (rut, nombre, apellido, correo, telefono) 
  VALUES (_rut, _nombre, _apellido, _correo, _telefono);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE agregar_curso(
	IN _nombre VARCHAR(50),
	IN _carrera VARCHAR(50),
	IN _ref_profesor_encargado varchar(12)
) AS $$
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor_encargado) = 1) THEN
	  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
	  	VALUES (_nombre, _carrera, _ref_profesor_encargado);
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE agregar_curso(
	IN _nombre VARCHAR(50),
	IN _ref_profesor_encargado varchar(12)
) AS $$
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor_encargado) = 1) THEN
	  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
		VALUES (_nombre, 'COMUN', _ref_profesor_encargado);
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;  	
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verificar_existe_profesor_encargado(
	IN _codigo integer
) RETURNS INTEGER AS $$
DECLARE
	existe integer default 0;
BEGIN
    SELECT COUNT(ref_profesor_encargado)
	FROM curso
	WHERE curso.codigo=_codigo INTO existe;
	
	IF (existe = 1) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE agregar_instancia(
	IN _periodo integer,
	IN _seccion VARCHAR(2),
	IN _ref_profesor VARCHAR(12),
	IN _ref_curso integer,
	IN _anio integer,
	IN _semestre tipo_semestre
) AS $$
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor) = 1) THEN
		IF (SELECT verificar_existe_profesor_encargado(_ref_curso) = 1) THEN
			IF ((SELECT COUNT(id) FROM instancia_curso WHERE periodo=_periodo AND seccion=_seccion AND ref_curso=_ref_curso AND anio=_anio AND semestre=_semestre) = 0) THEN
				INSERT INTO instancia_curso(periodo, seccion, ref_profesor, ref_curso, anio, semestre) 
		    	VALUES (_periodo, _seccion, _ref_profesor, _ref_curso, _anio, _semestre);
				RAISE NOTICE 'Instancia curso creada exitosamente';
			ELSE
				RAISE NOTICE 'No se pudo crear la instancia del curso porque ya existe';
			END IF;
			
		ELSE
			RAISE NOTICE 'No se pudo crear la instancia del curso porque el curso base no tiene profesor encargado';
		END IF;  
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;  
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE inscribir_curso(	
	IN _ref_alumno integer,
	IN _ref_curso integer
) AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	IF(alumno_habilitado(_ref_alumno) = 1) THEN
		IF(num_alumnos < 40) THEN
		    INSERT INTO matricula(ref_alumno, ref_instancia_curso, nota_final) 
		    VALUES (_ref_alumno, _ref_curso, 0);

			RAISE NOTICE 'El alumno se ha inscrito correctamente en la seccion';
		ELSE
			RAISE NOTICE 'No quedan cupos disponibles en la seccion';
		END IF;
	ELSE
		RAISE NOTICE 'El alumno no esta habilitado para inscribirse en cursos';
	END IF;	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE crear_evaluacion(
	IN _fecha date,
	IN _porcentaje integer,
	IN _exigible integer,
	IN _area area_evaluacion,
	IN _tipo tipo_evaluacion,
	IN _prorroga VARCHAR(255),
	IN _ref_profesor VARCHAR(12),
	IN _ref_instancia_curso integer
) AS $$
DECLARE
	cursor_porcentaje CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = _ref_instancia_curso;
	valor RECORD; 
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor) = 1) THEN
		IF (_porcentaje>0 AND _porcentaje<101) THEN
			OPEN cursor_porcentaje;	
			FETCH cursor_porcentaje INTO valor;
			IF (valor.porcentaje_restante >= _porcentaje) THEN
				INSERT INTO evaluacion(fecha, porcentaje, exigible, area, tipo, prorroga, ref_profesor,ref_instancia_curso) 
				VALUES (_fecha, _porcentaje, _exigible, _area, _tipo, _prorroga, _ref_profesor, _ref_instancia_curso);
				RAISE NOTICE 'La evaluación fue registrada correctamente';
			ELSE
				RAISE NOTICE 'No puede crear esta evaluación con porcentaje %, ya que al curso le queda % %% restante', _porcentaje, valor.porcentaje_restante;
			END IF;		
		ELSE
			RAISE NOTICE 'No se registró la evaluación porque el porcentaje no está en el rango [1,100]';		
		END IF;	
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;    
END;
$$ LANGUAGE plpgsql;

--NO SE USAN DIRECTAMENTE, UN PROCEDIMIENTO O FUNCION LOS USAN
CREATE OR REPLACE PROCEDURE crear_instancia_evaluacion(
	IN _ref_alumno integer,
	IN _ref_evaluacion bigint,
	IN _ref_instancia_curso integer
) AS $$ 
BEGIN
	INSERT INTO instancia_evaluacion(ref_alumno, ref_evaluacion, ref_instancia_curso) 
	VALUES (_ref_alumno, _ref_evaluacion, _ref_instancia_curso);
	RAISE NOTICE 'La instancia evaluación fue registrada correctamente';    
END;
$$ LANGUAGE plpgsql;

