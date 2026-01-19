```toml
name = 'AddExpense'
method = 'POST'
url = 'http://10.118.102.247:9820/expense/v1/addExpense'
sortWeight = 4000000
id = 'a8d2b16f-d9a1-4c1a-a02b-8218972d61d3'

[[headers]]
key = 'X-User-Id'
value = 'a1ce3b90-dd7b-4864-be8a-a990568f3f7e'

[body]
type = 'JSON'
raw = '{"external_id":null,"amount":"250","user_id":null,"merchant":"Uber","currency":"INR","created_at":"2026-01-19T00:19:03.223415"}'
```
