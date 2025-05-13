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
DB_NAME=order_practice
```

確認資料庫(mariaDB)是否有在運作，建立資料庫 `order_practice` (名稱可以改)
- 資料表建立參考 [table.sql](../tables.sql)
- 假資料輸入參考 [insert.sql](../insert.sql)

## Run

```bash
node index.js
```
