const express = require('express');
const app = express();

const Evaluacion = require('../modelos/evaluacion')

app.put('/evaluacion/agregar', (req, res) =>{
	let body = req.body;
	let nueva_evaluacion = new Evaluacion(0, body.fecha, body.porcentaje, body.exigible, 
		body.area, body.tipo, body.prorroga, body.ref_profesor, body.ref_instancia_curso);

	Evaluacion.agregar_evaluacion(nueva_evaluacion, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La evaluación se ha registrado exitosamente"
		});
	});
});

app.post('/evaluacion/eliminar/:codigo', (req, res) =>{
	let codigo = req.params.codigo;

	Evaluacion.eliminar_evaluacion(codigo, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La evaluación se ha eliminado exitosamente"
		});
	});
});

app.post('/evaluacion/modificar', (req, res) => {
	let body = req.body;
	let evaluacion = new Evaluacion(body.codigo, body.fecha, body.porcentaje, body.exigible, 
		body.area, body.tipo, body.prorroga, body.ref_profesor, body.ref_instancia_curso);

	Evaluacion.modificar_evaluacion(evaluacion, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La evaluacion se ha modificado correctamente"
		});
	});
});

app.get('/evaluacion/obtener', (req, res) => {
	Evaluacion.obtener_evaluaciones((err, evaluaciones) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(evaluaciones);
	});
});

app.get('/evaluacion/obtener/:codigo', (req, res) => {
	let codigo = req.params.codigo;

	Evaluacion.obtener_datos_evaluacion(codigo, (err, evaluacion) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(evaluacion);
	});
});

app.get('/evaluacion/obtener/evaluacionesAlumno/:codigo/:matricula', (req, res) => {
	let codigo = req.params.codigo;
	let matricula = req.params.matricula;

	Evaluacion.evaluaciones_alumno_curso(codigo, matricula, (err, evaluaciones) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(evaluaciones);
	});
});

var Data = function(nota, ref_evaluacion, ref_alumno, ref_instancia_curso) {
  this.nota = nota;
  this.ref_evaluacion = ref_evaluacion;
  this.ref_alumno = ref_alumno;
  this.ref_instancia_curso = ref_instancia_curso;
}

app.post('/evaluacion/ingresarNota', (req, res) => {
	let body = req.body;
	var data = { nota: body.nota, ref_evaluacion: body.ref_evaluacion, ref_alumno: body.ref_alumno, ref_instancia_curso: body.ref_instancia_curso} ;
	console.log(data);
	Evaluacion.ingresar_nota(data, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La evaluacion se ha modificado correctamente"
		});
	});
});

module.exports = app;