PGDMP                         w            registro_notas    11.2    11.2 P    h           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            i           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            j           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            k           1262    24681    registro_notas    DATABASE     �   CREATE DATABASE registro_notas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE registro_notas;
             postgres    false            �           1247    25139    situacion_matricula    TYPE     T   CREATE TYPE public.situacion_matricula AS ENUM (
    'APROBADO',
    'REPROBADO'
);
 &   DROP TYPE public.situacion_matricula;
       public       postgres    false            �           1247    25145    tipo_semestre    TYPE     ?   CREATE TYPE public.tipo_semestre AS ENUM (
    '1',
    '2'
);
     DROP TYPE public.tipo_semestre;
       public       postgres    false            �            1255    24908    actualizacion_nota()    FUNCTION     �   CREATE FUNCTION public.actualizacion_nota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Se actualizo una nota del alumno';
    RETURN NEW;
END ;
$$;
 +   DROP FUNCTION public.actualizacion_nota();
       public       postgres    false            �            1255    25190    actualizar_promedio()    FUNCTION     �  CREATE FUNCTION public.actualizar_promedio() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 ,   DROP FUNCTION public.actualizar_promedio();
       public       postgres    false            �            1255    24901 �   agregar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO alumno (matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo,telefono) 
  VALUES (_matricula, _rut, _nombre, _apellido_paterno, _apellido_materno, _correo, _telefono);
