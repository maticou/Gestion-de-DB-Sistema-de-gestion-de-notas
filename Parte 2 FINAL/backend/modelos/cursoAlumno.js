const db = require('../common/postgres');

class CursoAlumno{
	constructor(id_instancia, nombre_del_curso, seccion, anio, semestre, nombre_profesor_encargado){
		this.id_instancia = id_instancia;
		this.nombre_del_curso = nombre_del_curso;
		this.seccion = seccion;
		this.anio = anio;
		this.semestre = semestre;
		this.nombre_profesor_encargado = nombre_profesor_encargado;
	}

	static obtener_cursos_alumno(matricula, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM consulta_vista_cursos_inscritos_por_alumno($1)', matricula).then(function(results){
        	let cursos = [];
        	for(const curso of results){
        		cursos.push(new CursoAlumno(curso.id_instancia, curso.nombre_del_curso, 
        			curso.seccion, curso.anio, curso.semestre, curso.nombre_profesor_encargado));
        	}

        	return callback(null, cursos);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static obtener_cursos_profesor(rut, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM consulta_vista_cursos_inscritos_por_profesor($1)', rut).then(function(results){
        	let cursos = [];
        	for(const curso of results){
        		cursos.push(new CursoAlumno(curso.id_instancia, curso.nombre_del_curso, 
        			curso.seccion, curso.anio, curso.semestre, rut));
        	}

        	return callback(null, cursos);
        })
        .catch(function(err){
        	return callback(err);
        })
	}
}

module.exports = CursoAlumno;