```toml
name = 'GetUserDetails'
method = 'POST'
url = 'http://3.235.172.244:8000/user/v1/createUpdate'
sortWeight = 5000000
id = '73be4fb2-bcd9-4136-b6f5-b16f564c8292'

[auth.bearer]
token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ5YXNob2RhYWRhcnNoY3NlQGdtYWlsLmNvbSIsImlhdCI6MTc2ODkxODcwOCwiZXhwIjoxNzY4OTE5NjA4fQ.HKKXGschqxoGfkWkk1JQodOFg_anBNijtRucHukg2Pk'

[body]
type = 'JSON'
raw = '''
{
  "user_id": '406b3b57-95ba-421d-84fe-23803da12d7e',
  "first_name": 'yashoda',
  "last_name": 'adarsh',
  "phone_number": '9849275209',
  "email": 'yashodaadarshcse5@gmail.com'
}'''
```
