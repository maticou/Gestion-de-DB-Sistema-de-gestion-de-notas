var pgp = require('pg-promise')(/* options */)
let db = pgp('postgres://postgres:19016777@localhost:5432/registro_notas')

module.exports = db;