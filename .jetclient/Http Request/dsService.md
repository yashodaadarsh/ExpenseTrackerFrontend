```toml
name = 'dsService'
method = 'POST'
url = 'http://3.235.172.244:8000/v1/ds/message'
sortWeight = 3000000
id = 'ba90d051-b0f4-49d7-a6fe-ec09b97f34c9'

[[headers]]
key = 'x-user-id'
value = '47bca74d-0c93-4c80-9ea7-b4342367f7a3'

[[headers]]
key = 'X-Refresh-Token'
value = 'eeb8a17c-be2f-4329-8da3-f558a8edbb32'
disabled = true

[auth.bearer]
token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5YXNob2RhYWRhcnNoY3NlQGdtYWlsLmNvbSIsImlhdCI6MTc2ODkxNTkxOCwiZXhwIjoxNzY4OTE2ODE4fQ.U4e7dZiJdv2dnRiQWPpU3C49w5V61JrYJDUoSJfKa3o'

[body]
type = 'JSON'
raw = '''
{
  "message": "you have spent INR 9999 for washingmachine in Netflix"
}'''
```
