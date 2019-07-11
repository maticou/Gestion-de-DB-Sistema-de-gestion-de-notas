const express = require('express');
const app = express();

const Curso = require('../modelos/curso');
const Instancia_curso = require('../modelos/instancia_curso');

app.put('/curso/agregar', (req, res) =>{
	let body = req.body;
	let nuevo_curso = new Curso(0, body.nombre, body.carrera, body.ref_profesor_encargado);

	Curso.agregar_curso(nuevo_curso, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El curso se ha agregado correctamente"
		});
	});
});

app.post('/curso/modificar', (req, res) => {
	let body = req.body;
	let curso = new Curso(body.codigo, body.nombre, body.carrera, body.ref_profesor_encargado);

	Curso.modificar_curso(curso, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El curso se ha modificado correctamente"
		});
	});
});

app.get('/curso/obtener', (req, res) => {
	Curso.obtener_cursos((err, cursos) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(cursos);
	});
});

app.get('/curso/obtener/:codigo', (req, res) => {
	let codigo = req.params.codigo;

	Curso.obtener_curso(codigo, (err, cursos) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(cursos);
	});
});

app.put('/curso/agregarInstancia', (req, res) =>{
	let body = req.body;
	let nueva_instancia = new Instancia_curso(0, body.periodo, body.ref_profesor, body.ref_curso, body.anio, body.semestre);

	Instancia_curso.agregar_instancia(nueva_instancia, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "Se ha agregado una instancia para el curso"
		});
	});
});

app.get('/curso/obtenerInstancia', (req, res) => {
	Instancia_curso.obtener_instancias((err, instancias) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(instancias);
	});
});

app.post('/curso/modificarInstancia', (req, res) => {
	let body = req.body;
	let instancia = new Instancia_curso(body.id, body.periodo, body.ref_profesor, body.ref_curso, body.anio, body.semestre);

	Instancia_curso.modificar_instancia(instancia, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La instancia se ha modificado correctamente"
		});
	});
});

app.post('/curso/eliminarInstancia/:id', (req, res) =>{
	let id_instancia = req.params.id;

	Instancia_curso.eliminar_instancia(id_instancia, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La instancia se ha eliminado correctamente"
		});
	});
})

module.exports = app;