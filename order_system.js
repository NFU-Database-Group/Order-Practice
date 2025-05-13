const express = require('express');
const pool = require('./db');

const app = express();
const port = 65432;

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
  res.render('login', { title: '登入', user: req.session.user || null});
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
      res.redirect('/login');
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
      const rows = await conn.query('SELECT customerNo FROM customer WHERE customerName = ?', [username]);
      if (rows.length > 0) {
        // 找到相符的使用者
        console.log('登入成功');
        req.session.user = { name: username, id: rows[0].customerNo };
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

app.get('/orders', async (req, res) => {
    if (!req.session.loggedIn) {
        return res.status(401).send('請先登入');
    }
    let conn;
    let orders = [];
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT orderNo, orderDate, status, employeeNo FROM `order` WHERE customerNo = ?', [req.session.user.id]);
        for (let i = 0; i < rows.length; i++) {
          const detail = await conn.query('SELECT productNo, quantityOrdered FROM OrderDetail WHERE orderNo = ?', [rows[i].orderNo]);
          const products = [];
          for (let j = 0; j < detail.length; j++) {
            const productName = await conn.query('SELECT productName FROM product WHERE productNo = ?', [detail[j].productNo]);
            const product = {
              id: detail[j].productNo,
              name: productName[0].productName,
              quantity: detail[j].quantityOrdered
            };
            products.push(product);
          }
          const order = {
            id: rows[i].orderNo,
            date: rows[i].orderDate,
            status: rows[i].status,
            employeeNo: rows[i].employeeNo,
            orderDetails: products
          };
          orders.push(order);
        }
    } catch (err) {
        console.error('資料庫錯誤', err);
    } finally {
        if (conn) conn.release();
    }
    res.render('orders', { title: '訂單', user: req.session.user || null, orders: orders });
});
app.post('/orders', async (req, res) => {
  if (!req.session.loggedIn) {
    return res.status(401).send('請先登入');
  }
  let conn;
  try {
    const now = new Date();
    conn = await pool.getConnection();
    const employee = await conn.query('SELECT employeeNo FROM employee');
    const randomIndex = Math.floor(Math.random() * employee.length);
    const orderNo = await conn.query('INSERT INTO `order` (orderDate, customerNo, employeeNo, status) VALUES (?, ?, ?, ?)', [now.toISOString().slice(0, 19).replace('T', ' '), req.session.user.id, randomIndex, 'TBC']);
    for (let i = 0; i < req.session.cart.length; i++) {
      await conn.query('INSERT INTO OrderDetail (orderNo, productNo, quantityOrdered) VALUES (?, ?, ?)', [orderNo.insertId, req.session.cart[i].id, req.session.cart[i].quantity]);
    }
    req.session.cart = [];
    console.log('訂單已建立:', orderNo);
    res.redirect('/orders');
  } catch (err) {
    console.error('資料庫錯誤', err);
  } finally {
    if (conn) conn.release();
  }
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
