const db = require('../common/postgres');

class Login{
	constructor(){

	}

	static iniciar_sesion_alumno(alumno, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT ref_alumno FROM alumno_seguridad WHERE ref_alumno=$1 AND contrasena=$2',
        	[alumno.alumno_id,
        	alumno.contrasena])
        .then(function(results){
            let usuario = 'NULL';

            for(const user of results){
                usuario = user.ref_alumno;
            }
    		return callback(null, usuario);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}

	static iniciar_sesion_profesor(profesor, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT ref_profesor FROM profesor_seguridad WHERE ref_profesor=$1 AND contrasena=$2',
        	[profesor.profesor_id,
        	profesor.contrasena])
        .then(function(results){

            let usuario = 'NULL';

            for(const user of results){
                usuario = user.ref_profesor;
            }
    		return callback(null, usuario);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}
}

module.exports = Login;