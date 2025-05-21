# 訂單系統練習

> [!NOTE]
>
> - 要求：參見附錄E，於一周內建立簡單的 `庫存管理` 與 `訂單系統` (期限 05/14/25)  
> - 加分項目：自動化處理，系統非被動被呼叫

## 摘要

### SQL讀取方法

1. 初始化資料庫 `init.sql`
2. 建立所有資料表 `tables.sql`
3. 對每個資料表建立五筆資料 `insert.sql`

### 資料表互動說明

- 客戶（Customer）下訂單（Order），每筆訂單都要有人員（Employee）確認並處理。
- 處理完成後，對每筆訂單產生一張發票（Invoice），並記錄用戶選擇的付款方式（PaymentMethod）。
- 訂單透過訂單明細（OrderDetail）細分每種商品（Product）與數量，並最終包裝成一或多張出貨單（Shipment），由某位員工負責準備，且標明出貨方式（ShipmentMethod）。

## 目錄

- [主要實體](#主要實體)
- [資料表](#資料表)
    - [Customer](#customer)
    - [Employee](#employee)
    - [Invoice](#invoice)
    - [Order](#order)
    - [OrderDetail](#orderdetail)
    - [PaymentMethod](#paymentmethod)
    - [Product](#product)
    - [Shipment](#shipment)
    - [ShipmentMethod](#shipmentmethod)
- [關係](#關係)
- [依賴層次](#依賴層次)

### 附錄

- [資料庫初始化SQL](./order-practice-db-init/README.md)
    - [資料表建立SQL](./order-practice-db-init/scripts/tables.sql)
    - [資料表模擬資料SQL](./order-practice-db-init/scripts/data.sql)
- [實作細節與SQL](./docs/detail.md)
- [訂單系統使用說明](./docs/README.md)
    - [訂單系統範例-註冊](./docs/examples/register.md)
    - [訂單系統範例-訂單](./docs/examples/order.md)

## 主要實體

| 實體名稱           | 主鍵       | 備註                                                                      |
| ------------------ | ---------- | ------------------------------------------------------------------------- |
| **Customer**       | customerNo | 客戶檔，記錄客戶編號／名稱／聯絡資訊等。                                  |
| **Order**          | orderNo    | 訂單檔，記錄訂單編號、日期、狀態等。                                      |
| **Invoice**        | invoiceNo  | 發票檔，對應每張訂單的開立發票。                                          |
| **PaymentMethod**  | pMethodNo  | 付款方式檔（如現金、信用卡、轉帳…）。                                     |
| **OrderDetail**    | (複合主鍵) | 訂單明細檔，通常用 orderNo + productNo 作為複合主鍵，並記錄數量、單價等。 |
| **Product**        | productNo  | 商品檔，記錄商品編號、名稱、價格、庫存等。                                |
| **Shipment**       | shipmentNo | 出貨檔，記錄出貨編號、日期、狀態等。                                      |
| **ShipmentMethod** | sMethodNo  | 出貨方式檔（如宅配、超商取貨…）。                                         |
| **Employee**       | employeeNo | 員工檔，記錄處理訂單或出貨的員工資訊。                                    |

## 資料表

### Customer

| 欄位名稱        | 欄位說明     | 鍵類型 | 參照說明 | 是否可為空 |
| :-------------- | :----------- | :----- | :------- | :--------- |
| customerNo      | 客戶編號     | 主鍵   |          | 否         |
| customerName    | 客戶姓名     |        |          | 否         |
| customerStreet  | 客戶住址     |        |          | 是         |
| customerCity    | 客戶居住城市 |        |          | 是         |
| customerState   | 客戶居住地區 |        |          | 是         |
| customerZipCode | 客戶郵遞區號 |        |          | 是         |
| custTelNo       | 客戶電話號碼 | 替代鍵 |          | 否         |
| custFaxNo       | 客戶傳真號碼 | 替代鍵 |          | 否         |
| DOB             | 客戶出生日期 |        |          | 是         |
| maritalStatus   | 客戶婚姻狀態 |        |          | 是         |
| creditRating    | 客戶信用等級 |        |          | 否         |

### Employee

| 欄位名稱             | 欄位說明     | 鍵類型 | 參照說明 | 是否可為空 |
| :------------------- | :----------- | :----- | :------- | :--------- |
| employeeNo           | 員工編號     | 主鍵   |          | 否         |
| title                | 員工職稱     |        |          | 是         |
| firstName            | 名字         |        |          | 否         |
| middleName           | 中間名       |        |          | 是         |
| lastName             | 姓氏         |        |          | 否         |
| address              | 電子郵件     |        |          | 是         |
| workTelExt           | 工作分機電話 |        |          | 否         |
| homeTelNo            | 住家電話號碼 |        |          | 是         |
| empEmailAddress      | 員工電子郵件 |        |          | 否         |
| socialSecurityNumber | 社會安全碼   | 替代鍵 |          | 否         |
| DOB                  | 員工出身日期 |        |          | 是         |
| position             | 員工職稱     |        |          | 是         |
| sex                  | 員工性別     |        |          | 是         |
| salary               | 員工薪水     |        |          | 否         |
| dateStarted          | 雇用日期     |        |          | 否         |

### Invoice

| 欄位名稱     | 欄位說明       | 鍵類型 | 參照說明                      | 是否可為空 |
| :----------- | :------------- | :----- | :---------------------------- | :--------- |
| invoiceNo    | 發票編號       | 主鍵   |                               | 否         |
| dateRaised   | 發票開設日期   |        |                               | 否         |
| datePaid     | 付款日期       |        |                               | 否         |
| creditCardNo | 信用卡號末四碼 |        |                               | 否         |
| holdersName  | 持有人姓名     |        |                               | 否         |
| expiryDate   | 過期日期       |        |                               | 否         |
| orderNo      | 訂單編號       | 外鍵   | 參照 Order(orderNo)           | 否         |
| pMethodNo    | 付款方式編號   | 外鍵   | 參照 PaymentMethod(pMethodNo) | 否         |

### Order

| 欄位名稱       | 欄位說明     | 鍵類型 | 參照說明                  | 是否可為空 |
| :------------- | :----------- | :----- | :------------------------ | :--------- |
| orderNo        | 訂單編號     | 主鍵   |                           | 否         |
| orderDate      | 訂單日期     |        |                           | 否         |
| billingStreet  | 帳單地址     |        |                           | 否         |
| billingCity    | 帳單城市     |        |                           | 否         |
| billingState   | 帳單地區     |        |                           | 否         |
| billingZipCode | 帳單郵遞區號 |        |                           | 否         |
| promisedDate   | 承諾日期     |        |                           | 否         |
| status         | 訂單狀態     |        |                           | 否         |
| customerNo     | 客戶編號     | 外鍵   | 參照 Customer(customerNo) | 否         |
| employeeNo     | 負責員工編號 | 外鍵   | 參照 Employee(employeeNo) | 否         |

### OrderDetail

| 欄位名稱        | 欄位說明 | 鍵類型     | 參照說明                | 是否可為空 |
| :-------------- | :------- | :--------- | :---------------------- | :--------- |
| orderNo         | 訂單編號 | 主鍵、外鍵 | 參照 Order(orderNo)     | 否         |
| productNo       | 產品編號 | 主鍵、外鍵 | 參照 Product(productNo) | 否         |
| quantityOrdered | 訂購數量 |            |                         | 否         |

### PaymentMethod

| 欄位名稱      | 欄位說明     | 鍵類型 | 參照說明 | 是否可為空 |
| :------------ | :----------- | :----- | :------- | :--------- |
| pMethodNo     | 付款方式編號 | 主鍵   |          | 否         |
| paymentMethod | 付款方式     |        |          | 否         |

### Product

| 欄位名稱        | 欄位說明     | 鍵類型 | 參照說明 | 是否可為空 |
| :-------------- | :----------- | :----- | :------- | :--------- |
| productNo       | 產品編號     | 主鍵   |          | 否         |
| productName     | 產品名稱     |        |          | 否         |
| serialNo        | 型號         | 替代鍵 |          | 否         |
| unitPrice       | 單價         |        |          | 否         |
| quantityOnHand  | 現有數量     |        |          | 否         |
| reorderLevel    | 安全庫存量   |        |          | 否         |
| reorderQuantity | 補貨數量     |        |          | 否         |
| reorderLeadTime | 補貨交貨時間 |        |          | 否         |

### Shipment

| 欄位名稱       | 欄位說明     | 鍵類型 | 參照說明                             | 是否可為空 |
| :------------- | :----------- | :----- | :----------------------------------- | :--------- |
| shipmentNo     | 運送編號     | 主鍵   |                                      | 否         |
| quantity       | 運送數量     |        |                                      | 否         |
| shipmentDate   | 運送日期     |        |                                      | 否         |
| completeStatus | 完成狀態     |        |                                      | 否         |
| orderNo        | 訂單編號     | 外鍵   | 參照 OrderDetail(orderNo, productNo) | 否         |
| productNo      | 產品編號     | 外鍵   | 參照 OrderDetail(orderNo, productNo) | 否         |
| employeeNo     | 員工編號     | 外鍵   | 參照 Employee(employeeNo)            | 否         |
| sMethodNo      | 運送方式編號 | 外鍵   | 參照 ShipmentMethod(sMethodNo)       | 否         |

### ShipmentMethod

| 欄位名稱       | 欄位說明     | 鍵類型 | 參照說明 | 是否可為空 |
| :------------- | :----------- | :----- | :------- | :--------- |
| sMethodNo      | 運送方式編號 | 主鍵   |          | 否         |
| shipmentMethod | 運送方式     |        |          | 否         |

## 關係

### **Customer — Order〈Places〉**

- **每筆 Order 都必屬於 1 個 Customer**（Order→Customer：1..1）
- **每個 Customer 最少有 1 筆 Order**（Customer→Order：1..\*）
- **外鍵**：Order.customerNo → Customer.customerNo

### **Order — Invoice〈Raises〉**

- **一對一且必須存在**
- 每張 Order 一定產生且只產生 1 張 Invoice
- 每張 Invoice 也只對應 1 筆 Order。
- **外鍵**：Invoice.orderNo → Order.orderNo

### **PaymentMethod — Invoice〈pMethodFor〉**

- **每張 Invoice 指定 1 種付款方式**（Invoice→PaymentMethod：1..1）
- **每種付款方式可用於多張 Invoice**（PaymentMethod→Invoice：1..\*）
- **外鍵**：Invoice.pMethodNo → PaymentMethod.pMethodNo

### **Employee — Order〈Processes〉**

- **每筆 Order 由 1 位 Employee 處理**（Order→Employee：1..1）
- **每位 Employee 可處理 0 或多筆 Order**（Employee→Order：0..\*）
- **外鍵**：Order.employeeNo → Employee.employeeNo

### **Order — OrderDetail〈Has〉**

- **每筆 Order 至少有 1 筆 OrderDetail**（Order→OrderDetail：1..\*）
- **每筆 OrderDetail 僅屬於 1 筆 Order**（OrderDetail→Order：1..1）
- **外鍵**：OrderDetail.orderNo → Order.orderNo

### **Product — OrderDetail〈PartOf〉**

- **每種 Product 可出現在 1 或多筆 OrderDetail**（Product→OrderDetail：1..\*）
- **每筆 OrderDetail 指定 1 種 Product**（OrderDetail→Product：1..1）
- **外鍵**：OrderDetail.productNo → Product.productNo

### **OrderDetail — Shipment〈PackagedIn〉**

- **每筆 OrderDetail 包裝於 1 次 Shipment 中**（OrderDetail→Shipment：1..1）
- **每張 Shipment 可包裝 1 或多筆 OrderDetail**（Shipment→OrderDetail：1..\*）
- **外鍵**：OrderDetail.shipmentNo → Shipment.shipmentNo

### **Employee — Shipment〈Prepares〉**

- **每張 Shipment 由 1 位 Employee 準備**（Shipment→Employee：1..1）
- **每位 Employee 可準備 0 或多張 Shipment**（Employee→Shipment：0..\*）
- **外鍵**：Shipment.employeeNo → Employee.employeeNo

### **ShipmentMethod — Shipment〈sMethodFor〉**

- **每種出貨方式可用於 1 或多張 Shipment**（ShipmentMethod→Shipment：1..\*）
- **每張 Shipment 指定 1 種出貨方式**（Shipment→ShipmentMethod：1..1）
- **外鍵**：Shipment.sMethodNo → ShipmentMethod.sMethodNo

## 依賴層次

在階段 1 同時建立所有標「1」的資料表，就能保證這些表之間沒有外鍵依賴，不會衝突。接著依序建立階段 2、3… 的資料表，就能順利完成資料表之間的結構。

1. **階段 0**：
    - Employee
2. **階段 1（無外鍵依賴）**：
    - Customer
    - PaymentMethod
    - Product
    - ShipmentMethod
3. **階段 2（只參考階段 1）**：
    - Order（外鍵參照 Customer, Employee〔Employee 在本例標為階段 0〕）
4. **階段 3（參考階段 2 + 階段 1）**：
    - OrderDetail（外鍵參照 Order, Product）
5. **階段 4（參考階段 3 + 階段 1）**：
    - Shipment（外鍵參照 OrderDetail, Employee, ShipmentMethod）
6. **階段 5（參考階段 2 + 階段 1）**：
    - Invoice（外鍵參照 Order, PaymentMethod）
