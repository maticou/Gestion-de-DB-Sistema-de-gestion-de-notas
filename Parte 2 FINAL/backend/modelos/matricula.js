const db = require('../common/postgres');

class Matricula{
	constructor(codigo_matricula, ref_alumno, ref_instancia_curso, situacion, nota_final){
		this.codigo_matricula = codigo_matricula;
		this.ref_alumno = ref_alumno;
		this.ref_instancia_curso = ref_instancia_curso;
		this.situacion = situacion;
		this.nota_final = nota_final;
	}

	static agregar_matricula(matricula, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL inscribir_curso($1, $2)', 
        	[matricula.ref_alumno,
        	matricula.ref_instancia_curso])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static modificar_matricula(matricula, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_matricula($1, $2, $3, $4)',
        	[matricula.codigo_matricula,
        	matricula.ref_alumno,
        	matricula.ref_instancia_curso,
        	matricula.nota_final])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}	

	static obtener_matriculas(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM matricula').then(function(results){
        	let matriculas = [];
        	for(const matricula of results){
        		matriculas.push(new Matricula(matricula.codigo_matricula, matricula.ref_alumno, 
        			matricula.ref_instancia_curso, matricula.situacion, matricula.nota_final));
        	}

        	return callback(null, matriculas);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

    static calcular_nota_final(data, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL calcular_nota_final($1, $2)',
            [data.id_alumno,
            data.id_instancia_curso])
        .then(function(results){
            return callback(null, true);
        })
        .catch(function(err){
            return callback(err);
        })
    }
}

module.exports = Matricula;