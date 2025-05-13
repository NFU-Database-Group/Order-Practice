# How to use it?

## Preparation

首先確定有 `node` 和 `npm` 

```bash
node -v # 參考 v20.17.0
npm -v  # 參考 11.3.0
```

下載依賴項目

```bash
npm install
```

設定環境變數，在根目錄下建立 `.env`，其中需包含以下四項：

```env
DB_HOST=<your-host> #e.g. localhost
DB_USER=<your-username> #請確認此使用者有權限讀取目標資料庫(order_practice)
DB_PASS=<your-passowrd>
DB_NAME=order_practice_db
```

確認資料庫(mariaDB)是否有在運作，建立資料庫 `order_practice_db` (名稱可以改)
- 資料表依賴層次參考 [討論#1](https://github.com/NFU-Database-Group/Order-Practice/discussions/1#discussioncomment-13127160)
- 參考 [資料表建立說明](../order-practice-db-init/README.md)
    - [資料表建立SQL](../order-practice-db-init/scripts/tables.sql)
    - [模擬資料輸入SQL](../order-practice-db-init/scripts/data.sql)

## Run

程式與資料互動細節參考 [detail.md](./detail.md)

```bash
node order_system.js # 訂單管理系統 / 用戶下單
node inventory_manager.js # 庫存管理系統

# or
npm run dev:all #參見package.json
```
