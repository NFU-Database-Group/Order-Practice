# 訂單系統練習

> [!NOTE]
> - 要求：參見附錄E，於一周內建立簡單的 `庫存管理` 與 `訂單系統` (期限 05/14/25)  
> - 加分項目：自動化處理，系統非被動被呼叫

## 摘要

- 客戶（Customer）下訂單（Order），每筆訂單都要有人員（Employee）確認並處理。
- 處理完成後，對每筆訂單產生一張發票（Invoice），並記錄用戶選擇的付款方式（PaymentMethod）。
- 訂單透過訂單明細（OrderDetail）細分每種商品（Product）與數量，並最終包裝成一或多張出貨單（Shipment），由某位員工負責準備，且標明出貨方式（ShipmentMethod）。

## 主要實體

| 實體名稱 | 主鍵 | 備註 |
| --- | --- | --- |
| **Customer** | customerNo | 客戶檔，記錄客戶編號／名稱／聯絡資訊等。 |
| **Order** | orderNo | 訂單檔，記錄訂單編號、日期、狀態等。 |
| **Invoice** | invoiceNo | 發票檔，對應每張訂單的開立發票。 |
| **PaymentMethod** | pMethodNo | 付款方式檔（如現金、信用卡、轉帳…）。 |
| **OrderDetail** | (複合主鍵) | 訂單明細檔，通常用 orderNo + productNo 作為複合主鍵，並記錄數量、單價等。 |
| **Product** | productNo | 商品檔，記錄商品編號、名稱、價格、庫存等。 |
| **Shipment** | shipmentNo | 出貨檔，記錄出貨編號、日期、狀態等。 |
| **ShipmentMethod** | sMethodNo | 出貨方式檔（如宅配、超商取貨…）。 |
| **Employee** | employeeNo | 員工檔，記錄處理訂單或出貨的員工資訊。 |

## 資料表

### Customer

| 欄位名稱         | 鍵類型    | 參照說明 |
|:-----------------|:----------|:---------|
| customerNo       | 主鍵      |          |
| customerName     |           |          |
| customerStreet   |           |          |
| customerCity     |           |          |
| customerState    |           |          |
| customerZipCode  |           |          |
| custTelNo        | 替代鍵    |          |
| custFaxNo        | 替代鍵    |          |
| DOB              |           |          |
| maritalStatus    |           |          |
| creditRating     |           |          |

### Employee

| 欄位名稱              | 鍵類型       | 參照說明 |
|:----------------------|:------------|:---------|
| employeeNo            | 主鍵        |          |
| title                 |             |          |
| firstName             |             |          |
| middleName            |             |          |
| lastName              |             |          |
| address               |             |          |
| workTelExt            |             |          |
| homeTelNo             |             |          |
| empEmailAddress       |             |          |
| socialSecurityNumber  | 替代鍵      |          |
| DOB                   |             |          |
| position              |             |          |
| sex                   |             |          |
| salary                |             |          |
| dateStarted           |             |          |

### Invoice

| 欄位名稱     | 鍵類型   | 參照說明                      |
|:--------------|:---------|:------------------------------|
| invoiceNo     | 主鍵     |                               |
| dateRaised    |          |                               |
| datePaid      |          |                               |
| creditCardNo  |          |                               |
| holdersName   |          |                               |
| expiryDate    |          |                               |
| orderNo       | 外鍵     | 參照 Order(orderNo)           |
| pMethodNo     | 外鍵     | 參照 PaymentMethod(pMethodNo) |

### Order

| 欄位名稱        | 鍵類型   | 參照說明                         |
|:----------------|:---------|:---------------------------------|
| orderNo         | 主鍵     |                                  |
| orderDate       |          |                                  |
| billingStreet   |          |                                  |
| billingCity     |          |                                  |
| billingState    |          |                                  |
| billingZipCode  |          |                                  |
| promisedDate    |          |                                  |
| status          |          |                                  |
| customerNo      | 外鍵     | 參照 Customer(customerNo)        |
| employeeNo      | 外鍵     | 參照 Employee(employeeNo)        |

### OrderDetail

| 欄位名稱         | 鍵類型          | 參照說明                        |
|:-----------------|:----------------|:--------------------------------|
| orderNo          | 主鍵、外鍵      | 參照 Order(orderNo)             |
| productNo        | 主鍵、外鍵      | 參照 Product(productNo)         |
| quantityOrdered  |                 |                                 |

### PaymentMethod

| 欄位名稱       | 鍵類型   | 參照說明 |
|:---------------|:---------|:---------|
| pMethodNo      | 主鍵     |          |
| paymentMethod  |          |          |

### Product

| 欄位名稱         | 鍵類型     | 參照說明 |
|:-----------------|:-----------|:---------|
| productNo        | 主鍵       |          |
| productName      |            |          |
| serialNo         | 替代鍵     |          |
| unitPrice        |            |          |
| quantityOnHand   |            |          |
| reorderLevel     |            |          |
| reorderQuantity  |            |          |
| reorderLeadTime  |            |          |

