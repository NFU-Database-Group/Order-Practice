// index.js
const express = require('express');
const pool = require('./db');

const app = express();
const port = 3000;

app.use(express.json());

app.get('/customer', async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const rows = await conn.query('SELECT * FROM customer');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('資料庫錯誤');
  } finally {
    if (conn) conn.release();
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
