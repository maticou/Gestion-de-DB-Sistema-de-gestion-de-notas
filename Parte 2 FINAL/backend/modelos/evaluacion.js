const db = require('../common/postgres');

class Evaluacion{
	constructor(codigo, fecha, porcentaje, exigible, area, tipo,
	 prorroga, ref_profesor, ref_instancia_curso){
		this.codigo = codigo;
		this.fecha = fecha;
		this.porcentaje = porcentaje;
		this.exigible = exigible;
		this.area = area;
		this.tipo = tipo;
		this.prorroga = prorroga;
		this.ref_profesor = ref_profesor;
		this.ref_instancia_curso = ref_instancia_curso;
        this.nota = 0;
	}

	static agregar_evaluacion(evaluacion, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL crear_evaluacion($1, $2, $3, $4, $5, $6, $7, $8)', 
        	[evaluacion.fecha,
        	evaluacion.porcentaje,
        	evaluacion.exigible,
        	evaluacion.area,
        	evaluacion.tipo,
        	evaluacion.prorroga,
        	evaluacion.ref_profesor,
        	evaluacion.ref_instancia_curso])
        .then(function(err, results, fields){
        	return callback(null, true)
    	})
    	.catch(function(err, results, fields){
    		return callback(err);
    	})
	}

	static modificar_evaluacion(evaluacion, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_evaluacion($1, $2, $3, $4, $5, $6, $7, $8, $9)',
        	[evaluacion.codigo,
        	evaluacion.fecha,
        	evaluacion.porcentaje,
        	evaluacion.exigible,
        	evaluacion.area,
        	evaluacion.tipo,
        	evaluacion.prorroga,
        	evaluacion.ref_profesor,
        	evaluacion.ref_instancia_curso])
        .then(function(results){
    		return callback(null, true);
    	})
    	.catch(function(err){
    		return callback(err);
    	})
	}

	static eliminar_evaluacion(codigo, callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL eliminar_evaluacion($1)', codigo).then(function(results){
        	return callback(null, true);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

	static obtener_evaluaciones(callback){
		if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM evaluacion').then(function(results){
        	let evaluaciones = [];
        	for(const evaluacion of results){
        		evaluaciones.push(new Evaluacion(evaluacion.codigo, evaluacion.fecha, evaluacion.porcentaje, evaluacion.exigible, 
        			evaluacion.area, evaluacion.tipo, evaluacion.prorroga,
        			evaluacion.ref_profesor, evaluacion.ref_instancia_curso));
        	}

        	return callback(null, evaluaciones);
        })
        .catch(function(err){
        	return callback(err);
        })
	}

    static obtener_evaluaciones_curso(codigo, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM evaluacion WHERE ref_instancia_curso = $1', codigo).then(function(results){
            let evaluaciones = [];
            for(const evaluacion of results){
                evaluaciones.push(new Evaluacion(evaluacion.codigo, evaluacion.fecha, evaluacion.porcentaje, evaluacion.exigible, 
                    evaluacion.area, evaluacion.tipo, evaluacion.prorroga,
                    evaluacion.ref_profesor, evaluacion.ref_instancia_curso));
            }

            return callback(null, evaluaciones);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static obtener_datos_evaluacion(codigo, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM evaluacion WHERE codigo = $1', codigo).then(function(results){
            let evaluaciones = [];
            for(const evaluacion of results){
                evaluaciones.push(new Evaluacion(evaluacion.codigo, evaluacion.fecha, evaluacion.porcentaje, evaluacion.exigible, 
                    evaluacion.area, evaluacion.tipo, evaluacion.prorroga,
                    evaluacion.ref_profesor, evaluacion.ref_instancia_curso));
            }

            return callback(null, evaluaciones[0]);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static evaluaciones_alumno_curso(codigo, matricula, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.any('SELECT * FROM lista_evaluaciones_por_instancia_curso_por_alumno($1, $2)', [codigo, matricula]).then(function(results){
            let evaluaciones = [];
            for(const evaluacion of results){
                let nueva_evaluacion = new Evaluacion(evaluacion.codigo, evaluacion.fecha, evaluacion.porcentaje, evaluacion.exigible, 
                    evaluacion.area, evaluacion.tipo, evaluacion.prorroga,
                    evaluacion.ref_profesor, evaluacion.ref_instancia_curso);

                nueva_evaluacion.nota = evaluacion.nota;

                evaluaciones.push(nueva_evaluacion);
            }

            return callback(null, evaluaciones);
        })
        .catch(function(err){
            return callback(err);
        })
    }

    static ingresar_nota(data, callback){
        if(!callback || !(typeof callback === 'function')){
            throw new Error('There is not a callback function. Please provide them');
        }
        db.none('CALL modificar_nota($1, $2, $3, $4)',
            [data.nota,
            data.ref_evaluacion,
            data.ref_alumno,
            data.ref_instancia_curso])
        .then(function(results){
            return callback(null, true);
        })
        .catch(function(err){
            return callback(err);
        })
    }
}

module.exports = Evaluacion;