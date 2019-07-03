const db = require('../common/postgres');

class Instancia_curso{
	constructor(id, periodo, seccion, ref_profesor, ref_curso, anio, semestre){
		this.id = id;
		this.periodo = periodo;
		this.ref_profesor = ref_profesor;
		this.ref_curso = ref_curso;
		this.anio = anio;
		this.semestre = semestre;
	}

	static agregar_instancia(instancia, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL agregar_instancia($1, $2, $3, $4)', 
        	[instancia.periodo,
        	instancia.seccion,
        	instancia.ref_profesor,
        	instancia.ref_curso])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static obtener_instancias(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM instancia_curso').then(function(results){
        	let instancias = [];
        	for(const alumno of results){
        		instancias.push(new Instancia_curso(instancia.id, instancia.periodo, instancia.seccion, instancia.ref_profesor,
        			instancia.ref_curso, instancia.anio, instancia.semestre));
        	}

        	return callback(null, instancias);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static eliminar_instancia(id, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL eliminar_instancia_curso($1)', id).then(function(results){
        	return callback(null, true);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static modificar_instancia(instancia, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_instancia($1, $2, $3, $4, $5)',
        	[instancia.id,
        	instancia.periodo,
        	instancia.seccion,
        	instancia.ref_profesor,
        	instancia.ref_curso])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}
}

module.exports = Instancia_curso;