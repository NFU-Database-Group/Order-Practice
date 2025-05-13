# Details of order system

相關資料處理都在 `order_system.js` 中。

## 階段 0

相關資料表： `Employee`  

- Employee
    - `/orders` 訂單(post)：取出所有員工編號，隨機選擇一位負責處理訂單 (暫時)  
        Query
        ```js
        await conn.query('SELECT employeeNo FROM employee'); //order_system.js
        ```
        SQL
        ```sql
        SELECT employeeNo FROM employee
        ```
    -  `/orders` 訂單頁面：取出負責訂單的員工姓名  
        Query
        ```js
        await conn.query('SELECT firstName, lastName FROM employee WHERE employeeNo = ?', [rows[i].employeeNo]);
        ```
        SQL
        ```sql
        SELECT firstName, lastName FROM employee WHERE employeeNo = <負責員工編號>
        ```

## 階段 1

相關資料表 `Customer`、`PaymentMethod`、`Product`、`ShipmentMethod`

- Customer
    - `/register` 註冊(post)：將新註冊的用戶加進客戶資料表 (目前只實作最少要求欄位的版本)  
        INSERT INTO
        ```js
        await conn.query('INSERT INTO customer (customerName, custTelNo) VALUES (?, ?)', [username, phone]); //order_system.js
        ```
        SQL
        ```sql
        INSERT INTO customer (customerName, custTelNo) VALUES (<某用戶名>, <某用戶電話>)
        ```
    - `/login` 登入(post)：取出名稱與輸入相同的資料進行比對 (目前沒有實作驗證，先不紀錄)

- PaymentMethod
    - 待補充，運輸資料表會使用到此資料表內容，目前尚未實作存取

- Product
    - `/product` 所有商品頁面：取出所有商品的必要資訊  
        Query
        ```js
        await conn.query('SELECT productNo, productName, unitPrice, quantityOnHand FROM product'); //order_system.js
        ```
        SQL
        ```sql
        SELECT productNo, productName, unitPrice, quantityOnHand FROM product
        ```
    - `/` 首頁：取出前三個商品 (尚未實作排序)  
        Query
        ```js
        await conn.query('SELECT productNo, productName, unitPrice, quantityOnHand FROM product LIMIT 3'); //order_system.js
        ```
        SQL
        ```sql
        SELECT productNo, productName, unitPrice, quantityOnHand FROM product LIMIT 3
        ```
    - `/orders` 訂單頁面：根據訂單紀錄的產品編號找出對應的產品名稱  
        Query
        ```js
        await conn.query('SELECT productName FROM product WHERE productNo = ?', [detail[j].productNo]); //order_system.js
        ```
        SQL
        ```sql
        SELECT productName FROM product WHERE productNo = <訂購單中某產品編號>
        ```

- ShipmentMethod
    - 待補充，與PaymentMethod相同，要到運輸處理時才會實際存取到其資料，目前尚未實作存取

## 階段 2
相關資料表： `Order`
- Order
    - `/orders` 訂單頁面：顯示客戶訂單狀態  
        Query
        ```js
        await conn.query('SELECT orderNo, orderDate, status, employeeNo FROM `order` WHERE customerNo = ?', [req.session.user.id]); //order_system.js
        ```
        SQL
        ```sql
        SELECT orderNo, orderDate, status, employeeNo FROM `order` WHERE customerNo = <當前登入用戶編號>
        ```
    - `/orders` 訂購(post)：客戶執行訂購，產生訂單資訊並記錄到資料庫  
        INSERT INTO
        ```js
        await conn.query('INSERT INTO `order` (orderDate, customerNo, employeeNo, status) VALUES (?, ?, ?, ?)', [now.toISOString().slice(0, 19).replace('T', ' '), req.session.user.id, randomIndex, 'TBC']); //order_system.js
        ```
        SQL
        ```sql
        INSERT INTO `order` (orderDate, customerNo, employeeNo, status) VALUES (<訂購當下>, <當前登入用戶編號>, <隨機挑選的員工編號>, 'TBC')
        ```

## 階段 3
相關資料表： `OrderDetail`
- OrderDetail
    - `/orders` 訂單頁面：顯示客戶訂單狀態，附上詳細訂單資訊  
        Query
        ```js
        await conn.query('SELECT productNo, quantityOrdered FROM OrderDetail WHERE orderNo = ?', [rows[i].orderNo]); //order_system.js
        ```
        SQL
        ```sql
        SELECT productNo, quantityOrdered FROM OrderDetail WHERE orderNo = <當前客戶某訂單編號>
        ```
    - `/orders` 訂單(post)：客戶執行訂購，產生訂單詳細資訊並記錄到資料庫  
        INSERT INTO
        ```js
        await conn.query('INSERT INTO OrderDetail (orderNo, productNo, quantityOrdered) VALUES (?, ?, ?)', [orderNo.insertId, req.session.cart[i].id, req.session.cart[i].quantity]); //order_system.js
        ```
        SQL
        ```sql
        INSERT INTO OrderDetail (orderNo, productNo, quantityOrdered) VALUES (<當前客戶某訂單編號>, <訂單中的產品編號>, <訂購數量>)
        ```

# Details of Inventory management

## 階段 4
相關資料表： `Shipment`
- Shipment
    - `/orders` 訂單(post)：客戶執行訂購，紀錄運送資訊  
        INSERT INTO
        ```js
        await conn.query(
            'INSERT INTO Shipment (quantity, shipmentDate, completeStatus, orderNo, productNo, employeeNo, sMethodNo) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
            req.session.cart[i].quantity,
            date,
            'pending',
            orderNo.insertId,
            req.session.cart[i].id,
            employee[randomIndex].employeeNo,
            deliveryMethod
            ]
        );
        ```
        SQL
        ```sql
        INSERT INTO Shipment (
            quantity, shipmentDate, completeStatus, orderNo, productNo, employeeNo, sMethodNo
        ) VALUES (
            <某產品在購物車的數量>, <完成日期>, <完成狀態>, <下定訂單編號>, <購物車中某產品編號>, <隨機員工編號>, <運送方式>
        );
        ```

## 階段 5
相關資料表： `Invoice`
- Invoice
    - `/orders` 訂單(post)：客戶執行訂購，紀錄發票資訊  
        INSERT INTO
        ```js
        await conn.query(
            'INSERT INTO Invoice (dateRaised, orderNo, pMethodNo) VALUES (?, ?, ?)',
            [date, orderNo.insertId, paymentMethod]
        );
        ```
        SQL
        ```sql
        INSERT INTO Invoice (dateRaised, orderNo, pMethodNo) VALUES (<發票日期>, <訂單編號>, <付款方式>)
        ```
