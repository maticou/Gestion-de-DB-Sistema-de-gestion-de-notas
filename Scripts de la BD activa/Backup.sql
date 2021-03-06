PGDMP         4                w            registro_notas    11.2    11.2 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    33653    registro_notas    DATABASE     �   CREATE DATABASE registro_notas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE registro_notas;
             postgres    false            �           1247    33655    area_evaluacion    TYPE        CREATE TYPE public.area_evaluacion AS ENUM (
    'UNIDAD_1',
    'UNIDAD_2',
    'UNIDAD_3',
    'UNIDAD_4',
    'UNIDAD_5'
);
 "   DROP TYPE public.area_evaluacion;
       public       postgres    false            �           1247    33666    situacion_matricula    TYPE     d   CREATE TYPE public.situacion_matricula AS ENUM (
    'APROBADO',
    'REPROBADO',
    'CURSANDO'
);
 &   DROP TYPE public.situacion_matricula;
       public       postgres    false            �           1247    33674    tipo_evaluacion    TYPE     �   CREATE TYPE public.tipo_evaluacion AS ENUM (
    'PRUEBA',
    'PROYECTO',
    'LABORATORIO',
    'TAREA',
    'TRABAJOS',
    'INFORME'
);
 "   DROP TYPE public.tipo_evaluacion;
       public       postgres    false            �           1247    33688    tipo_semestre    TYPE     ?   CREATE TYPE public.tipo_semestre AS ENUM (
    '1',
    '2'
);
     DROP TYPE public.tipo_semestre;
       public       postgres    false            �            1255    33693    actualizar_promedio()    FUNCTION     Q  CREATE FUNCTION public.actualizar_promedio() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
		WHERE instancia_evaluacion.ref_evaluacion=evaluacion.codigo INTO nota;

		SELECT evaluacion.porcentaje
		FROM instancia_evaluacion, evaluacion
		WHERE instancia_evaluacion.ref_evaluacion=evaluacion.codigo INTO porcentaje;

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
$$;
 ,   DROP FUNCTION public.actualizar_promedio();
       public       postgres    false            *           1255    33965 �   agregar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     ^  CREATE PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying, _clave character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (_matricula < 2147483000) THEN
		IF (_matricula > 0) THEN
			INSERT INTO alumno (matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo,telefono) 
			VALUES (_matricula, _rut, _nombre, _apellido_paterno, _apellido_materno, _correo, _telefono);

			INSERT INTO alumno_seguridad (contrasena, ref_alumno) 
			VALUES (_clave, _matricula);
		ELSE
			RAISE NOTICE 'El número de la matrícula no puede ser inferior a 1';
		END IF;		
	ELSE
		RAISE NOTICE 'El número de la matrícula no puede superar el valor de 2147483000';
	END IF;	  
