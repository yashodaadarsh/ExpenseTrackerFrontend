```toml
name = 'GetUserDetails'
method = 'POST'
url = 'http://localhost:9810/user/v1/createUpdate'
sortWeight = 5000000
id = '73be4fb2-bcd9-4136-b6f5-b16f564c8292'

[body]
type = 'JSON'
raw = '''
{
  "user_id": 'a1ce3b90-dd7b-4864-be8a-a990568f3f7e',
  "first_name": 'yashoda',
  "last_name": 'adarsh',
  "phone_number": '9849275209',
  "email": 'yashodaadarshcse@gmail.com'
}'''
```
