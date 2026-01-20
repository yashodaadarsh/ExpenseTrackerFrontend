```toml
name = 'Login'
method = 'POST'
url = 'http://3.235.172.244:8000/auth/v1/login'
sortWeight = 2000000
id = 'a2e3f6dc-a9db-4418-8861-f5e6797f64de'

[auth]
type = 'NO_AUTH'

[body]
type = 'JSON'
raw = '''
{
  username: 'yashodaadarshcse@gmail.com',
  password: '1234',
  first_name: 'yashoda',
  last_name: 'adarsh'
}'''
```
