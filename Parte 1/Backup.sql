PGDMP     0    #        
        w            registro_notas    11.4    11.4 h    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    25347    registro_notas    DATABASE     �   CREATE DATABASE registro_notas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE registro_notas;
             postgres    false            �           1247    25436    area_evaluacion    TYPE        CREATE TYPE public.area_evaluacion AS ENUM (
    'UNIDAD_1',
    'UNIDAD_2',
    'UNIDAD_3',
    'UNIDAD_4',
    'UNIDAD_5'
);
 "   DROP TYPE public.area_evaluacion;
       public       postgres    false            �           1247    25398    situacion_matricula    TYPE     T   CREATE TYPE public.situacion_matricula AS ENUM (
    'APROBADO',
    'REPROBADO'
);
 &   DROP TYPE public.situacion_matricula;
       public       postgres    false            �           1247    25422    tipo_evaluacion    TYPE     �   CREATE TYPE public.tipo_evaluacion AS ENUM (
    'PRUEBA',
    'PROYECTO',
    'LABORATORIO',
    'TAREA',
    'TRABAJOS',
    'INFORME'
);
 "   DROP TYPE public.tipo_evaluacion;
       public       postgres    false            �           1247    25375    tipo_semestre    TYPE     ?   CREATE TYPE public.tipo_semestre AS ENUM (
    '1',
    '2'
);
     DROP TYPE public.tipo_semestre;
       public       postgres    false                       1255    25523    actualizar_promedio()    FUNCTION     Q  CREATE FUNCTION public.actualizar_promedio() RETURNS trigger
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
       public       postgres    false            �            1255    25505 �   agregar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO alumno (matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo,telefono) 
  VALUES (_matricula, _rut, _nombre, _apellido_paterno, _apellido_materno, _correo, _telefono);
END;
$$;
 �   DROP PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying);
       public       postgres    false            �            1255    25508 3   agregar_curso(character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
	VALUES (_nombre, 'COMUN', _ref_profesor_encargado);
END;
$$;
 k   DROP PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    25507 F   agregar_curso(character varying, character varying, character varying) 	   PROCEDURE     -  CREATE PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
  	VALUES (_nombre, _carrera, _ref_profesor_encargado);
END;
$$;
 �   DROP PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    25510 h   agregar_instancia(integer, character varying, character varying, integer, integer, public.tipo_semestre) 	   PROCEDURE     �  CREATE PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre)
    LANGUAGE plpgsql
    AS $$
