const db = require('../common/postgres');

class Alumno{
	constructor(matricula_id, rut, nombre, apellido_paterno, apellido_materno, correo, telefono, estado){
		this.matricula_id = matricula_id;
		this.rut = rut;
		this.nombre = nombre;
		this.apellido_paterno = apellido_paterno;
		this.apellido_materno = apellido_materno;
		this.correo = correo;
		this.telefono = telefono;
		this.estado = estado;
        this.contrasena = '';
	}

	static agregar_alumno(alumno, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL agregar_alumno($1, $2, $3, $4, $5, $6, $7, $8)', 
        	[alumno.matricula_id,
        	alumno.rut,
        	alumno.nombre,
        	alumno.apellido_paterno,
        	alumno.apellido_materno,
        	alumno.correo,
        	alumno.telefono,
            alumno.contrasena])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static obtener_alumnos(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM alumno').then(function(results){
        	let alumnos = [];
        	for(const alumno of results){
        		alumnos.push(new Alumno(alumno.matricula_id, alumno.rut, alumno.nombre, alumno.apellido_paterno,
        			alumno.apellido_materno, alumno.correo, alumno.telefono, alumno.estado));
        	}

        	return callback(null, alumnos);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static eliminar_alumno(matricula, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL deshabilitar_alumno($1)', matricula).then(function(results){
        	return callback(null, true);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static modificar_alumno(alumno, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_alumno($1, $2, $3, $4, $5, $6, $7)',
        	[alumno.matricula_id, 
        	alumno.rut, 
        	alumno.nombre, 
        	alumno.apellido_paterno,
        	alumno.apellido_materno, 
        	alumno.correo, 
        	alumno.telefono])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}

    static obtener_alumno(matricula, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback funtion. Please provide them');
        }
        db.any('SELECT * FROM alumno WHERE matricula_id = $1', matricula).then(function(results){
            let alumnos = [];
            for(const alumno of results){
                alumnos.push(new Alumno(alumno.matricula_id, alumno.rut, alumno.nombre, alumno.apellido_paterno,
                    alumno.apellido_materno, alumno.correo, alumno.telefono, alumno.estado));
            }

            return callback(null, alumnos[0]);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static obtener_alumnos_instancia(id_instancia, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM lista_alumnos_en_instancia_curso($1)', id_instancia).then(function(results){
            let alumnos = [];
            for(const alumno of results){
                alumnos.push(new Alumno(alumno.matricula, alumno.rut, alumno.nombre_alumno, alumno.apellido_paterno,
                    alumno.apellido_materno, alumno.correo_alumno, alumno.telefono_alumno, alumno.estado_alumno));
            }

            return callback(null, alumnos);
        })
        .catch(function(err){
            return callback(err);
        })
    }
}

module.exports = Alumno;