const postgres = require('./common/postgres');
const express = require('express');
const app = express();
var cors = require('cors');
const bodyParser = require('body-parser');

var corsOptions = {
  origin: '*',
  optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
}

app.use(cors(corsOptions))

app.use(bodyParser.urlencoded({
  extended: false
}))

app.listen(3309, "0.0.0.0", () => {
  console.log('Escuchando puerto: ', 3309);
});

app.use(bodyParser.json());

// Configuración global de rutas
app.use(require('./routes/index'));