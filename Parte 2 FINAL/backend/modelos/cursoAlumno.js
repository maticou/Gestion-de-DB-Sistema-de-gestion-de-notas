const db = require('../common/postgres');

class CursoAlumno{
	constructor(codigo, nombre, seccion, anio, semestre, profesor){
		this.codigo = codigo;
		this.nombre = nombre;
		this.seccion = seccion;
		this.anio = anio;
		this.semestre = semestre;
		this.profesor = profesor;
	}

	static obtener_cursos_alumno(matricula, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
	}
}

module.exports = CursoAlumno;