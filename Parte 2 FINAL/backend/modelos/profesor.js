const db = require('../common/postgres');

class Profesor{
	constructor(rut, nombre, apellido, correo, telefono, estado){
		this.rut = rut;
		this.nombre = nombre;
		this.apellido = apellido;
		this.correo = correo;
		this.telefono = telefono;
		this.estado = estado;
	}

	static obtener_profesores(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM profesor').then(function(results){
        	let profesores = [];
        	for(const profesor of results){
        		profesores.push(new Profesor( profesor.rut, profesor.nombre, profesor.apellido,
        			profesor.correo, profesor.telefono, profesor.estado));
        	}

        	return callback(null, profesores);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static eliminar_profesor(rut, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL deshabilitar_profesor($1)', rut).then(function(results){
        	return callback(null, true);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static agregar_profesor(profesor, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL registrar_profesor($1, $2, $3, $4, $5)', 
        	[alumno.rut,
        	alumno.nombre,
        	alumno.apellido,
        	alumno.correo,
        	alumno.telefono])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static modificar_profesor(profesor, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_profesor($1, $2, $3, $4, $5)',
        	[alumno.rut, 
        	alumno.nombre, 
        	alumno.apellido, 
        	alumno.correo, 
        	alumno.telefono])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}
}

module.exports = Profesor;