BEGIN
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
END;
$$;
 �   DROP PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre);
       public       postgres    false    666            �            1255    25519    alumno_habilitado(integer)    FUNCTION     H  CREATE FUNCTION public.alumno_habilitado(_matricula integer) RETURNS integer
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
       public       postgres    false            �            1255    25532 2   asignar_profesor_curso(character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.asignar_profesor_curso(_rut_profesor character varying, _id_instancia integer)
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
       public       postgres    false            �            1255    25514 8   calcular_nota_final(integer, character varying, integer) 	   PROCEDURE     m
  CREATE PROCEDURE public.calcular_nota_final(id_alumno integer, nombre_curso character varying, periodo_curso integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	promedio_final INTEGER default 0;
	id_curso INTEGER default 0;
	valor_verificar_situacion INTEGER default 0;
BEGIN
	SELECT DISTINCT instancia_curso.id
	FROM alumno, instancia_curso, evaluacion, curso, instancia_evaluacion
	WHERE alumno.matricula_id=instancia_evaluacion.ref_alumno
	AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo		
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo 
	AND curso.nombre=nombre_curso		
	AND instancia_curso.periodo=periodo_curso
	AND alumno.matricula_id=id_alumno INTO id_curso;

	IF ((SELECT cursor_verificar_porcentaje(id_curso)) = 1) THEN	
		IF (SELECT verificar_instancia_evaluacion(id_curso, id_alumno)) THEN						
			SELECT SUM(T2.nota) AS Promedio_final
			FROM (SELECT ((T1.evaluacion * T1.porcentaje)/100) AS nota
				FROM (
					SELECT matricula_id AS matricula_alumno, 
					alumno.nombre AS alumno, curso.nombre AS curso, 
					seccion, nota AS evaluacion, porcentaje
					FROM alumno, instancia_curso, evaluacion, curso, instancia_evaluacion
					WHERE alumno.matricula_id=id_alumno
					AND curso.nombre=nombre_curso			
					AND instancia_curso.periodo=periodo_curso			
					AND alumno.matricula_id=instancia_evaluacion.ref_alumno
					AND instancia_evaluacion.ref_evaluacion=evaluacion.codigo
					AND evaluacion.ref_instancia_curso=instancia_curso.id
					AND instancia_curso.ref_curso=curso.codigo) AS T1) AS T2 INTO promedio_final;				

			IF (promedio_final > 39) THEN
				SELECT cursor_verificar_situacion(
					id_alumno,id_curso) INTO valor_verificar_situacion;
				IF (valor_verificar_situacion = 1) THEN
					UPDATE matricula
					SET nota_final=39, situacion='REPROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_curso;
					RAISE NOTICE 'Alumno reprovado porque una evaluación exigible tiene nota menor a 40, se le modifica el promedio a nota 39';
				ELSE
					UPDATE matricula
					SET nota_final=promedio_final, situacion='APROBADO'
					WHERE matricula.ref_alumno=id_alumno 
					AND matricula.ref_instancia_curso=id_curso;
					RAISE NOTICE 'Alumno aprobado con nota %', promedio_final;
				END IF;
			ELSE
				UPDATE matricula
				SET nota_final=promedio_final, situacion='REPROBADO'
				WHERE matricula.ref_alumno=id_alumno 
				AND matricula.ref_instancia_curso=id_curso;
				RAISE NOTICE 'Alumno reprobado con promedio %', promedio_final;
			END IF;			
		ELSE
			RAISE NOTICE 'No hay evaluaciones en el curso';		
		END IF;	
	END IF;	
END;
$$;
 u   DROP PROCEDURE public.calcular_nota_final(id_alumno integer, nombre_curso character varying, periodo_curso integer);
       public       postgres    false                       1255    25605 3   consulta_vista_cursos_inscritos_por_alumno(integer)    FUNCTION     ^  CREATE FUNCTION public.consulta_vista_cursos_inscritos_por_alumno(_matricula_id integer) RETURNS TABLE(id_instancia integer, nombre_del_curso character varying, seccion character varying, anio integer, semestre public.tipo_semestre, nombre_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT cursos_de_alumno.id_instancia,
	cursos_de_alumno.nombre_del_curso,
	cursos_de_alumno.seccion,
	cursos_de_alumno.anio,
	cursos_de_alumno.semestre,
	cursos_de_alumno.nombre_profesor_encargado
	FROM cursos_de_alumno
	WHERE cursos_de_alumno.alumno=_matricula_id;
END;
$$;
 X   DROP FUNCTION public.consulta_vista_cursos_inscritos_por_alumno(_matricula_id integer);
       public       postgres    false    666                       1255    25603 ,   creacion_vista_cursos_inscritos_por_alumno()    FUNCTION     v  CREATE FUNCTION public.creacion_vista_cursos_inscritos_por_alumno() RETURNS void
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
	matricula.ref_alumno AS alumno
	FROM matricula, instancia_curso, curso
	WHERE matricula.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo
    WITH DATA');
END;
$$;
 C   DROP FUNCTION public.creacion_vista_cursos_inscritos_por_alumno();
       public       postgres    false            �            1255    25512 �   crear_evaluacion(date, integer, integer, public.area_evaluacion, public.tipo_evaluacion, character varying, character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	cursor_porcentaje CURSOR FOR SELECT porcentaje_restante
								FROM instancia_curso
								WHERE instancia_curso.id = _ref_instancia_curso;
	valor RECORD; 
BEGIN
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
END;
$$;
 �   DROP PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area public.area_evaluacion, _tipo public.tipo_evaluacion, _prorroga character varying, _ref_profesor character varying, _ref_instancia_curso integer);
       public       postgres    false    683    680            �            1255    25542 4   crear_instancia_evaluacion(integer, bigint, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.crear_instancia_evaluacion(_ref_alumno integer, _ref_evaluacion bigint, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
	INSERT INTO instancia_evaluacion(ref_alumno, ref_evaluacion, ref_instancia_curso) 
	VALUES (_ref_alumno, _ref_evaluacion, _ref_instancia_curso);
	RAISE NOTICE 'La instancia evaluación fue registrada correctamente';    
END;
$$;
 }   DROP PROCEDURE public.crear_instancia_evaluacion(_ref_alumno integer, _ref_evaluacion bigint, _ref_instancia_curso integer);
       public       postgres    false            �            1255    25498 &   cursor_agregar_evaluacion_por_alumno()    FUNCTION     {  CREATE FUNCTION public.cursor_agregar_evaluacion_por_alumno() RETURNS trigger
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
       public       postgres    false            �            1255    25500 $   cursor_verificar_porcentaje(integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_porcentaje(_id_instancia integer) RETURNS integer
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
       public       postgres    false            �            1255    25501 #   cursor_verificar_situacion(integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_situacion(_id_instancia integer) RETURNS integer
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
       public       postgres    false            �            1255    25547 ,   cursor_verificar_situacion(integer, integer)    FUNCTION     �  CREATE FUNCTION public.cursor_verificar_situacion(_ref_alumno integer, _ref_instancia_curso integer) RETURNS integer
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
       public       postgres    false            �            1255    25502    deshabilitar_alumno(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_alumno(_matricula_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE alumno SET estado=0 WHERE alumno.matricula_id=_matricula_id;
END;
$$;
 B   DROP PROCEDURE public.deshabilitar_alumno(_matricula_id integer);
       public       postgres    false            �            1255    25503    deshabilitar_profesor(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_profesor(_rut integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE profesor SET estado=0 WHERE profesor.rut=_rut;
END;
$$;
 ;   DROP PROCEDURE public.deshabilitar_profesor(_rut integer);
       public       postgres    false            �            1255    25504 !   eliminar_instancia_curso(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_instancia_curso(_id_instancia integer)
    LANGUAGE plpgsql
    AS $$
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
$$;
 G   DROP PROCEDURE public.eliminar_instancia_curso(_id_instancia integer);
       public       postgres    false            �            1255    25511 !   inscribir_curso(integer, integer) 	   PROCEDURE     g  CREATE PROCEDURE public.inscribir_curso(_ref_alumno integer, _ref_curso integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	IF(alumno_habilitado(_ref_alumno) = 1) THEN
		IF(num_alumnos < 40) THEN
		    INSERT INTO matricula(ref_alumno, ref_instancia_curso, situacion, nota_final) 
		    VALUES (_ref_alumno, _ref_curso, NULL, 0);

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
       public       postgres    false                       1255    25552    lista_alumnos()    FUNCTION     �  CREATE FUNCTION public.lista_alumnos() RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
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
       public       postgres    false                       1255    25565 )   lista_alumnos_en_instancia_curso(integer)    FUNCTION     K  CREATE FUNCTION public.lista_alumnos_en_instancia_curso(_id integer) RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
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
       public       postgres    false                       1255    25554    lista_curso_con_instancias()    FUNCTION     �  CREATE FUNCTION public.lista_curso_con_instancias() RETURNS TABLE(seccion_id integer, nombre_curso character varying, seccion character varying, periodo integer, anio integer, semestre public.tipo_semestre, porcentaje_restante integer, profesor_rut character varying, nombre_profesor character varying, apellido character varying)
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
       public       postgres    false    666                       1255    25551    lista_cursos()    FUNCTION     J  CREATE FUNCTION public.lista_cursos() RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
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
       public       postgres    false                       1255    25548    lista_cursos(integer)    FUNCTION       CREATE FUNCTION public.lista_cursos(_rut_profesor integer) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
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
       public       postgres    false                       1255    25549    lista_cursos(character varying)    FUNCTION     �  CREATE FUNCTION public.lista_cursos(_rut_profesor character varying) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_rut character varying, profesor_nombre character varying, profesor_apellido character varying)
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
       public       postgres    false                       1255    25563 /   lista_evaluaciones_por_instancia_curso(integer)    FUNCTION     8  CREATE FUNCTION public.lista_evaluaciones_por_instancia_curso(_id integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
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
       public       postgres    false    683    680                       1255    25564 C   lista_evaluaciones_por_instancia_curso_por_alumno(integer, integer)    FUNCTION     �  CREATE FUNCTION public.lista_evaluaciones_por_instancia_curso_por_alumno(_id integer, _matricula_id integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
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
	FROM evaluacion, instancia_curso, matricula
	WHERE evaluacion.ref_instancia_curso=instancia_curso.id
	AND evaluacion.ref_instancia_curso=_id
	AND matricula.ref_instancia_curso=_id
	AND matricula.ref_alumno=_matricula_id;
END;
$$;
 l   DROP FUNCTION public.lista_evaluaciones_por_instancia_curso_por_alumno(_id integer, _matricula_id integer);
       public       postgres    false    680    683                       1255    25553    lista_profesores()    FUNCTION       CREATE FUNCTION public.lista_profesores() RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, correo_profesor character varying, telefono_profesor character varying, estado_profesor integer)
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
       public       postgres    false            �            1255    25525 �   modificar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.modificar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying)
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
       public       postgres    false            �            1255    25527 Q   modificar_curso(integer, character varying, character varying, character varying) 	   PROCEDURE     W  CREATE PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
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
       public       postgres    false            �            1255    25530 �   modificar_evaluacion(bigint, date, integer, integer, character varying, character varying, character varying, character varying, integer, integer) 	   PROCEDURE     I  CREATE PROCEDURE public.modificar_evaluacion(_codigo bigint, _fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer)
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
			ref_alumno = _ref_alumno,
			ref_instancia_curso = _ref_instancia_curso
		WHERE codigo = _codigo;
		RAISE NOTICE 'La evaluación fue modificada correctamente';
	ELSE
		RAISE NOTICE 'No se modificar la evaluación porque el porcentaje no está en el rango [1,100]';		
	END IF;	    
END;
$$;
   DROP PROCEDURE public.modificar_evaluacion(_codigo bigint, _fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false            �            1255    25528 s   modificar_instancia(integer, integer, character varying, character varying, integer, integer, public.tipo_semestre) 	   PROCEDURE     �  CREATE PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE instancia_curso
	SET periodo = _periodo,
		seccion = _seccion,
		ref_profesor = _ref_profesor,
		ref_curso = _ref_curso,
		anio = _anio,
		semestre = _semestre
	WHERE id = _id;
END;
$$;
 �   DROP PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer, _anio integer, _semestre public.tipo_semestre);
       public       postgres    false    666            �            1255    25529 7   modificar_matricula(integer, integer, integer, integer) 	   PROCEDURE     g  CREATE PROCEDURE public.modificar_matricula(_codigo_matricula integer, _ref_alumno integer, _ref_instancia_curso integer, _nota_final integer)
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
       public       postgres    false            �            1255    25531 2   modificar_nota(integer, integer, integer, integer) 	   PROCEDURE     o  CREATE PROCEDURE public.modificar_nota(_nota integer, _ref_evaluacion integer, _ref_alumno integer, _ref_instancia_curso integer)
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
       public       postgres    false            �            1255    25526 q   modificar_profesor(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     w  CREATE PROCEDURE public.modificar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying)
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
       public       postgres    false                        1255    25555    mostrar_alumno_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_alumno_por_pk(_matricula_id integer) RETURNS TABLE(matricula integer, rut character varying, nombre_alumno character varying, apellido_paterno character varying, apellido_materno character varying, correo_alumno character varying, telefono_alumno character varying, estado_alumno integer)
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
       public       postgres    false            �            1255    25557    mostrar_curso_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_curso_por_pk(_codigo integer) RETURNS TABLE(codigo_curso integer, nombre_curso character varying, carrera_curso character varying, profesor_encargado character varying)
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
       public       postgres    false            
           1255    25559 "   mostrar_evaluacion_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_evaluacion_por_pk(_codigo integer) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
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
       public       postgres    false    680    683                       1255    25560 !   mostrar_evaluacion_por_pk(bigint)    FUNCTION     �  CREATE FUNCTION public.mostrar_evaluacion_por_pk(_codigo bigint) RETURNS TABLE(codigo bigint, fecha date, porcentaje integer, exigible integer, area public.area_evaluacion, tipo public.tipo_evaluacion, prorroga character varying, ref_profesor character varying, ref_instancia_curso integer)
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
       public       postgres    false    683    680            	           1255    25558 '   mostrar_instancia_curso_por_pk(integer)    FUNCTION     �  CREATE FUNCTION public.mostrar_instancia_curso_por_pk(_id integer) RETURNS TABLE(id integer, periodo integer, seccion character varying, anio integer, semestre public.tipo_semestre, ref_profesor character varying, ref_curso integer, porcentaje_restante integer)
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
       public       postgres    false    666                       1255    25561 +   mostrar_instancia_evaluacion_por_pk(bigint)    FUNCTION     �  CREATE FUNCTION public.mostrar_instancia_evaluacion_por_pk(_codigo_intancia_evaluacion bigint) RETURNS TABLE(codigo_intancia_evaluacion bigint, ref_alumno integer, ref_evaluacion bigint, nota integer, ref_instancia_curso integer)
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
       public       postgres    false                       1255    25562 !   mostrar_matricula_por_pk(integer)    FUNCTION     ?  CREATE FUNCTION public.mostrar_matricula_por_pk(_codigo_matricula integer) RETURNS TABLE(codigo_matricula integer, nota_final integer, ref_alumno integer, ref_instancia_curso integer, situacion public.situacion_matricula)
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
       public       postgres    false    673                       1255    25556 *   mostrar_profesor_por_pk(character varying)    FUNCTION     F  CREATE FUNCTION public.mostrar_profesor_por_pk(_rut character varying) RETURNS TABLE(rut character varying, nombre_profesor character varying, apellido character varying, correo_profesor character varying, telefono_profesor character varying, estado_profesor integer)
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
       public       postgres    false            �            1255    25517 .   notas_alumno_curso(integer, character varying)    FUNCTION     w  CREATE FUNCTION public.notas_alumno_curso(_matricula integer, _nombre_curso character varying) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
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
       public       postgres    false            �            1255    25516    notas_alumno_todas(integer)    FUNCTION     6  CREATE FUNCTION public.notas_alumno_todas(_matricula integer) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
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
       public       postgres    false            �            1255    25518 $   numero_alumnos_matriculados(integer)    FUNCTION     �  CREATE FUNCTION public.numero_alumnos_matriculados(_id_instancia integer) RETURNS integer
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
       public       postgres    false            �            1255    25533    proceso_agregar_log()    FUNCTION     �  CREATE FUNCTION public.proceso_agregar_log() RETURNS trigger
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
       public       postgres    false            �            1255    25520 &   profesor_habilitado(character varying)    FUNCTION     ^  CREATE FUNCTION public.profesor_habilitado(_rut_profesor character varying) RETURNS integer
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
       public       postgres    false                       1255    25604 +   refresh_vista_cursos_inscritos_por_alumno()    FUNCTION     �   CREATE FUNCTION public.refresh_vista_cursos_inscritos_por_alumno() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN   
    REFRESH MATERIALIZED VIEW cursos_de_alumno;
END;
$$;
 B   DROP FUNCTION public.refresh_vista_cursos_inscritos_por_alumno();
       public       postgres    false            �            1255    25506 q   registrar_profesor(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     \  CREATE PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO profesor (rut, nombre, apellido, correo, telefono) 
  VALUES (_rut, _nombre, _apellido, _correo, _telefono);
END;
$$;
 �   DROP PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying);
       public       postgres    false            �            1255    25509 ,   verificar_existe_profesor_encargado(integer)    FUNCTION     J  CREATE FUNCTION public.verificar_existe_profesor_encargado(_codigo integer) RETURNS integer
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
       public       postgres    false            �            1255    25515 0   verificar_instancia_evaluacion(integer, integer)    FUNCTION       CREATE FUNCTION public.verificar_instancia_evaluacion(_id_instancia integer, _id_alumno integer) RETURNS integer
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
       public       postgres    false            �            1259    25348    alumno    TABLE     ~  CREATE TABLE public.alumno (
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
       public         postgres    false            �            1259    25364    curso    TABLE     �   CREATE TABLE public.curso (
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    carrera character varying(50) NOT NULL,
    ref_profesor_encargado character varying(12)
);
    DROP TABLE public.curso;
       public         postgres    false            �            1259    25362    curso_codigo_seq    SEQUENCE     �   ALTER TABLE public.curso ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.curso_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    199            �            1259    25381    instancia_curso    TABLE     O  CREATE TABLE public.instancia_curso (
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
       public         postgres    false    666            �            1259    25405 	   matricula    TABLE     �   CREATE TABLE public.matricula (
    codigo_matricula integer NOT NULL,
    nota_final integer DEFAULT 0 NOT NULL,
    ref_alumno integer NOT NULL,
    ref_instancia_curso integer NOT NULL,
    situacion public.situacion_matricula
);
    DROP TABLE public.matricula;
       public         postgres    false    673            �            1259    25606    cursos_de_alumno    MATERIALIZED VIEW       CREATE MATERIALIZED VIEW public.cursos_de_alumno AS
 SELECT instancia_curso.id AS id_instancia,
    curso.nombre AS nombre_del_curso,
    instancia_curso.seccion,
    instancia_curso.anio,
    instancia_curso.semestre,
    curso.ref_profesor_encargado AS nombre_profesor_encargado,
    matricula.ref_alumno AS alumno
   FROM public.matricula,
    public.instancia_curso,
    public.curso
  WHERE ((matricula.ref_instancia_curso = instancia_curso.id) AND (instancia_curso.ref_curso = curso.codigo))
  WITH NO DATA;
 0   DROP MATERIALIZED VIEW public.cursos_de_alumno;
       public         postgres    false    199    201    201    201    201    201    203    203    199    199    666            �            1259    25449 
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
       public         postgres    false    683    680    680    683            �            1259    25447    evaluacion_codigo_seq    SEQUENCE     �   ALTER TABLE public.evaluacion ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evaluacion_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    205            �            1259    25379    instancia_curso_id_seq    SEQUENCE     �   ALTER TABLE public.instancia_curso ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instancia_curso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    201            �            1259    25468    instancia_evaluacion    TABLE     �   CREATE TABLE public.instancia_evaluacion (
    codigo_intancia_evaluacion bigint NOT NULL,
    ref_alumno integer NOT NULL,
    ref_evaluacion bigint NOT NULL,
    ref_instancia_curso integer NOT NULL,
    nota integer DEFAULT 0
);
 (   DROP TABLE public.instancia_evaluacion;
       public         postgres    false            �            1259    25466 3   instancia_evaluacion_codigo_intancia_evaluacion_seq    SEQUENCE       ALTER TABLE public.instancia_evaluacion ALTER COLUMN codigo_intancia_evaluacion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instancia_evaluacion_codigo_intancia_evaluacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    207            �            1259    25490    log    TABLE       CREATE TABLE public.log (
    id_log bigint NOT NULL,
    operacion character varying(15) NOT NULL,
    stamp timestamp without time zone NOT NULL,
    user_id text NOT NULL,
    nombre_tabla character varying(50) NOT NULL,
    datos_nuevos text,
    datos_viejos text
);
    DROP TABLE public.log;
       public         postgres    false            �            1259    25488    log_id_log_seq    SEQUENCE     �   ALTER TABLE public.log ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.log_id_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    209            �            1259    25403    matricula_codigo_matricula_seq    SEQUENCE     �   ALTER TABLE public.matricula ALTER COLUMN codigo_matricula ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.matricula_codigo_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    203            �            1259    25356    profesor    TABLE        CREATE TABLE public.profesor (
    rut character varying(12) NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    correo character varying(50) NOT NULL,
    telefono character varying(15) NOT NULL,
    estado integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.profesor;
       public         postgres    false            �
           2606    25353    alumno alumno_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_pkey PRIMARY KEY (matricula_id);
 <   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_pkey;
       public         postgres    false    196            �
           2606    25355    alumno alumno_rut_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_rut_key UNIQUE (rut);
 ?   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_rut_key;
       public         postgres    false    196            �
           2606    25368    curso curso_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (codigo);
 :   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_pkey;
       public         postgres    false    199            �
           2606    25455    evaluacion evaluacion_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_pkey PRIMARY KEY (codigo);
 D   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_pkey;
       public         postgres    false    205            �
           2606    25386 $   instancia_curso instancia_curso_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_pkey;
       public         postgres    false    201            �
           2606    25472 .   instancia_evaluacion instancia_evaluacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_pkey PRIMARY KEY (codigo_intancia_evaluacion);
 X   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_pkey;
       public         postgres    false    207                       2606    25497    log log_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id_log);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public         postgres    false    209            �
           2606    25410    matricula matricula_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_pkey PRIMARY KEY (codigo_matricula);
 B   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_pkey;
       public         postgres    false    203            �
           2606    25361    profesor profesor_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.profesor
    ADD CONSTRAINT profesor_pkey PRIMARY KEY (rut);
 @   ALTER TABLE ONLY public.profesor DROP CONSTRAINT profesor_pkey;
       public         postgres    false    197                       2620    25546 (   evaluacion agregar_evaluacion_por_alumno    TRIGGER     �   CREATE TRIGGER agregar_evaluacion_por_alumno AFTER INSERT ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.cursor_agregar_evaluacion_por_alumno();
 A   DROP TRIGGER agregar_evaluacion_por_alumno ON public.evaluacion;
       public       postgres    false    254    205                       2620    25534    alumno agregar_log_alumno    TRIGGER     �   CREATE TRIGGER agregar_log_alumno AFTER INSERT OR DELETE OR UPDATE ON public.alumno FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 2   DROP TRIGGER agregar_log_alumno ON public.alumno;
       public       postgres    false    250    196                       2620    25536    curso agregar_log_curso    TRIGGER     �   CREATE TRIGGER agregar_log_curso AFTER INSERT OR DELETE OR UPDATE ON public.curso FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 0   DROP TRIGGER agregar_log_curso ON public.curso;
       public       postgres    false    199    250                       2620    25537 !   evaluacion agregar_log_evaluacion    TRIGGER     �   CREATE TRIGGER agregar_log_evaluacion AFTER INSERT OR DELETE OR UPDATE ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 :   DROP TRIGGER agregar_log_evaluacion ON public.evaluacion;
       public       postgres    false    250    205                       2620    25539 +   instancia_curso agregar_log_instancia_curso    TRIGGER     �   CREATE TRIGGER agregar_log_instancia_curso AFTER INSERT OR DELETE OR UPDATE ON public.instancia_curso FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 D   DROP TRIGGER agregar_log_instancia_curso ON public.instancia_curso;
       public       postgres    false    201    250                       2620    25538 5   instancia_evaluacion agregar_log_instancia_evaluacion    TRIGGER     �   CREATE TRIGGER agregar_log_instancia_evaluacion AFTER INSERT OR DELETE OR UPDATE ON public.instancia_evaluacion FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 N   DROP TRIGGER agregar_log_instancia_evaluacion ON public.instancia_evaluacion;
       public       postgres    false    250    207                       2620    25540    matricula agregar_log_matricula    TRIGGER     �   CREATE TRIGGER agregar_log_matricula AFTER INSERT OR DELETE OR UPDATE ON public.matricula FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 8   DROP TRIGGER agregar_log_matricula ON public.matricula;
       public       postgres    false    250    203                       2620    25535    profesor agregar_log_profesor    TRIGGER     �   CREATE TRIGGER agregar_log_profesor AFTER INSERT OR DELETE OR UPDATE ON public.profesor FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 6   DROP TRIGGER agregar_log_profesor ON public.profesor;
       public       postgres    false    197    250                       2620    25544 &   instancia_evaluacion modificacion_nota    TRIGGER     �   CREATE TRIGGER modificacion_nota AFTER UPDATE OF nota ON public.instancia_evaluacion FOR EACH ROW EXECUTE PROCEDURE public.actualizar_promedio();
 ?   DROP TRIGGER modificacion_nota ON public.instancia_evaluacion;
       public       postgres    false    207    207    258                       2606    25369 '   curso curso_ref_profesor_encargado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_ref_profesor_encargado_fkey FOREIGN KEY (ref_profesor_encargado) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_ref_profesor_encargado_fkey;
       public       postgres    false    199    197    2805                       2606    25461 .   evaluacion evaluacion_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 X   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_instancia_curso_fkey;
       public       postgres    false    205    201    2809                       2606    25456 '   evaluacion evaluacion_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_profesor_fkey;
       public       postgres    false    197    2805    205                       2606    25392 .   instancia_curso instancia_curso_ref_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_curso_fkey FOREIGN KEY (ref_curso) REFERENCES public.curso(codigo);
 X   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_curso_fkey;
       public       postgres    false    2807    199    201                       2606    25387 1   instancia_curso instancia_curso_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 [   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_profesor_fkey;
       public       postgres    false    201    2805    197            	           2606    25473 9   instancia_evaluacion instancia_evaluacion_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 c   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_alumno_fkey;
       public       postgres    false    207    2801    196            
           2606    25478 =   instancia_evaluacion instancia_evaluacion_ref_evaluacion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_evaluacion_fkey FOREIGN KEY (ref_evaluacion) REFERENCES public.evaluacion(codigo);
 g   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_evaluacion_fkey;
       public       postgres    false    2813    207    205                       2606    25483 B   instancia_evaluacion instancia_evaluacion_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_evaluacion
    ADD CONSTRAINT instancia_evaluacion_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 l   ALTER TABLE ONLY public.instancia_evaluacion DROP CONSTRAINT instancia_evaluacion_ref_instancia_curso_fkey;
       public       postgres    false    201    2809    207                       2606    25411 #   matricula matricula_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 M   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_alumno_fkey;
       public       postgres    false    203    2801    196                       2606    25416 ,   matricula matricula_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 V   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_instancia_curso_fkey;
       public       postgres    false    201    2809    203           