```toml
name = 'AddExpense'
method = 'GET'
url = 'http://3.235.172.244:8000/expense/v1/getExpense'
sortWeight = 4000000
id = 'a8d2b16f-d9a1-4c1a-a02b-8218972d61d3'

[[queryParams]]
key = 'user_id'
value = '47bca74d-0c93-4c80-9ea7-b4342367f7a3'
disabled = true

[[headers]]
key = 'x-user-id'
value = '47bca74d-0c93-4c80-9ea7-b4342367f7a3'
disabled = true

[auth.bearer]
token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5YXNob2RhYWRhcnNoY3NlQGdtYWlsLmNvbSIsImlhdCI6MTc2ODkxNTkxOCwiZXhwIjoxNzY4OTE2ODE4fQ.U4e7dZiJdv2dnRiQWPpU3C49w5V61JrYJDUoSJfKa3o'

[body]
type = 'JSON'
raw = '{"external_id":null,"amount":"250","user_id":null,"merchant":"Uber","currency":"INR","created_at":"2026-01-19T00:19:03.223415"}'
```
