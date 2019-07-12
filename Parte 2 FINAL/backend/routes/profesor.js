const express = require('express');
const app = express();

const Profesor = require('../modelos/profesor');

app.put('/profesor/agregar', (req, res) =>{
	let body = req.body;
	let nuevo_profesor = new Profesor(body.rut, body.nombre, body.apellido, 
		body.correo, body.telefono);
	nuevo_profesor.contrasena = body.contrasena;

	Profesor.agregar_profesor(nuevo_profesor, (err, result) =>{
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El profesor se ha agregado correctamente"
		});
	});
});

app.post('/profesor/eliminar/:rut', (req, res) =>{
	let rut = req.params.rut;

	Profesor.eliminar_profesor(rut, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El profesor se ha deshabilitado correctamente"
		});
	});
});

app.post('/profesor/modificar', (req, res) => {
	let body = req.body;
	let profesor = new Profesor(body.rut, body.nombre, body.apellido,
		body.correo, body.telefono);

	Profesor.modificar_profesor(profesor, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({
			mensaje: "El profesor se ha modificado correctamente"
		});
	});
});

app.get('/profesor/obtener', (req, res) => {
	Profesor.obtener_profesores((err, profesores) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(profesores);
	});
});

app.get('/profesor/obtener/:rut', (req, res) => {
	let rut = req.params.rut;

    Profesor.obtener_profesor(rut, (err, profesor) => {
    	if(err){
    		return res.status(400).json(err);
    	}
    	return res.json(profesor);
    })
});

module.exports = app;