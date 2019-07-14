const express = require('express');
const app = express();

app.get("/", (req, res) => res.json({message: 'Api para BD registro_notas'}))
app.use(require('./alumno'));
app.use(require('./profesor'));
app.use(require('./curso'));
app.use(require('./evaluacion'));
app.use(require('./matricula'));
app.use(require('./reportes'));

module.exports = app;
