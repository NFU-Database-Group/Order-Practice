const express = require('express');
const pool = require('./db');

const app = express();
const port = 49152;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const session = require('express-session');
const { name } = require('ejs');
app.use(session({
    secret: 'secret-key',
    resave: false,
    saveUninitialized: true
}));

app.set('view engine', 'ejs');

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
