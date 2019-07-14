const express = require('express');
const app = express();

const Login = require('../modelos/login');

app.post('/login/alumno', (req, res) =>{
	let body = req.body;
	var alumno = { alumno_id: body.alumno_id, contrasena: body.contrasena} ;

	Login.iniciar_sesion_alumno(alumno, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({results, tipo: "ALUMNO"});
	});
})

app.post('/login/profesor', (req, res) =>{
	let body = req.body;
	var profesor = { profesor_id: body.profesor_id, contrasena: body.contrasena} ;

	Login.iniciar_sesion_profesor(profesor, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json({results, tipo: "PROFESOR"});
	});
})

module.exports = app;