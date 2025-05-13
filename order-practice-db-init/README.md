# Order Practice Database Initialization

## Prerequisites

- 已安裝 MariaDB，且加進環境變數中
- 開啟 MySQL 

## Setup

注意 `init_db.sql` 路徑。

```bash
mysql -u <username> -p < init_db.sql

# PowerShell
Get-Content .\init_db.sql | mysql -u root -p
```

## Project Structure

- `scripts/init_db.sql`： 創建資料庫
- `scripts/tables.sql`： 資料表建立
- `scripts/data.sql`： 模擬資料
