// index.js
const express = require('express');
const pool = require('./db');

const app = express();
const port = 3000;

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

app.get('/', async (req, res) => {
  let conn;
  let products = [];
  try {
      conn = await pool.getConnection();
      const rows = await conn.query('SELECT productNo, productName, unitPrice, quantityOnHand FROM product LIMIT 3');
      for (let i = 0; i < rows.length; i++) {
        const product = {
          id: rows[i].productNo,
          name: rows[i].productName,
          price: rows[i].unitPrice,
          quantity: rows[i].quantityOnHand
        };
        products.push(product);
      }
  } catch (err) {
      console.error('資料庫錯誤', err);
  } finally {
      if (conn) conn.release();
  }
  res.render('lobby', { title: '首頁', user: req.session.user || null, products: products });
});

app.get('/products', async (req, res) => {
  let conn;
  let products = [];
  try {
      conn = await pool.getConnection();
      const rows = await conn.query('SELECT productNo, productName, unitPrice, quantityOnHand FROM product');
      for (let i = 0; i < rows.length; i++) {
        const product = {
          id: rows[i].productNo,
          name: rows[i].productName,
          price: rows[i].unitPrice,
          quantity: rows[i].quantityOnHand
        };
        products.push(product);
      }
  } catch (err) {
      console.error('資料庫錯誤', err);
  } finally {
      if (conn) conn.release();
  }
  res.render('products', { title: '產品', user: req.session.user || null, products: products });
});
app.get('/login', (req, res) => {
  res.render('login', { title: '登入', user: req.session.user || null });
});
app.get('/register', (req, res) => {
  res.render('register', { title: '註冊', user: req.session.user || null });
});
app.post('/register', async (req, res) => {
  const { username, password, phone, email } = req.body;
  let conn;
  try {
      conn = await pool.getConnection();
      const result = await conn.query('INSERT INTO customer (customerName, custTelNo) VALUES (?, ?)', [username, phone]);
      console.log('註冊成功', result);
      req.session.user = { name: username };
      req.session.loggedIn = true;
      req.session.username = username;
      res.redirect('/');
  } catch (err) {
      console.error('註冊失敗', err);
      res.status(500).send('註冊失敗');
  } finally {
      if (conn) conn.release();
  }
});
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  // 在這裡處理登入邏輯
  let conn;
  try {
      conn = await pool.getConnection();
      const rows = await conn.query('SELECT * FROM customer WHERE customerName = ?', [username]);
      if (rows.length > 0) {
        // 找到相符的使用者
        console.log('登入成功');
        req.session.user = { name: username };
        req.session.loggedIn = true;
        req.session.username = username;
      } else {
        // 沒有找到相符的使用者
        console.log('登入失敗：找不到使用者');
      }
  } catch (err) {
      console.error('資料庫錯誤', err);
  } finally {
      if (conn) conn.release();
  }
  console.log(`Username: ${username}, Password: ${password}`);
  res.redirect('/');
});
app.post('/logout', (req, res) => {
  req.session.destroy(err => {
    if (err) {
      console.error('登出失敗', err);
      return res.redirect('/');
    }
    console.log('登出成功');
    res.redirect('/');
  });
});

app.get('/cart', (req, res) => {
  if (!req.session.cart) {
    req.session.cart = [];
  }
  res.render('cart', { title: '購物車', user: req.session.user || null, cart: req.session.cart });
});
app.post('/cart_add', (req, res) => {
  const { productNo, productName, unitPrice, quantity } = req.body;
  if (!req.session.loggedIn) {
      return res.status(401).send('請先登入');
  }
  if (!req.session.cart) {
    req.session.cart = [];
  }
  const product = {
    id: productNo,
    name: productName,
    price: unitPrice,
    quantity: quantity
  };
  const existingProduct = req.session.cart.find(item => item.id === productNo);
  if (existingProduct) {
      existingProduct.quantity = parseInt(existingProduct.quantity) + parseInt(quantity);
  } else {
      req.session.cart.push(product);
  }
  console.log('購物車內容:', req.session.cart);
  res.redirect('/');
});
app.post('/cart_remove', (req, res) => {
  const { productNo } = req.body;
  if (!req.session.cart) {
    req.session.cart = [];
  }
  req.session.cart = req.session.cart.filter(item => item.id !== productNo);
  console.log('購物車內容:', req.session.cart);
  res.redirect('/cart');
});

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
