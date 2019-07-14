const db = require('../common/postgres');

class Reportes{
	constructor(){

	}

	static porcentaje_alumnos_que_toman_cursos(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_porcentaje_alumnos_que_toman_cursos()').then(function(results){
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

    static alumnos_con_peor_promedio(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_alumnos_con_peor_promedio()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static alumnos_con_mas_cursos_aprobados(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_alumnos_con_mayor_numero_cursos_aprobados()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static alumnos_con_mas_cursos_reprobados(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_alumnos_con_mayor_numero_cursos_reprobados()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static numero_cursos_dictados_por_profesor(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_numero_cursos_dictados_por_profesor()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static profesores_con_numero_de_aprobados(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_profesores_con_numero_de_aprobados()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static profesores_con_numero_de_reprobados(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_profesores_con_numero_de_reprobados()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static cursos_con_porcentaje_de_reprobados(callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_cursos_con_porcentaje_de_reprobados()').then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static porcentaje_aprobado_y_reprobado_de_una_seccion(id_instancia, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_porcentaje_aprobado_y_reprobado_de_una_seccion($1)', id_instancia).then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static promedio_de_una_seccion(id_instancia, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM reporte_promedio_de_una_seccion($1)', id_instancia).then(function(results){
            return callback(null, results);
        })
        .catch(function(err){
            return callback(err);
        })
    }
}

module.exports = Reportes;