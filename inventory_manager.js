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

setInterval(() => {
  let conn;
  try {
      conn = pool.getConnection();
      // 定期執行的 SQL 查詢 -> 自動化處理庫存管理
      // TODO ...
  } catch (err) {
      console.error('資料庫錯誤', err);
  } finally {
      if (conn) conn.release();
  }
}, 10 * 60 * 1000); // 每 10 分鐘執行一次

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