END;
$$;
 �   DROP PROCEDURE public.agregar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying);
       public       postgres    false            �            1255    25132 3   agregar_curso(character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
	VALUES (_nombre, 'COMUN', _ref_profesor_encargado);
END;
$$;
 k   DROP PROCEDURE public.agregar_curso(_nombre character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    25131 F   agregar_curso(character varying, character varying, character varying) 	   PROCEDURE     -  CREATE PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  	INSERT INTO curso (nombre, carrera, ref_profesor_encargado)
  	VALUES (_nombre, _carrera, _ref_profesor_encargado);
END;
$$;
 �   DROP PROCEDURE public.agregar_curso(_nombre character varying, _carrera character varying, _ref_profesor_encargado character varying);
       public       postgres    false            �            1255    24904 I   agregar_instancia(integer, character varying, character varying, integer) 	   PROCEDURE     <  CREATE PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (SELECT verificar_existe_profesor_encargado(_ref_curso) = 1) THEN
		INSERT INTO instancia_curso(periodo, seccion, ref_profesor, ref_curso) 
    	VALUES (_periodo, _seccion, _ref_profesor, _ref_curso);
		RAISE NOTICE 'Instancia curso creada exitosamente';
	ELSE
		RAISE NOTICE 'No se pudo crear la instancia del curso porque el curso base no tiene profesor encargado';
	END IF;    
END;
$$;
 �   DROP PROCEDURE public.agregar_instancia(_periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer);
       public       postgres    false            �            1255    25156    alumno_habilitado(integer)    FUNCTION     H  CREATE FUNCTION public.alumno_habilitado(_matricula integer) RETURNS integer
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
       public       postgres    false            �            1255    25159 2   asignar_profesor_curso(character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.asignar_profesor_curso(_rut_profesor character varying, _id_instancia integer)
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
       public       postgres    false            �            1255    24900 8   calcular_nota_final(integer, character varying, integer) 	   PROCEDURE       CREATE PROCEDURE public.calcular_nota_final(id_alumno integer, nombre_curso character varying, periodo_curso integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	promedio_final INTEGER default 0;
	id_curso INTEGER default 0;
BEGIN

	SELECT DISTINCT instancia_curso.id
	FROM alumno, instancia_curso, evaluacion, curso
	WHERE alumno.matricula_id=evaluacion.ref_alumno		
	AND alumno.matricula_id=evaluacion.ref_alumno 
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo 
	AND curso.nombre=nombre_curso		
	AND instancia_curso.periodo=periodo_curso
	AND alumno.matricula_id=id_alumno INTO id_curso;

	IF (SELECT verificar_instancia_evaluacion(id_curso)) THEN						
		SELECT SUM(T2.nota) AS Promedio_final
		FROM (SELECT ((T1.evaluacion * T1.porcentaje)/100) AS nota
			FROM (
				SELECT matricula_id AS matricula_alumno, 
				alumno.nombre AS alumno, curso.nombre AS curso, 
				seccion, nota AS evaluacion, porcentaje
				FROM alumno, instancia_curso, evaluacion, curso
				WHERE alumno.matricula_id=id_alumno
				AND curso.nombre=nombre_curso			
				AND instancia_curso.periodo=periodo_curso			
				AND alumno.matricula_id=evaluacion.ref_alumno 
				AND evaluacion.ref_instancia_curso=instancia_curso.id
				AND instancia_curso.ref_curso=curso.codigo) AS T1) AS T2 INTO promedio_final;				

		UPDATE matricula
		SET nota_final=promedio_final
		WHERE matricula.ref_alumno=id_alumno 
		AND matricula.ref_instancia_curso=id_curso;
	ELSE
		RAISE NOTICE 'No hay evaluaciones en el curso';		
	END IF;		
END;
$$;
 u   DROP PROCEDURE public.calcular_nota_final(id_alumno integer, nombre_curso character varying, periodo_curso integer);
       public       postgres    false            �            1255    25133 �   crear_evaluacion(date, integer, integer, character varying, character varying, character varying, character varying, integer, integer) 	   PROCEDURE       CREATE PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
	IF (_porcentaje>0 AND _porcentaje<101) THEN
		INSERT INTO evaluacion(fecha, porcentaje, exigible, area, tipo, prorroga, ref_profesor, ref_alumno,ref_instancia_curso) 
		VALUES (_fecha, _porcentaje, _exigible, _area, _tipo, _prorroga, _ref_profesor, _ref_alumno, _ref_instancia_curso);
		RAISE NOTICE 'La evaluación fue registrada correctamente';	
	ELSE
		RAISE NOTICE 'No se registró la evaluación porque el porcentaje no está en el rango [1,100]';		
	END IF;	    
END;
$$;
    DROP PROCEDURE public.crear_evaluacion(_fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false            �            1255    25100    deshabilitar_alumno(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_alumno(_matricula_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE alumno SET estado=0 WHERE alumno.matricula_id=_matricula_id;
END;
$$;
 B   DROP PROCEDURE public.deshabilitar_alumno(_matricula_id integer);
       public       postgres    false            �            1255    25102    deshabilitar_profesor(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.deshabilitar_profesor(_rut integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE profesor SET estado=0 WHERE profesor.rut=_rut;
END;
$$;
 ;   DROP PROCEDURE public.deshabilitar_profesor(_rut integer);
       public       postgres    false            �            1255    25152    eliminar_evaluacion(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_evaluacion(_id_evaluacion integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	nota integer default 0;
BEGIN
	SELECT COUNT(evaluacion.nota)
	FROM evaluacion
	WHERE evaluacion.codigo = _id_evaluacion INTO nota;

	IF(nota = 0) THEN
		DELETE FROM evaluacion WHERE evaluacion.codigo = _id_evaluacion;
	ELSE
		RAISE NOTICE 'No se puede eliminar la evaluacion';
	END IF;	
END;
$$;
 C   DROP PROCEDURE public.eliminar_evaluacion(_id_evaluacion integer);
       public       postgres    false            �            1255    25150 !   eliminar_instancia_curso(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_instancia_curso(_id_instancia integer)
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
       public       postgres    false            �            1255    25155 =   inscribir_curso(integer, integer, public.situacion_matricula) 	   PROCEDURE     �  CREATE PROCEDURE public.inscribir_curso(_ref_alumno integer, _ref_curso integer, _situacion public.situacion_matricula)
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	IF(alumno_habilitado(_ref_alumno) = 1) THEN
		IF(num_alumnos < 40) THEN
		    INSERT INTO matricula(ref_alumno, ref_instancia_curso, situacion, nota_final) 
		    VALUES (_ref_alumno, _ref_curso, _situacion, 0);

			RAISE NOTICE 'El alumno se ha inscrito correctamente en la seccion';
		ELSE
			RAISE NOTICE 'No quedan cupos disponibles en la seccion';
		END IF;
	ELSE
		RAISE NOTICE 'El alumno no esta habilitado para inscribirse en cursos';
	END IF;	
END;
$$;
 w   DROP PROCEDURE public.inscribir_curso(_ref_alumno integer, _ref_curso integer, _situacion public.situacion_matricula);
       public       postgres    false    653            �            1255    25103 �   modificar_alumno(integer, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.modificar_alumno(_matricula integer, _rut character varying, _nombre character varying, _apellido_paterno character varying, _apellido_materno character varying, _correo character varying, _telefono character varying)
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
       public       postgres    false            �            1255    25107 >   modificar_curso(integer, character varying, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
	UPDATE curso
	SET nombre = _nombre,
		carrera = _carrera
	WHERE curso.codigo = _codigo;
END;
$$;
 o   DROP PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying);
       public       postgres    false            �            1255    25130 Q   modificar_curso(integer, character varying, character varying, character varying) 	   PROCEDURE     W  CREATE PROCEDURE public.modificar_curso(_codigo integer, _nombre character varying, _carrera character varying, _ref_profesor_encargado character varying)
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
       public       postgres    false            �            1255    25114 �   modificar_evaluacion(integer, date, integer, integer, character varying, character varying, character varying, character varying, integer, integer) 	   PROCEDURE     J  CREATE PROCEDURE public.modificar_evaluacion(_codigo integer, _fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer)
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
   DROP PROCEDURE public.modificar_evaluacion(_codigo integer, _fecha date, _porcentaje integer, _exigible integer, _area character varying, _tipo character varying, _prorroga character varying, _ref_profesor character varying, _ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false            �            1255    25109 T   modificar_instancia(integer, integer, character varying, character varying, integer) 	   PROCEDURE     ^  CREATE PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE instancia_curso
	SET periodo = _periodo,
		seccion = _seccion,
		ref_profesor = _ref_profesor,
		ref_curso = _ref_curso
	WHERE id = _id;
END;
$$;
 �   DROP PROCEDURE public.modificar_instancia(_id integer, _periodo integer, _seccion character varying, _ref_profesor character varying, _ref_curso integer);
       public       postgres    false            �            1255    25112 7   modificar_matricula(integer, integer, integer, integer) 	   PROCEDURE     g  CREATE PROCEDURE public.modificar_matricula(_codigo_matricula integer, _ref_alumno integer, _ref_instancia_curso integer, _nota_final integer)
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
       public       postgres    false            �            1255    24907 2   modificar_nota(integer, integer, integer, integer) 	   PROCEDURE     ?  CREATE PROCEDURE public.modificar_nota(_nota integer, _ref_evaluacion integer, _ref_alumno integer, _ref_instancia_curso integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (_nota>9 AND _nota<71) THEN
		UPDATE evaluacion
		SET nota = _nota
		WHERE evaluacion.ref_alumno = _ref_alumno
		AND evaluacion.ref_instancia_curso = _ref_instancia_curso
		AND evaluacion.codigo = _ref_evaluacion;
		RAISE NOTICE 'Se modificó la nota correctamente a %', _nota;
	ELSE
		RAISE NOTICE 'No se pudo modificar la nota porque no está dentro del rango permitido [10,70]';
	END IF;    
END;
$$;
 �   DROP PROCEDURE public.modificar_nota(_nota integer, _ref_evaluacion integer, _ref_alumno integer, _ref_instancia_curso integer);
       public       postgres    false            �            1255    25105 q   modificar_profesor(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     w  CREATE PROCEDURE public.modificar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying)
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
       public       postgres    false            �            1255    25137 .   notas_alumno_curso(integer, character varying)    FUNCTION     W  CREATE FUNCTION public.notas_alumno_curso(_matricula integer, _nombre_curso character varying) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
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
	evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion
	WHERE alumno.matricula_id=2013407015
	AND curso.nombre=_nombre_curso
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$;
 ^   DROP FUNCTION public.notas_alumno_curso(_matricula integer, _nombre_curso character varying);
       public       postgres    false            �            1255    25136    notas_alumno_todas(integer)    FUNCTION       CREATE FUNCTION public.notas_alumno_todas(_matricula integer) RETURNS TABLE(matricula integer, nombre character varying, apellido_paterno character varying, curso character varying, seccion character varying, tipo_evaluacion character varying, nota integer)
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
	evaluacion.nota AS nota
	FROM alumno, curso, instancia_curso, evaluacion
	WHERE alumno.matricula_id=2013407015
	AND alumno.matricula_id=evaluacion.ref_alumno
	AND evaluacion.ref_instancia_curso=instancia_curso.id
	AND instancia_curso.ref_curso=curso.codigo;
END;
$$;
 =   DROP FUNCTION public.notas_alumno_todas(_matricula integer);
       public       postgres    false            �            1255    25151 $   numero_alumnos_matriculados(integer)    FUNCTION     �  CREATE FUNCTION public.numero_alumnos_matriculados(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	num_alumnos INTEGER default 0;
BEGIN
	SELECT COUNT(alumno.matricula_id)
	FROM instancia_curso, alumno, matricula
	WHERE instancia_curso.id = _id_instancia
	AND instancia_curso.id = matricula.ref_instancia_curso
	AND matricula.ref_alumno = alumno.matricula_id INTO num_alumnos;
	RETURN num_alumnos;
END;
$$;
 I   DROP FUNCTION public.numero_alumnos_matriculados(_id_instancia integer);
       public       postgres    false            �            1255    25171    proceso_agregar_log()    FUNCTION     &  CREATE FUNCTION public.proceso_agregar_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 ,   DROP FUNCTION public.proceso_agregar_log();
       public       postgres    false            �            1255    25157 &   profesor_habilitado(character varying)    FUNCTION     ^  CREATE FUNCTION public.profesor_habilitado(_rut_profesor character varying) RETURNS integer
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
       public       postgres    false            �            1255    24902 q   registrar_profesor(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     \  CREATE PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO profesor (rut, nombre, apellido, correo, telefono) 
  VALUES (_rut, _nombre, _apellido, _correo, _telefono);
END;
$$;
 �   DROP PROCEDURE public.registrar_profesor(_rut character varying, _nombre character varying, _apellido character varying, _correo character varying, _telefono character varying);
       public       postgres    false            �            1255    25129 ,   verificar_existe_profesor_encargado(integer)    FUNCTION     J  CREATE FUNCTION public.verificar_existe_profesor_encargado(_codigo integer) RETURNS integer
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
       public       postgres    false            �            1255    25118 '   verificar_instancia_evaluacion(integer)    FUNCTION     �  CREATE FUNCTION public.verificar_instancia_evaluacion(_id_instancia integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	cantidad_evaluaciones INTEGER default 0;
	_rec record;
BEGIN
    SELECT COUNT(evaluacion.codigo)
	FROM evaluacion, instancia_curso
	WHERE instancia_curso.id=evaluacion.ref_instancia_curso
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
 L   DROP FUNCTION public.verificar_instancia_evaluacion(_id_instancia integer);
       public       postgres    false            �            1259    24805    alumno    TABLE     ~  CREATE TABLE public.alumno (
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
       public         postgres    false            �            1259    24819    curso    TABLE     �   CREATE TABLE public.curso (
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    carrera character varying(50) NOT NULL,
    ref_profesor_encargado character varying(12)
);
    DROP TABLE public.curso;
       public         postgres    false            �            1259    24817    curso_codigo_seq    SEQUENCE     �   ALTER TABLE public.curso ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.curso_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    199            �            1259    24879 
   evaluacion    TABLE     �  CREATE TABLE public.evaluacion (
    codigo bigint NOT NULL,
    fecha date,
    porcentaje integer NOT NULL,
    exigible integer NOT NULL,
    area character varying(20) NOT NULL,
    tipo character varying(20) NOT NULL,
    prorroga character varying(255),
    nota integer,
    ref_profesor character varying(12) NOT NULL,
    ref_alumno integer NOT NULL,
    ref_instancia_curso integer NOT NULL
);
    DROP TABLE public.evaluacion;
       public         postgres    false            �            1259    24877    evaluacion_codigo_seq    SEQUENCE     �   ALTER TABLE public.evaluacion ALTER COLUMN codigo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.evaluacion_codigo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    205            �            1259    24826    instancia_curso    TABLE       CREATE TABLE public.instancia_curso (
    id integer NOT NULL,
    periodo integer NOT NULL,
    seccion character varying(2) NOT NULL,
    ref_profesor character varying(12),
    ref_curso integer NOT NULL,
    anio integer NOT NULL,
    semestre public.tipo_semestre NOT NULL
);
 #   DROP TABLE public.instancia_curso;
       public         postgres    false    656            �            1259    24824    instancia_curso_id_seq    SEQUENCE     �   ALTER TABLE public.instancia_curso ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instancia_curso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    201            �            1259    25162    log    TABLE     �   CREATE TABLE public.log (
    id_log bigint NOT NULL,
    stamp timestamp without time zone NOT NULL,
    user_id text NOT NULL,
    nombre_tabla character varying(50) NOT NULL,
    operacion character varying(15) NOT NULL
);
    DROP TABLE public.log;
       public         postgres    false            �            1259    25160    log_id_log_seq    SEQUENCE     �   ALTER TABLE public.log ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.log_id_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    207            �            1259    24850 	   matricula    TABLE     �   CREATE TABLE public.matricula (
    codigo_matricula integer NOT NULL,
    ref_alumno integer NOT NULL,
    ref_instancia_curso integer NOT NULL,
    situacion public.situacion_matricula,
    nota_final integer DEFAULT 0 NOT NULL
);
    DROP TABLE public.matricula;
       public         postgres    false    653            �            1259    24848    matricula_codigo_matricula_seq    SEQUENCE     �   ALTER TABLE public.matricula ALTER COLUMN codigo_matricula ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.matricula_codigo_matricula_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public       postgres    false    203            �            1259    24812    profesor    TABLE        CREATE TABLE public.profesor (
    rut character varying(12) NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    correo character varying(50) NOT NULL,
    telefono character varying(15) NOT NULL,
    estado integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.profesor;
       public         postgres    false            Z          0    24805    alumno 
   TABLE DATA               y   COPY public.alumno (matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo, telefono, estado) FROM stdin;
    public       postgres    false    196   ��       ]          0    24819    curso 
   TABLE DATA               P   COPY public.curso (codigo, nombre, carrera, ref_profesor_encargado) FROM stdin;
    public       postgres    false    199   k�       c          0    24879 
   evaluacion 
   TABLE DATA               �   COPY public.evaluacion (codigo, fecha, porcentaje, exigible, area, tipo, prorroga, nota, ref_profesor, ref_alumno, ref_instancia_curso) FROM stdin;
    public       postgres    false    205   ��       _          0    24826    instancia_curso 
   TABLE DATA               h   COPY public.instancia_curso (id, periodo, seccion, ref_profesor, ref_curso, anio, semestre) FROM stdin;
    public       postgres    false    201   ߢ       e          0    25162    log 
   TABLE DATA               N   COPY public.log (id_log, stamp, user_id, nombre_tabla, operacion) FROM stdin;
    public       postgres    false    207   ,�       a          0    24850 	   matricula 
   TABLE DATA               m   COPY public.matricula (codigo_matricula, ref_alumno, ref_instancia_curso, situacion, nota_final) FROM stdin;
    public       postgres    false    203   ƣ       [          0    24812    profesor 
   TABLE DATA               S   COPY public.profesor (rut, nombre, apellido, correo, telefono, estado) FROM stdin;
    public       postgres    false    197   �       l           0    0    curso_codigo_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.curso_codigo_seq', 6, true);
            public       postgres    false    198            m           0    0    evaluacion_codigo_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.evaluacion_codigo_seq', 7, true);
            public       postgres    false    204            n           0    0    instancia_curso_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.instancia_curso_id_seq', 5, true);
            public       postgres    false    200            o           0    0    log_id_log_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.log_id_log_seq', 2509, true);
            public       postgres    false    206            p           0    0    matricula_codigo_matricula_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.matricula_codigo_matricula_seq', 4, true);
            public       postgres    false    202            �
           2606    24809    alumno alumno_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_pkey PRIMARY KEY (matricula_id);
 <   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_pkey;
       public         postgres    false    196            �
           2606    24811    alumno alumno_rut_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_rut_key UNIQUE (rut);
 ?   ALTER TABLE ONLY public.alumno DROP CONSTRAINT alumno_rut_key;
       public         postgres    false    196            �
           2606    24823    curso curso_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_pkey PRIMARY KEY (codigo);
 :   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_pkey;
       public         postgres    false    199            �
           2606    24883    evaluacion evaluacion_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_pkey PRIMARY KEY (codigo);
 D   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_pkey;
       public         postgres    false    205            �
           2606    24830 $   instancia_curso instancia_curso_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_pkey;
       public         postgres    false    201            �
           2606    25169    log log_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id_log);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public         postgres    false    207            �
           2606    24854    matricula matricula_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_pkey PRIMARY KEY (codigo_matricula);
 B   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_pkey;
       public         postgres    false    203            �
           2606    24816    profesor profesor_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.profesor
    ADD CONSTRAINT profesor_pkey PRIMARY KEY (rut);
 @   ALTER TABLE ONLY public.profesor DROP CONSTRAINT profesor_pkey;
       public         postgres    false    197            �
           2620    25189    alumno agregar_log_alumno    TRIGGER     �   CREATE TRIGGER agregar_log_alumno AFTER INSERT OR DELETE OR UPDATE ON public.alumno FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 2   DROP TRIGGER agregar_log_alumno ON public.alumno;
       public       postgres    false    196    249            �
           2620    25183    curso agregar_log_curso    TRIGGER     �   CREATE TRIGGER agregar_log_curso AFTER INSERT OR DELETE OR UPDATE ON public.curso FOR EACH ROW EXECUTE PROCEDURE public.proceso_agregar_log();
 0   DROP TRIGGER agregar_log_curso ON public.curso;
       public       postgres    false    249    199            �
           2620    25192    evaluacion modificacion_nota    TRIGGER     �   CREATE TRIGGER modificacion_nota AFTER UPDATE OF nota ON public.evaluacion FOR EACH ROW EXECUTE PROCEDURE public.actualizar_promedio();
 5   DROP TRIGGER modificacion_nota ON public.evaluacion;
       public       postgres    false    250    205    205            �
           2606    25124 '   curso curso_ref_profesor_encargado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.curso
    ADD CONSTRAINT curso_ref_profesor_encargado_fkey FOREIGN KEY (ref_profesor_encargado) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.curso DROP CONSTRAINT curso_ref_profesor_encargado_fkey;
       public       postgres    false    197    2763    199            �
           2606    24889 %   evaluacion evaluacion_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 O   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_alumno_fkey;
       public       postgres    false    205    2759    196            �
           2606    24894 .   evaluacion evaluacion_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 X   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_instancia_curso_fkey;
       public       postgres    false    201    2767    205            �
           2606    24884 '   evaluacion evaluacion_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluacion
    ADD CONSTRAINT evaluacion_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 Q   ALTER TABLE ONLY public.evaluacion DROP CONSTRAINT evaluacion_ref_profesor_fkey;
       public       postgres    false    205    2763    197            �
           2606    24836 .   instancia_curso instancia_curso_ref_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_curso_fkey FOREIGN KEY (ref_curso) REFERENCES public.curso(codigo);
 X   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_curso_fkey;
       public       postgres    false    199    2765    201            �
           2606    24831 1   instancia_curso instancia_curso_ref_profesor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.instancia_curso
    ADD CONSTRAINT instancia_curso_ref_profesor_fkey FOREIGN KEY (ref_profesor) REFERENCES public.profesor(rut);
 [   ALTER TABLE ONLY public.instancia_curso DROP CONSTRAINT instancia_curso_ref_profesor_fkey;
       public       postgres    false    197    2763    201            �
           2606    24855 #   matricula matricula_ref_alumno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_alumno_fkey FOREIGN KEY (ref_alumno) REFERENCES public.alumno(matricula_id);
 M   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_alumno_fkey;
       public       postgres    false    2759    196    203            �
           2606    24860 ,   matricula matricula_ref_instancia_curso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matricula
    ADD CONSTRAINT matricula_ref_instancia_curso_fkey FOREIGN KEY (ref_instancia_curso) REFERENCES public.instancia_curso(id);
 V   ALTER TABLE ONLY public.matricula DROP CONSTRAINT matricula_ref_instancia_curso_fkey;
       public       postgres    false    203    201    2767            Z   �   x�mα
�0����0%��M���Apr9Jp���M����S��<��Co:�ÏO
TZ���Nj�4)�Kq^�������	�7n�	ՎB��4�e��S�p�5�J	Xɯ+�u[c�;./�D9������ojv�Z��!k�q5r ��8�\�}�)A?��&��1z���zQQK�      ]   }   x�3�tO-.�<�9O!%U!)�8D�$��sz:;s��qs�^[��������Z��������2�(ʯLM.��*(�O/J�ML�m�霘�\���`��g
4�
ZXX�s��qqq �2-�      c   �   x�u��j�0�s�� Uf��
����^RK@��L޿�lQ��u����'��l�]E$�$��0�H|����|
s�S��Fk���vH��T����ǕX7���{�w��;�͖�·�1��c�b������d?����ay��������'���%?o�1�11��~t�[k�?�R�}�"zUF=��Q[����9їZJ��'rg      _   =   x�]ɱ�0E��y�Ǒۈ5�*K�kOL6RUeDwG6�O���Ev��Ǩ���|�u      e   �   x�}�1�0��>������⎂:
D$"pB�B�<��0A�cC\@%���b�nx]����o���3�}�=T�S���)��������/;#cq)gNq1%��L
�!������d�V��2�%vr���<Ru      a   ,   x�3�4204610704�4���4�2B3��� ��B�b���� n�
�      [   �   x�M�1�0��9L��M�l0!!!� ,&D�$�*-�'�������af��p.�a�5NU�9���g��y����V;�5�Ej���(K��y�""��!c�Ytj*H�o��-�_��qߪ���|��=�d-�v�I�T���x$�h��ŵSJ}��;�     