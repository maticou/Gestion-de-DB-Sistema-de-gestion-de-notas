const db = require('../common/postgres');

class Reportes{
	constructor(){

	}

	static porcentaje_alumnos_que_toman_cursos(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT FROM reporte_porcentaje_alumnos_que_toman_cursos()').then(function(results){
        	return callback(null, results);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static alumnos_con_mejor_promedio(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_alumnos_con_mejor_promedio()').then(function(results){
        	return callback(null, results);
        })
        .catch(function(err){
        	return callback(err);
        })
	}
}