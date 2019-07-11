const express = require('express');
const app = express();

const Alumno = require('../modelos/alumno');

app.put('/alumno/agregar', (req, res) =>{
	let body = req.body;
	let nuevo_alumno = new Alumno(body.matricula_id, body.rut, body.nombre, body.apellido_paterno, 
		body.apellido_materno, body.correo, body.telefono);

	Alumno.agregar_alumno(nuevo_alumno, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El alumno se ha agregado correctamente"
		});
	});
});

app.get('/alumno/obtener/:matricula', (req, res) => {
	let matricula = req.params.matricula;

    Alumno.obtener_alumno(matricula, (err, alumno) => {
    	if(err){
    		return res.status(400).json(err);
    	}
    	return res.json(alumno);
    })
});

app.post('/alumno/eliminar/:matricula_id', (req, res) =>{
	let matricula = req.params.matricula_id;

	Alumno.eliminar_alumno(matricula, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El alumno se ha eliminado correctamente"
		});
	});
})

app.post('/alumno/modificar', (req, res) => {
	let body = req.body;
	let alumno = new Alumno(body.matricula_id, body.rut, body.nombre, body.apellido_paterno, body.apellido_materno,
		body.correo, body.telefono);

	Alumno.modificar_alumno(alumno, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El alumno se ha modificado correctamente"
		});
	});
})

app.get('/alumno/obtener', (req, res) => {
	Alumno.obtener_alumnos((err, alumnos) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(alumnos);
	});
});

module.exports = app;