### Shipment

| 欄位名稱        | 鍵類型     | 參照說明                                      |
|:----------------|:-----------|:-----------------------------------------------|
| shipmentNo      | 主鍵       |                                                |
| quantity        |            |                                                |
| shipmentDate    |            |                                                |
| completeStatus  |            |                                                |
| orderNo         | 外鍵       | 參照 OrderDetail(orderNo, productNo)           |
| productNo       | 外鍵       | 參照 OrderDetail(orderNo, productNo)           |
| employeeNo      | 外鍵       | 參照 Employee(employeeNo)                      |
| sMethodNo       | 外鍵       | 參照 ShipmentMethod(sMethodNo)                 |

### ShipmentMethod

| 欄位名稱        | 鍵類型   | 參照說明 |
|:----------------|:---------|:---------|
| sMethodNo       | 主鍵     |          |
| shipmentMethod  |          |          |

## 關係

### **Customer — Order〈Places〉**

- **每筆 Order都必屬於 1 個 Customer**（Order→Customer：1..1）
- **每個 Customer 最少有 1 筆 Order**（Customer→Order：1..*）
- **外鍵**：Order.customerNo → Customer.customerNo

### **Order — Invoice〈Raises〉**

- **一對一且必須存在**
- 每張 Order 一定產生且只產生 1 張 Invoice
- 每張 Invoice 也只對應 1 筆 Order。
- **外鍵**：Invoice.orderNo → Order.orderNo

### **PaymentMethod — Invoice〈pMethodFor〉**

- **每張 Invoice 指定 1 種付款方式**（Invoice→PaymentMethod：1..1）
- **每種付款方式可用於多張 Invoice**（PaymentMethod→Invoice：1..*）
- **外鍵**：Invoice.pMethodNo → PaymentMethod.pMethodNo

### **Employee — Order〈Processes〉**

- **每筆 Order 由 1 位 Employee 處理**（Order→Employee：1..1）
- **每位 Employee 可處理 0 或多筆 Order**（Employee→Order：0..*）
- **外鍵**：Order.employeeNo → Employee.employeeNo

### **Order — OrderDetail〈Has〉**

- **每筆 Order 至少有 1 筆 OrderDetail**（Order→OrderDetail：1..*）
- **每筆 OrderDetail 僅屬於 1 筆 Order**（OrderDetail→Order：1..1）
- **外鍵**：OrderDetail.orderNo → Order.orderNo

### **Product — OrderDetail〈PartOf〉**

- **每種 Product 可出現在 1 或多筆 OrderDetail**（Product→OrderDetail：1..*）
- **每筆 OrderDetail 指定 1 種 Product**（OrderDetail→Product：1..1）
- **外鍵**：OrderDetail.productNo → Product.productNo

### **OrderDetail — Shipment〈PackagedIn〉**

- **每筆 OrderDetail 包裝於 1 次 Shipment 中**（OrderDetail→Shipment：1..1）
- **每張 Shipment 可包裝 1 或多筆 OrderDetail**（Shipment→OrderDetail：1..*）
- **外鍵**：OrderDetail.shipmentNo → Shipment.shipmentNo

### **Employee — Shipment〈Prepares〉**

- **每張 Shipment 由 1 位 Employee 準備**（Shipment→Employee：1..1）
- **每位 Employee 可準備 0 或多張 Shipment**（Employee→Shipment：0..*）
- **外鍵**：Shipment.employeeNo → Employee.employeeNo

### **ShipmentMethod — Shipment〈sMethodFor〉**

- **每種出貨方式可用於 1 或多張 Shipment**（ShipmentMethod→Shipment：1..*）
- **每張 Shipment 指定 1 種出貨方式**（Shipment→ShipmentMethod：1..1）
- **外鍵**：Shipment.sMethodNo → ShipmentMethod.sMethodNo

## 依賴層次

在階段1同時建立所有標「1」的資料表，就能保證這些表之間沒有外鍵依賴，不會衝突。接著依序建立階段 2、3… 的資料表，就能順利完成資料表之間的結構。

1. **階段 1（無外鍵依賴）**：
    - Customer
    - PaymentMethod
    - Product
    - ShipmentMethod
2. **階段 2（只參考階段 1）**：
    - Order（外鍵參照 Customer, Employee〔Employee 在本例標為階段 0〕）
3. **階段 3（參考階段 2 + 階段 1）**：
    - OrderDetail（外鍵參照 Order, Product）
4. **階段 4（參考階段 3 + 階段 1）**：
    - Shipment（外鍵參照 OrderDetail, Employee, ShipmentMethod）
5. **階段 5（參考階段 2 + 階段 1）**：
    - Invoice（外鍵參照 Order, PaymentMethod）
