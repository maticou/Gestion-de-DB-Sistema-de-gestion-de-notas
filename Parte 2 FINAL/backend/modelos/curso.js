const db = require('../common/postgres');

class Curso{
	constructor(codigo, nombre, carrera, ref_profesor_encargado){
		this.codigo = codigo;
		this.nombre = nombre;
		this.carrera = carrera;
		this.ref_profesor_encargado = ref_profesor_encargado;
	}

	static agregar_curso(curso, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL agregar_curso($1, $2, $3)', 
        	[curso.nombre,
        	curso.carrera,
        	curso.ref_profesor_encargado])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static obtener_cursos(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM curso').then(function(results){
        	let cursos = [];
        	for(const curso of results){
        		cursos.push(new Curso(curso.codigo, curso.nombre, curso.carrera, curso.ref_profesor_encargado));
        	}

        	return callback(null, cursos);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

    static obtener_curso(codigo, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM curso WHERE codigo = $1', codigo).then(function(results){
            let cursos = [];
            for(const curso of results){
                cursos.push(new Curso(curso.codigo, curso.nombre, curso.carrera, curso.ref_profesor_encargado));
            }

            return callback(null, cursos[0]);
        })
        .catch(function(err){
            return callback(err);
        })
    }

	static modificar_curso(curso, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_curso($1, $2, $3, $4)',
        	[curso.codigo,
        	curso.nombre,
        	curso.carrera,
        	curso.ref_profesor_encargado])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}
}

module.exports = Curso;