END;
$$;
 	  DROP PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying, _clave character varying);
       public       postgres    false            �            1255    33695 3   agregar_curso(character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor_encargado) = 1) THEN
	  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
		VALUES (_nombre, 'COMUN', _ref_profesor_encargado);
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;  	
END;
$$;
 k   DROP PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    33696 F   agregar_curso(character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((SELECT estado FROM profesor WHERE profesor.rut=_ref_profesor_encargado) = 1) THEN
	  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
	  	VALUES (_nombre, _carrera, _ref_profesor_encargado);
	ELSE
		RAISE NOTICE 'El profesor no está disponibles';
	END IF;
END;
$$;
 �   DROP PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    33697 h   agregar_instancia(integer, character varying, character varying, integer, integer, public.tipo_semestre) 	   PROCEDURE     /  CREATE PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre)
    LANGUAGE plpgsql
    AS $$
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
$$;
 �   DROP PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre);
       public       postgres    false    689            �            1255    33698    alumno_habilitado(integer)    FUNCTION     H  CREATE FUNCTION public.alumno_habilitado(_matricula integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	estado_alumno INTEGER default 0;
BEGIN
	SELECT alumno.estado
	FROM alumno
	WHERE alumno.matricula_id = _matricula INTO estado_alumno;

	IF(estado_alumno = 1) THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END;
$$;
 <   DROP FUNCTION public.alumno_habilitado(_matricula integer);
       public       postgres    false            �            1255    33699 2   asignar_profesor_curso(character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.asignar_profesor_curso(_rut_profesor character varying, _id_instancia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(profesor_habilitado(_rut_profesor) = 1) THEN
		UPDATE instancia_curso SET ref_profesor = _rut_profesor
		WHERE instancia_curso.id = _id_instancia;
	ELSE
		RAISE NOTICE 'El profesor no esta habilitado para dictar cursos.';
	END IF;
END;
$$;
 f   DROP PROCEDURE public.asignar_profesor_curso(_rut_profesor character varying, _id_instancia integer);
       public       postgres    false            (           1255    34039 %   calcular_nota_final(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.calcular_nota_final(id_alumno integer, id_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	promedio_final INTEGER default 0;
	id_curso INTEGER default 0;
	valor_verificar_situacion INTEGER default 0;
BEGIN
	IF ((SELECT cursor_verificar_porcentaje(id_instancia_curso)) = 1) THEN	
		IF (SELECT verificar_instancia_evaluacion(id_instancia_curso, id_alumno)) THEN						
			SELECT SUM(T2.nota) AS Promedio_final
			FROM (SELECT ((T1.evaluacion * T1.porcentaje)/100) AS nota
				FROM (
					SELECT matricula_id AS matricula_alumno, 
					alumno.nombre AS alumno, curso.nombre AS curso, 
					seccion, nota AS evaluacion, porcentaje
					FROM alumno, instancia_curso, evaluacion, curso, instancia_evaluacion
					WHERE alumno.matricula_id=id_alumno			
					AND instancia_curso.id=id_instancia_curso			
					AND alumno.matricula_id=instancia_evaluacion.ref_alumno
					AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo
					AND evaluacion.ref_instancia_curso=instancia_curso.id
					AND instancia_curso.ref_curso=curso.codigo) AS T1) AS T2 INTO promedio_final;				

			IF (promedio_final > 39) THEN
				SELECT cursor_verificar_situacion(
					id_alumno,id_instancia_curso) INTO valor_verificar_situacion;
				IF (valor_verificar_situacion = 1) THEN
					UPDATE matricula
					SET nota_final=39, situacion='REPROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_instancia_curso;
					RAISE NOTICE 'Alumno reprobado porque una evaluación exigible tiene nota menor a 40, se le modifica el promedio a nota 39';
				ELSE
					UPDATE matricula
					SET nota_final=promedio_final, situacion='APROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_instancia_curso;
					RAISE NOTICE 'Alumno aprobado con nota %', promedio_final;
				END IF;
			ELSE
				UPDATE matricula
				SET nota_final=promedio_final, situacion='REPROBADO'
				WHERE matricula.ref_alumno=id_alumno 
				AND matricula.ref_instancia_curso=id_instancia_curso;
				RAISE NOTICE 'Alumno reprobado con promedio %', promedio_final;
			END IF;			
		ELSE
			RAISE NOTICE 'No hay evaluaciones en el curso';		
		END IF;	
	END IF;	
END;
$$;
 Z   DROP PROCEDURE public.calcular_nota_final(id_alumno integer, id_instancia_curso integer);
       public       postgres    false            '           1255    34038 3   consulta_vista_cursos_inscritos_por_alumno(integer)    FUNCTION     �  CREATE FUNCTION public.consulta_vista_cursos_inscritos_por_alumno(_matricula_id integer) RETURNS TABLE(id_instancia integer, nombre_del_curso character varying, seccion character varying, anio integer, semestre public.tipo_semestre, nombre_profesor_encargado character varying, situacion public.situacion_matricula, nota_final integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT cursos_de_alumno.id_instancia,
	cursos_de_alumno.nombre_del_curso,
	cursos_de_alumno.seccion,
	cursos_de_alumno.anio,
	cursos_de_alumno.semestre,
	cursos_de_alumno.nombre_profesor_encargado,
	cursos_de_alumno.situacion,
	cursos_de_alumno.nota_final
	FROM cursos_de_alumno
	WHERE cursos_de_alumno.alumno=_matricula_id;
END;
$$;
 X   DROP FUNCTION public.consulta_vista_cursos_inscritos_por_alumno(_matricula_id integer);
       public       postgres    false    683    689            �            1255    33702 ?   consulta_vista_cursos_inscritos_por_profesor(character varying)    FUNCTION       CREATE FUNCTION public.consulta_vista_cursos_inscritos_por_profesor(_rut character varying) RETURNS TABLE(id_instancia integer, nombre_del_curso character varying, seccion character varying, anio integer, semestre public.tipo_semestre)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT cursos_de_profesor.id_instancia,
	cursos_de_profesor.nombre_del_curso,
	cursos_de_profesor.seccion,
	cursos_de_profesor.anio,
	cursos_de_profesor.semestre
	FROM cursos_de_profesor
	WHERE cursos_de_profesor.profesor=_rut;
END;
$$;
 [   DROP FUNCTION public.consulta_vista_cursos_inscritos_por_profesor(_rut character varying);
       public       postgres    false    689            �            1255    33703 *   creacion_vista_cursos_dados_por_profesor()    FUNCTION       CREATE FUNCTION public.creacion_vista_cursos_dados_por_profesor() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN   
    execute format('CREATE MATERIALIZED VIEW cursos_de_profesor AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS profesor
	FROM instancia_curso, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
    WITH DATA');
END;
$$;
 A   DROP FUNCTION public.creacion_vista_cursos_dados_por_profesor();
       public       postgres    false            &           1255    34031 ,   creacion_vista_cursos_inscritos_por_alumno()    FUNCTION     �  CREATE FUNCTION public.creacion_vista_cursos_inscritos_por_alumno() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN   
    execute format('CREATE MATERIALIZED VIEW cursos_de_alumno AS
	SELECT instancia_curso.id AS id_instancia,
	curso.nombre AS nombre_del_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	curso.ref_profesor_encargado AS nombre_profesor_encargado,
	matricula.ref_alumno AS alumno,
	matricula.situacion AS situacion,
	matricula.nota_final AS nota_final
	FROM matricula, instancia_curso, curso
	WHERE matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo
    WITH DATA');
END;
$$;
 C   DROP FUNCTION public.creacion_vista_cursos_inscritos_por_alumno();
       public       postgres    false            �            1255    33705 �   crear_evaluacion(date, integer, integer, public.area_evaluacion, public.tipo_evaluacion, character varying, character varying, integer) 	   PROCEDURE     D  CREATE PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
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
$$;
 �   DROP PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer);
       public       postgres    false    686    680            �            1255    33706 4   crear_instancia_evaluacion(integer, bigint, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.crear_instancia_evaluacion(_ref_alumno integer, _ref_evaluacion bigint, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
	INSERT INTO instancia_evaluacion(ref_alumno, ref_evaluacion, ref_instancia_curso) 
	VALUES (_ref_alumno, _ref_evaluacion, _ref_instancia_curso);
	RAISE NOTICE 'La instancia evaluación fue registrada correctamente';    
END;
$$;
 }   DROP PROCEDURE public.crear_instancia_evaluacion(_ref_alumno integer, _ref_evaluacion bigint, _ref_instancia_curso integer);
       public       postgres    false            �            1255    33707 )   cursor_actualizar_evaluacion_por_alumno()    FUNCTION     �  CREATE FUNCTION public.cursor_actualizar_evaluacion_por_alumno() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
END;$$;
 @   DROP FUNCTION public.cursor_actualizar_evaluacion_por_alumno();
       public       postgres    false            �            1255    33708 &   cursor_agregar_evaluacion_por_alumno()    FUNCTION     {  CREATE FUNCTION public.cursor_agregar_evaluacion_por_alumno() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
END;$$;
 =   DROP FUNCTION public.cursor_agregar_evaluacion_por_alumno();
       public       postgres    false            �            1255    33709 $   cursor_verificar_porcentaje(integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_porcentaje(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
END;$$;
 I   DROP FUNCTION public.cursor_verificar_porcentaje(_id_instancia integer);
       public       postgres    false            �            1255    33710 #   cursor_verificar_situacion(integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_situacion(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
END;$$;
 H   DROP FUNCTION public.cursor_verificar_situacion(_id_instancia integer);
       public       postgres    false            �            1255    33711 ,   cursor_verificar_situacion(integer, integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_situacion(_ref_alumno integer, _ref_instancia_curso integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	cursor_promedio CURSOR FOR SELECT nota, exigible
								FROM instancia_evaluacion, evaluacion
								WHERE ref_alumno=_ref_alumno
								AND instancia_evaluacion.ref_instancia_curso=_ref_instancia_curso
								AND ref_evaluacion=codigo;
	valor RECORD;
BEGIN 
	OPEN cursor_promedio;	
	FETCH cursor_promedio INTO valor;
	WHILE (FOUND) LOOP
		IF (valor.exigible = 1) THEN
			IF (valor.nota < 40) THEN
				RAISE NOTICE 'Alumno reprueba por nota inferior a 40 en evaluación exigible';
				RETURN 1;
			ELSE
				RETURN 2;
			END IF;
		ELSE
			RAISE NOTICE 'No puede calcular la nota final porque al curso le faltan evaluaciones. Recuerde que el curso tiene % %% restante', valor.porcentaje_restante;
			RETURN 0;
		END IF;	
		FETCH cursor_promedio INTO valor;
	END LOOP;	
END;$$;
 d   DROP FUNCTION public.cursor_verificar_situacion(_ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false            �            1255    33712    deshabilitar_alumno(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_alumno(_matricula_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE alumno SET estado=0 WHERE alumno.matricula_id=_matricula_id;
END;
$$;
 B   DROP PROCEDURE public.deshabilitar_alumno(_matricula_id integer);
       public       postgres    false            �            1255    33713    deshabilitar_profesor(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_profesor(_rut integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE profesor SET estado=0 WHERE profesor.rut=_rut;
END;
$$;
 ;   DROP PROCEDURE public.deshabilitar_profesor(_rut integer);
       public       postgres    false            #           1255    33714 !   eliminar_instancia_curso(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_instancia_curso(_id_instancia integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	SELECT numero_alumnos_matriculados(_id_instancia) INTO num_alumnos;

	IF(num_alumnos = 0) THEN 
		DELETE FROM instancia_curso WHERE instancia_curso.id = _id_instancia;
	ELSE
		RAISE NOTICE 'La instancia tiene alumnos, por lo que no se puede eliminar';
	END IF;
END;
$$;
 G   DROP PROCEDURE public.eliminar_instancia_curso(_id_instancia integer);
       public       postgres    false            �            1255    33715 !   inscribir_curso(integer, integer) 	   PROCEDURE     V  CREATE PROCEDURE public.inscribir_curso(_ref_alumno integer, _ref_curso integer)
    LANGUAGE plpgsql
    AS $$
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
$$;
 P   DROP PROCEDURE public.inscribir_curso(_ref_alumno integer, _ref_curso integer);
       public       postgres    false            �            1255    33716    lista_alumnos()    FUNCTION     �  CREATE FUNCTION public.lista_alumnos() RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.rut AS rut,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	alumno.apellido_materno AS apellido_materno,
	alumno.correo AS correo_alumno,
	alumno.telefono AS telefono_alumno,
	alumno.estado AS estado_alumno
	FROM alumno;
END;
$$;
 &   DROP FUNCTION public.lista_alumnos();
       public       postgres    false            �            1255    33717 )   lista_alumnos_en_instancia_curso(integer)    FUNCTION     K  CREATE FUNCTION public.lista_alumnos_en_instancia_curso(_id integer) RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.rut AS rut,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	alumno.apellido_materno AS apellido_materno,
	alumno.correo AS correo_alumno,
	alumno.telefono AS telefono_alumno,
	alumno.estado AS estado_alumno
	FROM alumno, matricula, instancia_curso
	WHERE alumno.matricula_id=matricula.ref_alumno
	AND matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.id=_id;
END;
$$;
 D   DROP FUNCTION public.lista_alumnos_en_instancia_curso(_id integer);
       public       postgres    false            �            1255    33718    lista_curso_con_instancias()    FUNCTION     �  CREATE FUNCTION public.lista_curso_con_instancias() RETURNS TABLE(seccion_id integer, nombre_curso character varying, seccion character varying, periodo integer, anio integer, semestre public.tipo_semestre, porcentaje_restante integer, profesor_rut character varying, nombre_profesor character varying, apellido character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_curso.id AS seccion_id,
	curso.nombre AS nombre_curso,
	instancia_curso.seccion AS seccion,
	instancia_curso.periodo AS periodo,
	instancia_curso.anio AS anio,
	instancia_curso.semestre AS semestre,
	instancia_curso.porcentaje_restante AS porcentaje_restante,
	profesor.rut AS profesor_rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido
	FROM curso, instancia_curso, profesor
	WHERE curso.codigo=instancia_curso.ref_curso
	AND instancia_curso.ref_profesor=profesor.rut;
END;
$$;
 3   DROP FUNCTION public.lista_curso_con_instancias();
       public       postgres    false    689            �            1255    33719    lista_cursos()    FUNCTION     J  CREATE FUNCTION public.lista_cursos() RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	profesor.rut AS profesor_rut,
	profesor.nombre AS profesor_nombre,
	profesor.apellido AS profesor_apellido
	FROM curso, profesor
	WHERE profesor.rut=curso.ref_profesor_encargado;
END;
$$;
 %   DROP FUNCTION public.lista_cursos();
       public       postgres    false            �            1255    33720    lista_cursos(integer)    FUNCTION       CREATE FUNCTION public.lista_cursos(_rut_profesor integer) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	profesor.rut AS profesor_rut,
	profesor.nombre AS profesor_nombre,
	profesor.apellido AS profesor_apellido
	FROM curso, profesor
	WHERE profesor.rut=curso.ref_profesor_encargado
	AND profesor.rut=_rut_profesor;
END;
$$;
 :   DROP FUNCTION public.lista_cursos(_rut_profesor integer);
       public       postgres    false            �            1255    33721    lista_cursos(character varying)    FUNCTION     �  CREATE FUNCTION public.lista_cursos(_rut_profesor character varying) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	profesor.rut AS profesor_rut,
	profesor.nombre AS profesor_nombre,
	profesor.apellido AS profesor_apellido
	FROM curso, profesor
	WHERE profesor.rut=curso.ref_profesor_encargado
	AND profesor.rut=_rut_profesor;
END;
$$;
 D   DROP FUNCTION public.lista_cursos(_rut_profesor character varying);
       public       postgres    false            �            1255    33722 /   lista_evaluaciones_por_instancia_curso(integer)    FUNCTION     8  CREATE FUNCTION public.lista_evaluaciones_por_instancia_curso(_id integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM evaluacion, instancia_curso
	WHERE evaluacion.ref_instancia_curso=instancia_curso.id
	AND evaluacion.ref_instancia_curso=_id;
END;
$$;
 J   DROP FUNCTION public.lista_evaluaciones_por_instancia_curso(_id integer);
       public       postgres    false    680    686            %           1255    34021 C   lista_evaluaciones_por_instancia_curso_por_alumno(integer, integer)    FUNCTION     �  CREATE FUNCTION public.lista_evaluaciones_por_instancia_curso_por_alumno(_id integer, _matricula_id integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer, nota integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso,
		instancia_evaluacion.nota AS nota
	FROM evaluacion, instancia_curso, matricula, instancia_evaluacion
	WHERE evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.id= _id
	AND evaluacion.ref_instancia_curso=_id
	AND instancia_evaluacion.ref_instancia_curso=_id
	AND matricula.ref_instancia_curso=_id
	AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo
	AND matricula.ref_alumno=_matricula_id
	AND instancia_evaluacion.ref_alumno=_matricula_id;
END;
$$;
 l   DROP FUNCTION public.lista_evaluaciones_por_instancia_curso_por_alumno(_id integer, _matricula_id integer);
       public       postgres    false    680    686            �            1255    33724    lista_profesores()    FUNCTION       CREATE FUNCTION public.lista_profesores() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, correo_profesor character varying, telefono_profesor character varying, estado_profesor integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	profesor.correo AS correo_profesor,
	profesor.telefono AS telefono_profesor,
	profesor.estado AS estado_profesor
	FROM profesor;
END;
$$;
 )   DROP FUNCTION public.lista_profesores();
       public       postgres    false            �            1255    33725 �   modificar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.modificar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE alumno
	SET matricula_id = _matricula,
		rut = _rut,
		nombre = _nombre,
		apellido_paterno = _apellido_paterno,
		apellido_materno = _apellido_materno,
		correo = _correo,
		telefono = _telefono
	WHERE alumno.matricula_id = _matricula;
END;
$$;
 �   DROP PROCEDURE public.modificar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying);
       public       postgres    false                       1255    33967 2   modificar_clave_alumno(character varying, integer) 	   PROCEDURE       CREATE PROCEDURE public.modificar_clave_alumno(_contrasena character varying, _ref_alumno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE alumno_seguridad
	SET contrasena = _contrasena
	WHERE ref_alumno = _ref_alumno;

	RAISE NOTICE 'Clave modificada';
END;
$$;
 b   DROP PROCEDURE public.modificar_clave_alumno(_contrasena character varying, _ref_alumno integer);
       public       postgres    false                       1255    33968 >   modificar_clave_profesor(character varying, character varying) 	   PROCEDURE        CREATE PROCEDURE public.modificar_clave_profesor(_contrasena character varying, _ref_profesor character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE profesor_seguridad
	SET contrasena = _contrasena
	WHERE ref_profesor = _ref_profesor;

	RAISE NOTICE 'Clave modificada';
END;
$$;
 p   DROP PROCEDURE public.modificar_clave_profesor(_contrasena character varying, _ref_profesor character varying);
       public       postgres    false                        1255    33726 Q   modificar_curso(integer, character varying, character varying, character varying) 	   PROCEDURE     W  CREATE PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE curso
	SET nombre = _nombre,
		carrera = _carrera,
		ref_profesor_encargado = _ref_profesor_encargado
	WHERE curso.codigo = _codigo;
END;
$$;
 �   DROP PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying, _ref_profesor_encargado character varying);
       public       postgres    false                       1255    33727 �   modificar_evaluacion(bigint, date, integer, integer, public.area_evaluacion, public.tipo_evaluacion, character varying, character varying, integer) 	   PROCEDURE     $  CREATE PROCEDURE public.modificar_evaluacion(_codigo bigint, _fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
	IF (_porcentaje>0 AND _porcentaje<101) THEN
		UPDATE evaluacion
		SET fecha = _fecha,
			porcentaje = _porcentaje,
			exigible = _exigible,
			area = _area,
			tipo = _tipo,
			prorroga = _prorroga,
			ref_profesor = _ref_profesor,			
			ref_instancia_curso = _ref_instancia_curso
		WHERE codigo = _codigo;
		RAISE NOTICE 'La evaluación fue modificada correctamente';
	ELSE
		RAISE NOTICE 'No se modificar la evaluación porque el porcentaje no está en el rango [1,100]';		
	END IF;	    
END;
$$;
 	  DROP PROCEDURE public.modificar_evaluacion(_codigo bigint, _fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer);
       public       postgres    false    680    686                       1255    33728 s   modificar_instancia(integer, integer, character varying, character varying, integer, integer, public.tipo_semestre) 	   PROCEDURE     �  CREATE PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((SELECT COUNT(id) FROM instancia_curso WHERE periodo=_periodo AND seccion=_seccion AND ref_curso=_ref_curso AND anio=_anio AND semestre=_semestre) = 0) THEN
	    UPDATE instancia_curso
		SET periodo = _periodo,
			seccion = _seccion,
			ref_profesor = _ref_profesor,
			ref_curso = _ref_curso,
			anio = _anio,
			semestre = _semestre
		WHERE id = _id;
	ELSE
		RAISE NOTICE 'No se puede modificar la instancia con estos datos porque ya existe una instancia así';
	END IF;
END;
$$;
 �   DROP PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre);
       public       postgres    false    689                       1255    33729 7   modificar_matricula(integer, integer, integer, integer) 	   PROCEDURE     g  CREATE PROCEDURE public.modificar_matricula(_codigo_matricula integer, _ref_alumno integer, _ref_instancia_curso integer, _nota_final integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE matricula
	SET nota_final = _nota_final,
		ref_alumno = _ref_alumno,
		ref_instancia_curso = _ref_instancia_curso
	WHERE codigo_matricula = _codigo_matricula;
END;
$$;
 �   DROP PROCEDURE public.modificar_matricula(_codigo_matricula integer, _ref_alumno integer, _ref_instancia_curso integer, _nota_final integer);
       public       postgres    false                       1255    33730 2   modificar_nota(integer, integer, integer, integer) 	   PROCEDURE     o  CREATE PROCEDURE public.modificar_nota(_nota integer, _ref_evaluacion integer, _ref_alumno integer, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (_nota>9 AND _nota<71) THEN
		UPDATE instancia_evaluacion
		SET nota = _nota
		WHERE instancia_evaluacion.ref_alumno = _ref_alumno
		AND instancia_evaluacion.ref_instancia_curso = _ref_instancia_curso
		AND instancia_evaluacion.ref_evaluacion = _ref_evaluacion;
		RAISE NOTICE 'Se modificó la nota correctamente a %', _nota;
	ELSE
		RAISE NOTICE 'No se pudo modificar la nota porque no está dentro del rango permitido [10,70]';
	END IF;    
END;
$$;
 �   DROP PROCEDURE public.modificar_nota(_nota integer, _ref_evaluacion integer, _ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false                       1255    33731 q   modificar_profesor(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     w  CREATE PROCEDURE public.modificar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE profesor
	SET rut = _rut,
		nombre = _nombre,
		apellido = _apellido,
		correo = _correo,
		telefono = _telefono
	WHERE profesor.rut = _rut;
END;
$$;
 �   DROP PROCEDURE public.modificar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying);
       public       postgres    false                       1255    33732    mostrar_alumno_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_alumno_por_pk(_matricula_id integer) RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.rut AS rut,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	alumno.apellido_materno AS apellido_materno,
	alumno.correo AS correo_alumno,
	alumno.telefono AS telefono_alumno,
	alumno.estado AS estado_alumno
	FROM alumno
	WHERE alumno.matricula_id=_matricula_id;
END;
$$;
 C   DROP FUNCTION public.mostrar_alumno_por_pk(_matricula_id integer);
       public       postgres    false                       1255    33733    mostrar_curso_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_curso_por_pk(_codigo integer) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	curso.carrera AS carrera_curso,
	curso.ref_profesor_encargado AS profesor_encargado
	FROM curso
	WHERE curso.codigo=_codigo;
END;
$$;
 <   DROP FUNCTION public.mostrar_curso_por_pk(_codigo integer);
       public       postgres    false                       1255    33734 "   mostrar_evaluacion_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_evaluacion_por_pk(_codigo integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM evaluacion
	WHERE evaluacion.codigo=_codigo;
END;
$$;
 A   DROP FUNCTION public.mostrar_evaluacion_por_pk(_codigo integer);
       public       postgres    false    686    680            	           1255    33735 !   mostrar_evaluacion_por_pk(bigint)    FUNCTION     �  CREATE FUNCTION public.mostrar_evaluacion_por_pk(_codigo bigint) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT evaluacion.codigo AS codigo,
		evaluacion.fecha AS fecha,
		evaluacion.porcentaje AS porcentaje,
		evaluacion.exigible AS exigible,
		evaluacion.area AS area,
		evaluacion.tipo AS tipo,
		evaluacion.prorroga AS prorroga,	
		evaluacion.ref_profesor AS ref_profesor,	
		evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM evaluacion
	WHERE evaluacion.codigo=_codigo;
END;
$$;
 @   DROP FUNCTION public.mostrar_evaluacion_por_pk(_codigo bigint);
       public       postgres    false    680    686            
           1255    33736 '   mostrar_instancia_curso_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_instancia_curso_por_pk(_id integer) RETURNS TABLE(id integer, periodo integer, seccion character varying, anio integer, semestre public.tipo_semestre, ref_profesor character varying, ref_curso integer, porcentaje_restante integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_curso.id AS id,
		instancia_curso.periodo AS periodo,
		instancia_curso.seccion AS seccion,
		instancia_curso.anio AS anio,
		instancia_curso.semestre AS semestre,
		instancia_curso.ref_profesor AS ref_profesor,
		instancia_curso.ref_curso AS ref_curso,
		instancia_curso.porcentaje_restante AS porcentaje_restante
	FROM instancia_curso
	WHERE instancia_curso.id=_id;
END;
$$;
 B   DROP FUNCTION public.mostrar_instancia_curso_por_pk(_id integer);
       public       postgres    false    689                       1255    33737 +   mostrar_instancia_evaluacion_por_pk(bigint)    FUNCTION     �  CREATE FUNCTION public.mostrar_instancia_evaluacion_por_pk(_codigo_intancia_evaluacion bigint) RETURNS TABLE(codigo_intancia_evaluacion bigint, ref_alumno integer, ref_evaluacion bigint, nota integer, ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT instancia_evaluacion.codigo_intancia_evaluacion AS codigo_intancia_evaluacion,
		instancia_evaluacion.ref_alumno AS ref_alumno,
		instancia_evaluacion.ref_evaluacion AS ref_evaluacion,
		instancia_evaluacion.nota AS nota,
		instancia_evaluacion.ref_instancia_curso AS ref_instancia_curso
	FROM instancia_evaluacion
	WHERE instancia_evaluacion.codigo_intancia_evaluacion=_codigo_intancia_evaluacion;
END;
$$;
 ^   DROP FUNCTION public.mostrar_instancia_evaluacion_por_pk(_codigo_intancia_evaluacion bigint);
       public       postgres    false                       1255    33738 !   mostrar_matricula_por_pk(integer)    FUNCTION     ?  CREATE FUNCTION public.mostrar_matricula_por_pk(_codigo_matricula integer) RETURNS TABLE(codigo_matricula integer, nota_final integer, ref_alumno integer, ref_instancia_curso integer, situacion public.situacion_matricula)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT matricula.codigo_matricula AS codigo_matricula,
		matricula.nota_final AS nota_final,
		matricula.ref_alumno AS ref_alumno,
		matricula.ref_instancia_curso AS ref_instancia_curso,
		matricula.situacion AS situacion
	FROM matricula
	WHERE matricula.codigo_matricula=_codigo_matricula;
END;
$$;
 J   DROP FUNCTION public.mostrar_matricula_por_pk(_codigo_matricula integer);
       public       postgres    false    683                       1255    33740 *   mostrar_profesor_por_pk(character varying)    FUNCTION     F  CREATE FUNCTION public.mostrar_profesor_por_pk(_rut character varying) RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, correo_profesor character varying, telefono_profesor character varying, estado_profesor integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	profesor.correo AS correo_profesor,
	profesor.telefono AS telefono_profesor,
	profesor.estado AS estado_profesor
	FROM profesor
	WHERE profesor.rut=_rut;
END;
$$;
 F   DROP FUNCTION public.mostrar_profesor_por_pk(_rut character varying);
       public       postgres    false                       1255    33741 -   mostrar_profesores_con_numero_de_reprobados()    FUNCTION     �  CREATE FUNCTION public.mostrar_profesores_con_numero_de_reprobados() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, cantidad_alumnos_reprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_reprobados
	FROM profesor, instancia_curso, matricula
	WHERE profesor.rut=instancia_curso.ref_profesor	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='CURSANDO'
	GROUP BY (profesor.rut)
	ORDER BY cantidad_alumnos_reprobados DESC;
END;
$$;
 D   DROP FUNCTION public.mostrar_profesores_con_numero_de_reprobados();
       public       postgres    false            $           1255    34046 6   nota_final_alumno_en_instancia_curso(integer, integer)    FUNCTION     F  CREATE FUNCTION public.nota_final_alumno_en_instancia_curso(_matricula integer, _id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	nota_final_alumno INTEGER default 0;
BEGIN
	SELECT matricula.nota_final AS nota_final
	FROM matricula
	WHERE matricula.ref_alumno=_matricula
	AND matricula.ref_instancia_curso=_id_instancia INTO nota_final_alumno;

	IF (nota_final_alumno > 9) THEN
		RAISE NOTICE 'La nota final del alumno es %', nota_final_alumno;
		RETURN nota_final_alumno;
	ELSE
		RAISE NOTICE 'El alumno no tiene notas';
		RETURN 0;
	END IF;	
END;
$$;
 f   DROP FUNCTION public.nota_final_alumno_en_instancia_curso(_matricula integer, _id_instancia integer);
       public       postgres    false                       1255    33742 .   notas_alumno_curso(integer, character varying)    FUNCTION     w  CREATE FUNCTION public.notas_alumno_curso(_matricula integer, _nombre_curso character varying) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.nombre AS nombre,
	alumno.apellido_paterno AS apellido_paterno,
	curso.nombre AS curso,
	instancia_curso.seccion AS seccion,
	evaluacion.tipo AS tipo_evaluacion,
	instancia_evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion, instancia_evaluacion
	WHERE alumno.matricula_id=2013407015
	AND curso.nombre=_nombre_curso
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$;
 ^   DROP FUNCTION public.notas_alumno_curso(_matricula integer, _nombre_curso character varying);
       public       postgres    false                       1255    33743    notas_alumno_todas(integer)    FUNCTION     6  CREATE FUNCTION public.notas_alumno_todas(_matricula integer) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT alumno.matricula_id AS matricula,
	alumno.nombre AS nombre,
	alumno.apellido_paterno AS apellido_paterno,
	curso.nombre AS curso,
	instancia_curso.seccion AS seccion,
	evaluacion.tipo AS tipo_evaluacion,
	instancia_evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion, instancia_evaluacion
	WHERE alumno.matricula_id=2013407015
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$;
 =   DROP FUNCTION public.notas_alumno_todas(_matricula integer);
       public       postgres    false                       1255    33744 $   numero_alumnos_matriculados(integer)    FUNCTION     �  CREATE FUNCTION public.numero_alumnos_matriculados(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	SELECT COUNT(alumno.matricula_id)
	FROM instancia_curso, alumno, matricula
	WHERE instancia_curso.id = matricula.ref_instancia_curso
	AND matricula.ref_alumno = _id_instancia INTO num_alumnos;

	RETURN num_alumnos;
END;
$$;
 I   DROP FUNCTION public.numero_alumnos_matriculados(_id_instancia integer);
       public       postgres    false                       1255    33745    proceso_agregar_log()    FUNCTION     �  CREATE FUNCTION public.proceso_agregar_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla, datos_nuevos, datos_viejos) 
		VALUES ('DELETE', now(), user, TG_TABLE_NAME, NULL, ROW(OLD.*) );
	ELSEIF (TG_OP = 'UPDATE') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla, datos_nuevos, datos_viejos) 
		VALUES ('UPDATE', now(), user, TG_TABLE_NAME, ROW(NEW.*), ROW(OLD.*));
	ELSEIF (TG_OP = 'INSERT') THEN
		INSERT INTO log(operacion, stamp, user_id, nombre_tabla, datos_nuevos, datos_viejos) 
		VALUES ('INSERT', now(), user, TG_TABLE_NAME, ROW(NEW.*), NULL);
	END IF;
	RETURN NULL;
END;
$$;
 ,   DROP FUNCTION public.proceso_agregar_log();
       public       postgres    false                       1255    33746 &   profesor_habilitado(character varying)    FUNCTION     ^  CREATE FUNCTION public.profesor_habilitado(_rut_profesor character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	estado_profesor INTEGER default 0;
BEGIN
	SELECT profesor.estado
	FROM profesor
	WHERE profesor.rut = _rut_profesor INTO estado_profesor;

	IF(estado_profesor = 1) THEN
		RETURN 1; 
	ELSE
		RETURN 0;
	END IF;
END;
$$;
 K   DROP FUNCTION public.profesor_habilitado(_rut_profesor character varying);
       public       postgres    false                       1255    33747 )   refresh_vista_cursos_dados_por_profesor()    FUNCTION     �   CREATE FUNCTION public.refresh_vista_cursos_dados_por_profesor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_profesor;
    RETURN NULL;
END;
$$;
 @   DROP FUNCTION public.refresh_vista_cursos_dados_por_profesor();
       public       postgres    false                       1255    33748 +   refresh_vista_cursos_inscritos_por_alumno()    FUNCTION     �   CREATE FUNCTION public.refresh_vista_cursos_inscritos_por_alumno() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_alumno;
    RETURN NULL;
END;
$$;
 B   DROP FUNCTION public.refresh_vista_cursos_inscritos_por_alumno();
       public       postgres    false                       1255    33966 �   registrar_profesor(character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying, _clave character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO profesor (rut, nombre, apellido, correo, telefono) 
  VALUES (_rut, _nombre, _apellido, _correo, _telefono);

  INSERT INTO profesor_seguridad (contrasena, ref_profesor) 
  VALUES (_clave, _rut);
END;
$$;
 �   DROP PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying, _clave character varying);
       public       postgres    false            "           1255    34020 3   reporte_alumnos_con_mayor_numero_cursos_aprobados()    FUNCTION     �  CREATE FUNCTION public.reporte_alumnos_con_mayor_numero_cursos_aprobados() RETURNS TABLE(matricula_alumno integer, nombre_alumno character varying, apellido_paterno character varying, cantidad_cursos_aprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.matricula_id AS matricula_alumno,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	COUNT(matricula.situacion) AS cantidad_cursos_aprobados
	FROM matricula, alumno
	WHERE matricula.ref_alumno=alumno.matricula_id
	AND matricula.situacion='APROBADO'
	GROUP BY (matricula_alumno)
	ORDER BY (cantidad_cursos_aprobados) DESC;	
END;
$$;
 J   DROP FUNCTION public.reporte_alumnos_con_mayor_numero_cursos_aprobados();
       public       postgres    false            !           1255    34019 4   reporte_alumnos_con_mayor_numero_cursos_reprobados()    FUNCTION     �  CREATE FUNCTION public.reporte_alumnos_con_mayor_numero_cursos_reprobados() RETURNS TABLE(matricula_alumno integer, nombre_alumno character varying, apellido_paterno character varying, cantidad_cursos_reprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.matricula_id AS matricula_alumno,
	alumno.nombre AS nombre_alumno,
	alumno.apellido_paterno AS apellido_paterno,
	COUNT(matricula.situacion) AS cantidad_cursos_reprobados
	FROM matricula, alumno
	WHERE matricula.ref_alumno=alumno.matricula_id
	AND matricula.situacion='REPROBADO'
	GROUP BY (matricula_alumno)
	ORDER BY (cantidad_cursos_reprobados) DESC;	
END;
$$;
 K   DROP FUNCTION public.reporte_alumnos_con_mayor_numero_cursos_reprobados();
       public       postgres    false                        1255    34016 $   reporte_alumnos_con_mejor_promedio()    FUNCTION     �  CREATE FUNCTION public.reporte_alumnos_con_mejor_promedio() RETURNS TABLE(matricula_alumno integer, nombre_alumno character varying, apellido_paterno character varying, promedio_final bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((SELECT COUNT(T1.cantidad_notas)
		FROM (SELECT COUNT(matricula.nota_final) AS cantidad_notas
			FROM matricula, alumno
			WHERE matricula.ref_alumno=alumno.matricula_id
			GROUP BY (alumno.matricula_id)) AS T1
		WHERE T1.cantidad_notas=0) = 0) THEN
	
		RETURN QUERY 	
		SELECT alumno.matricula_id AS matricula_alumno,
		alumno.nombre AS nombre_alumno,
		alumno.apellido_paterno AS apellido_paterno,
		(SUM(matricula.nota_final)/COUNT(matricula.nota_final)) AS promedio_final
		FROM matricula, alumno
		WHERE matricula.ref_alumno=alumno.matricula_id
		GROUP BY (alumno.matricula_id)
		ORDER BY (promedio_final) DESC;
	ELSE
		RAISE NOTICE 'No se puede generar este reporte porque aún hay alumnos sin todas sus notas finales';
	END IF;
END;
$$;
 ;   DROP FUNCTION public.reporte_alumnos_con_mejor_promedio();
       public       postgres    false                       1255    34017 #   reporte_alumnos_con_peor_promedio()    FUNCTION     �  CREATE FUNCTION public.reporte_alumnos_con_peor_promedio() RETURNS TABLE(matricula_alumno integer, nombre_alumno character varying, apellido_paterno character varying, promedio_final bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((SELECT COUNT(T1.cantidad_notas)
		FROM (SELECT COUNT(matricula.nota_final) AS cantidad_notas
			FROM matricula, alumno
			WHERE matricula.ref_alumno=alumno.matricula_id
			GROUP BY (alumno.matricula_id)) AS T1
		WHERE T1.cantidad_notas=0) = 0) THEN
	
		RETURN QUERY 	
		SELECT alumno.matricula_id AS matricula_alumno,
		alumno.nombre AS nombre_alumno,
		alumno.apellido_paterno AS apellido_paterno,
		(SUM(matricula.nota_final)/COUNT(matricula.nota_final)) AS promedio_final
		FROM matricula, alumno
		WHERE matricula.ref_alumno=alumno.matricula_id
		GROUP BY (alumno.matricula_id)
		ORDER BY (promedio_final) ASC;
	ELSE
		RAISE NOTICE 'No se puede generar este reporte porque aún hay alumnos sin todas sus notas finales';
	END IF;
END;
$$;
 :   DROP FUNCTION public.reporte_alumnos_con_peor_promedio();
       public       postgres    false                       1255    33936 -   reporte_cursos_con_porcentaje_de_reprobados()    FUNCTION     �  CREATE FUNCTION public.reporte_cursos_con_porcentaje_de_reprobados() RETURNS TABLE(codigo_del_curso integer, nombre_del_curso character varying, porcentaje_alumnos_reprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT T1.codigo_curso AS codigo_del_curso,
	T1.nombre_curso AS nombre_del_curso,
	((T1.cantidad_alumnos_reprobados*100)/T2.cantidad_alumnos) AS porcentaje_alumnos_reprobados
	FROM 
	(SELECT curso.codigo AS codigo_curso,
	curso.nombre AS nombre_curso,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_reprobados
	FROM instancia_curso, matricula, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='REPROBADO'
	GROUP BY (curso.codigo)
	ORDER BY cantidad_alumnos_reprobados DESC) AS T1,  
	(SELECT curso.codigo AS codigo_curso,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos
	FROM instancia_curso, matricula, curso
	WHERE instancia_curso.ref_curso=curso.codigo	
	AND instancia_curso.id=matricula.ref_instancia_curso
	GROUP BY (curso.codigo)
	ORDER BY cantidad_alumnos DESC) AS T2
	WHERE T1.codigo_curso=T2.codigo_curso;
END;
$$;
 D   DROP FUNCTION public.reporte_cursos_con_porcentaje_de_reprobados();
       public       postgres    false                       1255    33932 -   reporte_numero_cursos_dictados_por_profesor()    FUNCTION     &  CREATE FUNCTION public.reporte_numero_cursos_dictados_por_profesor() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, cantidad_cursos_dictados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(instancia_curso.id) AS cantidad_cursos_dictados
	FROM profesor, instancia_curso
	WHERE profesor.rut=instancia_curso.ref_profesor	
	GROUP BY (profesor.rut)
	ORDER BY profesor.nombre;
END;
$$;
 D   DROP FUNCTION public.reporte_numero_cursos_dictados_por_profesor();
       public       postgres    false                       1255    33750 -   reporte_porcentaje_alumnos_que_toman_cursos()    FUNCTION     �  CREATE FUNCTION public.reporte_porcentaje_alumnos_que_toman_cursos() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	numero_alumnos integer default 0;
	numero_matriculados integer default 0;
BEGIN
	SELECT COUNT(alumno.matricula_id)
	FROM alumno INTO numero_alumnos;

	SELECT DISTINCT COUNT(matricula.ref_alumno)
	FROM matricula INTO numero_matriculados;

	IF (numero_alumnos > 0) THEN
		RAISE NOTICE 'El porcentaje de alumnos matriculados es % %%', ((numero_matriculados*100)/(numero_alumnos));	
		RETURN ((numero_matriculados*100)/(numero_alumnos));
	ELSE
		RAISE NOTICE 'No hay alumnos en el sistema';	
		RETURN 0;
	END IF;
END;
$$;
 D   DROP FUNCTION public.reporte_porcentaje_alumnos_que_toman_cursos();
       public       postgres    false            )           1255    33751 ?   reporte_porcentaje_aprobado_y_reprobado_de_una_seccion(integer)    FUNCTION     V  CREATE FUNCTION public.reporte_porcentaje_aprobado_y_reprobado_de_una_seccion(_id_instancia integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
	nombre_curso varchar(50) default 0;
	seccion_curso varchar(2) default 0;
	alumnos_aprobados INTEGER default 0;
	alumnos_reprobados INTEGER default 0;
	rec RECORD;
BEGIN
	SELECT curso.nombre
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO nombre_curso;

	SELECT instancia_curso.seccion
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO seccion_curso;

	SELECT COUNT(situacion)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia
	AND situacion='APROBADO' INTO alumnos_aprobados;

	SELECT COUNT(situacion)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia
	AND situacion='REPROBADO' INTO alumnos_reprobados;
	IF ((alumnos_aprobados+alumnos_reprobados) > 0) THEN		
		SELECT 
		((alumnos_aprobados*100)/(alumnos_aprobados+alumnos_reprobados)) AS alumnos_aprobados,
		((alumnos_reprobados*100)/(alumnos_aprobados+alumnos_reprobados)) AS alumnos_reprobados INTO rec;

		RAISE NOTICE 'El porcentaje de alumnos aprobados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_aprobados*100)/(alumnos_aprobados+alumnos_reprobados));
		RAISE NOTICE 'El porcentaje de alumnos reprobados en el curso % sección % es % %%', nombre_curso, seccion_curso, ((alumnos_reprobados*100)/(alumnos_aprobados+alumnos_reprobados));
		RETURN rec;
	ELSE
		RAISE NOTICE 'Todavía hay alumnos cursando ramos. Espere a que se cierre el semestre';
		RETURN rec;
	END IF;
END;
$$;
 d   DROP FUNCTION public.reporte_porcentaje_aprobado_y_reprobado_de_una_seccion(_id_instancia integer);
       public       postgres    false            +           1255    34047 ,   reporte_profesores_con_numero_de_aprobados()    FUNCTION     �  CREATE FUNCTION public.reporte_profesores_con_numero_de_aprobados() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, cantidad_alumnos_aprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_aprobados
	FROM profesor, instancia_curso, matricula
	WHERE profesor.rut=instancia_curso.ref_profesor	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='APROBADO'
	GROUP BY (profesor.rut)
	ORDER BY cantidad_alumnos_aprobados DESC;
END;
$$;
 C   DROP FUNCTION public.reporte_profesores_con_numero_de_aprobados();
       public       postgres    false                       1255    33933 -   reporte_profesores_con_numero_de_reprobados()    FUNCTION     �  CREATE FUNCTION public.reporte_profesores_con_numero_de_reprobados() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, cantidad_alumnos_reprobados bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT profesor.rut AS rut,
	profesor.nombre AS nombre_profesor,
	profesor.apellido AS apellido,
	COUNT(matricula.codigo_matricula) AS cantidad_alumnos_reprobados
	FROM profesor, instancia_curso, matricula
	WHERE profesor.rut=instancia_curso.ref_profesor	
	AND instancia_curso.id=matricula.ref_instancia_curso
	AND matricula.situacion='REPROBADO'
	GROUP BY (profesor.rut)
	ORDER BY cantidad_alumnos_reprobados DESC;
END;
$$;
 D   DROP FUNCTION public.reporte_profesores_con_numero_de_reprobados();
       public       postgres    false                       1255    33752 (   reporte_promedio_de_una_seccion(integer)    FUNCTION     �  CREATE FUNCTION public.reporte_promedio_de_una_seccion(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	nombre_curso varchar(50) default 0;
	seccion_curso varchar(2) default 0;
	promedio_seccion INTEGER default 0;
BEGIN
	SELECT curso.nombre
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO nombre_curso;

	SELECT instancia_curso.seccion
	FROM curso, instancia_curso
	WHERE curso.codigo=instancia_curso.ref_curso INTO seccion_curso;

	SELECT AVG(nota_final)
	FROM matricula
	WHERE matricula.ref_instancia_curso = _id_instancia INTO promedio_seccion;

	RAISE NOTICE 'El promedio del curso % sección % es %', nombre_curso, seccion_curso, promedio_seccion;
	RETURN promedio_seccion;
END;
$$;
 M   DROP FUNCTION public.reporte_promedio_de_una_seccion(_id_instancia integer);
       public       postgres    false            �            1255    33753 ,   verificar_existe_profesor_encargado(integer)    FUNCTION     J  CREATE FUNCTION public.verificar_existe_profesor_encargado(_codigo integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 K   DROP FUNCTION public.verificar_existe_profesor_encargado(_codigo integer);
       public       postgres    false                       1255    33754 0   verificar_instancia_evaluacion(integer, integer)    FUNCTION       CREATE FUNCTION public.verificar_instancia_evaluacion(_id_instancia integer, _id_alumno integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	cantidad_evaluaciones INTEGER default 0;
	_rec record;
BEGIN
    SELECT COUNT(evaluacion.codigo)
	FROM evaluacion, instancia_curso, instancia_evaluacion
	WHERE instancia_curso.id=evaluacion.ref_instancia_curso
	AND instancia_evaluacion.ref_alumno=_id_alumno
	AND instancia_curso.id=_id_instancia INTO cantidad_evaluaciones;
	
	SELECT instancia_curso.id AS codigo, 
	instancia_curso.seccion AS seccion,
	curso.nombre AS curso
	FROM curso, instancia_curso
	WHERE instancia_curso.ref_curso=curso.codigo
	AND instancia_curso.id=_id_instancia INTO _rec;
	
	IF (cantidad_evaluaciones = 0) THEN
		RAISE NOTICE 'No hay evaluaciones en el curso % sección % con código %', _rec.curso, _rec.seccion, _rec.codigo;		
		RETURN 0;
	ELSE
		RAISE NOTICE 'Hay % evaluaciones en el curso % sección % con código %', cantidad_evaluaciones, _rec.curso, _rec.seccion, _rec.codigo;
		RETURN 1;
	END IF;
END;
$$;
 `   DROP FUNCTION public.verificar_instancia_evaluacion(_id_instancia integer, _id_alumno integer);
       public       postgres    false            �            1259    33755    alumno    TABLE     ~  CREATE TABLE public.alumno (
    matricula_id integer NOT NULL,
    rut character varying(12) NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido_paterno character varying(50) NOT NULL,
    apellido_materno character varying(50) NOT NULL,
    correo character varying(50) NOT NULL,
    telefono character varying(15) NOT NULL,
    estado integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.alumno;
       public         postgres    false            �            1259    33952    alumno_seguridad    TABLE     �   CREATE TABLE public.alumno_seguridad (
    alumno_id integer NOT NULL,
    contrasena character varying(20) DEFAULT '123456'::character varying NOT NULL,
    ref_alumno integer
);
 $   DROP TABLE public.alumno_seguridad;
       public         postgres    false            �            1259    33950    alumno_seguridad_alumno_id_seq    SEQUENCE     �   ALTER TABLE public.alumno_seguridad ALTER COLUMN alumno_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.alumno_seguridad_alumno_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    214            �            1259    33759    curso    TABLE     �   CREATE TABLE public.curso (
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    carrera character varying(50) NOT NULL,
    ref_profesor_encargado character varying(12)
);
    DROP TABLE public.curso;
       public         postgres    false            �            1259    33762    curso_codigo_seq    SEQUENCE     �   ALTER TABLE public.curso ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.curso_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    197            �            1259    33764    instancia_curso    TABLE     O  CREATE TABLE public.instancia_curso (
    id integer NOT NULL,
    periodo integer NOT NULL,
    seccion character varying(2) NOT NULL,
    anio integer NOT NULL,
    semestre public.tipo_semestre NOT NULL,
    ref_profesor character varying(12),
    ref_curso integer NOT NULL,
    porcentaje_restante integer DEFAULT 100 NOT NULL
);
 #   DROP TABLE public.instancia_curso;
       public         postgres    false    689            �            1259    33768 	   matricula    TABLE     !  CREATE TABLE public.matricula (
    codigo_matricula integer NOT NULL,
    nota_final integer DEFAULT 0 NOT NULL,
    ref_alumno integer NOT NULL,
    ref_instancia_curso integer NOT NULL,
    situacion public.situacion_matricula DEFAULT 'CURSANDO'::public.situacion_matricula NOT NULL
);
    DROP TABLE public.matricula;
       public         postgres    false    683    683            �            1259    34032    cursos_de_alumno    MATERIALIZED VIEW     5  CREATE MATERIALIZED VIEW public.cursos_de_alumno AS
 SELECT instancia_curso.id AS id_instancia,
    curso.nombre AS nombre_del_curso,
    instancia_curso.seccion,
    instancia_curso.anio,
    instancia_curso.semestre,
    curso.ref_profesor_encargado AS nombre_profesor_encargado,
    matricula.ref_alumno AS alumno,
    matricula.situacion,
    matricula.nota_final
   FROM public.matricula,
    public.instancia_curso,
    public.curso
  WHERE ((matricula.ref_instancia_curso = instancia_curso.id) AND (instancia_curso.ref_curso = curso.codigo))
  WITH NO DATA;
 0   DROP MATERIALIZED VIEW public.cursos_de_alumno;
       public         postgres    false    197    199    199    199    197    197    200    200    200    199    199    200    683    689            �            1259    33777    cursos_de_profesor    MATERIALIZED VIEW     ~  CREATE MATERIALIZED VIEW public.cursos_de_profesor AS
 SELECT instancia_curso.id AS id_instancia,
    curso.nombre AS nombre_del_curso,
    instancia_curso.seccion,
    instancia_curso.anio,
    instancia_curso.semestre,
    curso.ref_profesor_encargado AS profesor
   FROM public.instancia_curso,
    public.curso
  WHERE (instancia_curso.ref_curso = curso.codigo)
  WITH NO DATA;
 2   DROP MATERIALIZED VIEW public.cursos_de_profesor;
       public         postgres    false    197    197    197    199    199    199    199    199    689            �            1259    33781 
   evaluacion    TABLE     �  CREATE TABLE public.evaluacion (
    codigo bigint NOT NULL,
    fecha date,
    porcentaje integer NOT NULL,
    exigible integer NOT NULL,
    area public.area_evaluacion DEFAULT 'UNIDAD_1'::public.area_evaluacion NOT NULL,
    tipo public.tipo_evaluacion DEFAULT 'PRUEBA'::public.tipo_evaluacion NOT NULL,
    prorroga character varying(255),
    ref_profesor character varying(12) NOT NULL,
    ref_instancia_curso integer NOT NULL
);
    DROP TABLE public.evaluacion;
       public         postgres    false    680    686    680    686            �            1259    33786    evaluacion_codigo_seq    SEQUENCE     �   ALTER TABLE public.evaluacion ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evaluacion_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    202            �            1259    33788    instancia_curso_id_seq    SEQUENCE     �   ALTER TABLE public.instancia_curso ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instancia_curso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    199            �            1259    33790    instancia_evaluacion    TABLE     �   CREATE TABLE public.instancia_evaluacion (
    codigo_intancia_evaluacion bigint NOT NULL,
    ref_alumno integer NOT NULL,
    ref_evaluacion bigint NOT NULL,
    ref_instancia_curso integer NOT NULL,
    nota integer DEFAULT 0
);
 (   DROP TABLE public.instancia_evaluacion;
       public         postgres    false            �            1259    33794 3   instancia_evaluacion_codigo_intancia_evaluacion_seq    SEQUENCE       ALTER TABLE public.instancia_evaluacion ALTER COLUMN codigo_intancia_evaluacion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instancia_evaluacion_codigo_intancia_evaluacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    205            �            1259    33796    log    TABLE       CREATE TABLE public.log (
    id_log bigint NOT NULL,
    operacion character varying(15) NOT NULL,
    stamp timestamp without time zone NOT NULL,
    user_id text NOT NULL,
    nombre_tabla character varying(50) NOT NULL,
    datos_nuevos text,
    datos_viejos text
);
    DROP TABLE public.log;
       public         postgres    false            �            1259    33802    log_id_log_seq    SEQUENCE     �   ALTER TABLE public.log ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.log_id_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    207            �            1259    33804    matricula_codigo_matricula_seq    SEQUENCE     �   ALTER TABLE public.matricula ALTER COLUMN codigo_matricula ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.matricula_codigo_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    200            �            1259    33806    profesor    TABLE        CREATE TABLE public.profesor (
    rut character varying(12) NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    correo character varying(50) NOT NULL,
    telefono character varying(15) NOT NULL,
    estado integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.profesor;
       public         postgres    false            �            1259    33939    profesor_seguridad    TABLE     �   CREATE TABLE public.profesor_seguridad (
    profesor_id integer NOT NULL,
    contrasena character varying(20) DEFAULT '123456'::character varying NOT NULL,
    ref_profesor character varying(12)
);
 &   DROP TABLE public.profesor_seguridad;
       public         postgres    false            �            1259    33937 "   profesor_seguridad_profesor_id_seq    SEQUENCE     �   ALTER TABLE public.profesor_seguridad ALTER COLUMN profesor_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.profesor_seguridad_profesor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    212                       2606    33811    alumno alumno_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_pkey PRIMARY KEY (matricula_id);
 <   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_pkey;
       public         postgres    false    196                       2606    33813    alumno alumno_rut_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_rut_key UNIQUE (rut);
 ?   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_rut_key;
       public         postgres    false    196            +           2606    33957 &   alumno_seguridad alumno_seguridad_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.alumno_seguridad
    ADD CONSTRAINT alumno_seguridad_pkey PRIMARY KEY (alumno_id);
 P   ALTER TABLE ONLY public.alumno_seguridad DROP CONSTRAINT alumno_seguridad_pkey;
       public         postgres    false    214                       2606    33815    curso curso_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (codigo);
 :   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_pkey;
       public         postgres    false    197            !           2606    33817    evaluacion evaluacion_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_pkey PRIMARY KEY (codigo);
 D   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_pkey;
       public         postgres    false    202                       2606    33819 $   instancia_curso instancia_curso_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_pkey;
       public         postgres    false    199            #           2606    33821 .   instancia_evaluacion instancia_evaluacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_pkey PRIMARY KEY (codigo_intancia_evaluacion);
 X   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_pkey;
       public         postgres    false    205            %           2606    33823    log log_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id_log);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public         postgres    false    207                       2606    33825    matricula matricula_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_pkey PRIMARY KEY (codigo_matricula);
 B   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_pkey;
       public         postgres    false    200            '           2606    33827    profesor profesor_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.profesor
    ADD CONSTRAINT profesor_pkey PRIMARY KEY (rut);
 @   ALTER TABLE ONLY public.profesor DROP CONSTRAINT profesor_pkey;
       public         postgres    false    210            )           2606    33944 *   profesor_seguridad profesor_seguridad_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.profesor_seguridad
    ADD CONSTRAINT profesor_seguridad_pkey PRIMARY KEY (profesor_id);
 T   ALTER TABLE ONLY public.profesor_seguridad DROP CONSTRAINT profesor_seguridad_pkey;
       public         postgres    false    212            =           2620    33828 +   evaluacion actualizar_evaluacion_por_alumno    TRIGGER     �   CREATE TRIGGER actualizar_evaluacion_por_alumno AFTER UPDATE ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.cursor_actualizar_evaluacion_por_alumno();
 D   DROP TRIGGER actualizar_evaluacion_por_alumno ON public.evaluacion;
       public       postgres    false    243    202            :           2620    33829 :   instancia_curso actualizar_vista_cursos_dados_por_profesor    TRIGGER     �   CREATE TRIGGER actualizar_vista_cursos_dados_por_profesor AFTER INSERT OR DELETE OR UPDATE ON public.instancia_curso FOR EACH ROW EXECUTE PROCEDURE public.refresh_vista_cursos_dados_por_profesor();
 S   DROP TRIGGER actualizar_vista_cursos_dados_por_profesor ON public.instancia_curso;
       public       postgres    false    199    276            <           2620    33830 6   matricula actualizar_vista_cursos_inscritos_por_alumno    TRIGGER     �   CREATE TRIGGER actualizar_vista_cursos_inscritos_por_alumno AFTER INSERT OR DELETE OR UPDATE ON public.matricula FOR EACH ROW EXECUTE PROCEDURE public.refresh_vista_cursos_inscritos_por_alumno();
 O   DROP TRIGGER actualizar_vista_cursos_inscritos_por_alumno ON public.matricula;
       public       postgres    false    277    200            >           2620    33831 (   evaluacion agregar_evaluacion_por_alumno    TRIGGER     �   CREATE TRIGGER agregar_evaluacion_por_alumno AFTER INSERT ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.cursor_agregar_evaluacion_por_alumno();
 A   DROP TRIGGER agregar_evaluacion_por_alumno ON public.evaluacion;
       public       postgres    false    244    202            8           2620    33832    alumno agregar_log_alumno    TRIGGER     �   CREATE TRIGGER agregar_log_alumno AFTER INSERT OR DELETE OR UPDATE ON public.alumno FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 2   DROP TRIGGER agregar_log_alumno ON public.alumno;
       public       postgres    false    274    196            D           2620    33963 -   alumno_seguridad agregar_log_alumno_seguridad    TRIGGER     �   CREATE TRIGGER agregar_log_alumno_seguridad AFTER INSERT OR DELETE OR UPDATE ON public.alumno_seguridad FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 F   DROP TRIGGER agregar_log_alumno_seguridad ON public.alumno_seguridad;
       public       postgres    false    214    274            9           2620    33833    curso agregar_log_curso    TRIGGER     �   CREATE TRIGGER agregar_log_curso AFTER INSERT OR DELETE OR UPDATE ON public.curso FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 0   DROP TRIGGER agregar_log_curso ON public.curso;
       public       postgres    false    197    274            ?           2620    33834 !   evaluacion agregar_log_evaluacion    TRIGGER     �   CREATE TRIGGER agregar_log_evaluacion AFTER INSERT OR DELETE OR UPDATE ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 :   DROP TRIGGER agregar_log_evaluacion ON public.evaluacion;
       public       postgres    false    274    202            ;           2620    33835 +   instancia_curso agregar_log_instancia_curso    TRIGGER     �   CREATE TRIGGER agregar_log_instancia_curso AFTER INSERT OR DELETE OR UPDATE ON public.instancia_curso FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 D   DROP TRIGGER agregar_log_instancia_curso ON public.instancia_curso;
       public       postgres    false    274    199            @           2620    33836 5   instancia_evaluacion agregar_log_instancia_evaluacion    TRIGGER     �   CREATE TRIGGER agregar_log_instancia_evaluacion AFTER INSERT OR DELETE OR UPDATE ON public.instancia_evaluacion FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 N   DROP TRIGGER agregar_log_instancia_evaluacion ON public.instancia_evaluacion;
       public       postgres    false    205    274            B           2620    33837    profesor agregar_log_profesor    TRIGGER     �   CREATE TRIGGER agregar_log_profesor AFTER INSERT OR DELETE OR UPDATE ON public.profesor FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 6   DROP TRIGGER agregar_log_profesor ON public.profesor;
       public       postgres    false    274    210            C           2620    33964 1   profesor_seguridad agregar_log_profesor_seguridad    TRIGGER     �   CREATE TRIGGER agregar_log_profesor_seguridad AFTER INSERT OR DELETE OR UPDATE ON public.profesor_seguridad FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 J   DROP TRIGGER agregar_log_profesor_seguridad ON public.profesor_seguridad;
       public       postgres    false    274    212            A           2620    33838 &   instancia_evaluacion modificacion_nota    TRIGGER     �   CREATE TRIGGER modificacion_nota AFTER UPDATE OF nota ON public.instancia_evaluacion FOR EACH ROW EXECUTE PROCEDURE public.actualizar_promedio();
 ?   DROP TRIGGER modificacion_nota ON public.instancia_evaluacion;
       public       postgres    false    233    205    205            7           2606    33958 1   alumno_seguridad alumno_seguridad_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alumno_seguridad
    ADD CONSTRAINT alumno_seguridad_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 [   ALTER TABLE ONLY public.alumno_seguridad DROP CONSTRAINT alumno_seguridad_ref_alumno_fkey;
       public       postgres    false    214    2839    196            ,           2606    33839 '   curso curso_ref_profesor_encargado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_ref_profesor_encargado_fkey FOREIGN KEY (ref_profesor_encargado) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_ref_profesor_encargado_fkey;
       public       postgres    false    2855    210    197            1           2606    33844 .   evaluacion evaluacion_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 X   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_instancia_curso_fkey;
       public       postgres    false    202    199    2845            2           2606    33849 '   evaluacion evaluacion_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_profesor_fkey;
       public       postgres    false    210    2855    202            -           2606    33854 .   instancia_curso instancia_curso_ref_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_curso_fkey FOREIGN KEY (ref_curso) REFERENCES public.curso(codigo);
 X   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_curso_fkey;
       public       postgres    false    197    199    2843            .           2606    33859 1   instancia_curso instancia_curso_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 [   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_profesor_fkey;
       public       postgres    false    2855    199    210            3           2606    33864 9   instancia_evaluacion instancia_evaluacion_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 c   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_alumno_fkey;
       public       postgres    false    205    196    2839            4           2606    33869 =   instancia_evaluacion instancia_evaluacion_ref_evaluacion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_evaluacion_fkey FOREIGN KEY (ref_evaluacion) REFERENCES public.evaluacion(codigo);
 g   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_evaluacion_fkey;
       public       postgres    false    202    205    2849            5           2606    33874 B   instancia_evaluacion instancia_evaluacion_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 l   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_instancia_curso_fkey;
       public       postgres    false    2845    199    205            /           2606    33879 #   matricula matricula_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 M   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_alumno_fkey;
       public       postgres    false    200    2839    196            0           2606    33884 ,   matricula matricula_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 V   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_instancia_curso_fkey;
       public       postgres    false    199    2845    200            6           2606    33945 7   profesor_seguridad profesor_seguridad_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profesor_seguridad
    ADD CONSTRAINT profesor_seguridad_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 a   ALTER TABLE ONLY public.profesor_seguridad DROP CONSTRAINT profesor_seguridad_ref_profesor_fkey;
       public       postgres    false    212    210    2855           