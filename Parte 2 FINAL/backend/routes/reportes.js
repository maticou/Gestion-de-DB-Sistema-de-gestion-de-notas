const express = require('express');
const app = express();

const Reportes = require('../modelos/reportes');

app.get('/reportes/porcentaje_alumnos_que_toman_cursos', (req, res) => {
	Reportes.porcentaje_alumnos_que_toman_cursos((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/alumnos_con_mejor_promedio', (req, res) => {
	Reportes.alumnos_con_mejor_promedio((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/alumnos_con_peor_promedio', (req, res) => {
	Reportes.alumnos_con_peor_promedio((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/alumnos_con_mas_cursos_aprobados', (req, res) => {
	Reportes.alumnos_con_mas_cursos_aprobados((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/alumnos_con_mas_cursos_reprobados', (req, res) => {
	Reportes.alumnos_con_mas_cursos_reprobados((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/numero_cursos_dictados_por_profesor', (req, res) => {
	Reportes.numero_cursos_dictados_por_profesor((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/profesores_con_numero_de_aprobados', (req, res) => {
	Reportes.profesores_con_numero_de_aprobados((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/profesores_con_numero_de_reprobados', (req, res) => {
	Reportes.profesores_con_numero_de_reprobados((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/cursos_con_porcentaje_de_reprobados', (req, res) => {
	Reportes.cursos_con_porcentaje_de_reprobados((err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/porcentaje_aprobado_y_reprobado_de_una_seccion/:id_instancia', (req, res) => {
	let id_instancia = req.params.id_instancia;

	Reportes.porcentaje_aprobado_y_reprobado_de_una_seccion(id_instancia, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

app.get('/reportes/promedio_de_una_seccion/:id_instancia', (req, res) => {
	let id_instancia = req.params.id_instancia;
	
	Reportes.promedio_de_una_seccion(id_instancia, (err, results) => {
		if(err){
			return res.status(400).json(err);
		}

		return res.json(results);
	});
});

module.exports = app;