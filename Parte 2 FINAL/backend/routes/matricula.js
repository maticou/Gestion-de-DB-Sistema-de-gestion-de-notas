const express = require('express');
const app = express();

const Matricula = require('../modelos/matricula');
const Alumno = require('../modelos/alumno');

app.put('/matricula/agregar', (req, res) =>{
	let body = req.body;
	let nueva_matricula = new Matricula(0, body.ref_alumno, body.ref_instancia_curso, 0, 
		0);

	Matricula.agregar_matricula(nueva_matricula, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "Se ha inscrito el curso exitosamente"
		});
	});
});

app.post('/matricula/modificar', (req, res) => {
	let body = req.body;
	let matricula = new Matricula(body.codigo_matricula, body.ref_alumno, body.ref_instancia_curso, body.situacion, 
		body.nota_final);

	Matricula.modificar_matricula(matricula, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "La matricula se ha modificado correctamente"
		});
	});
})

app.get('/matricula/obtener', (req, res) => {
	Matricula.obtener_matriculas((err, matriculas) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(matriculas);
	});
});

app.get('/matricula/instancia/obtenerAlumnos/:id_instancia', (req, res) => {
	let id_instancia = req.params.id_instancia;

	Alumno.obtener_alumnos_instancia(id_instancia, (err, alumnos) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(alumnos);
	});
});

module.exports = app;