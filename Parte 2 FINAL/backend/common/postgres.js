var pgp = require('pg-promise')(/* options */)
let db = pgp('postgres://postgres:mgonzalez@localhost:5432/registro_notas')

module.exports = db;