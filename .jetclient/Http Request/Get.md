```toml
name = 'Get'
method = 'POST'
url = 'http://10.118.102.247:9898/auth/v1/refreshToken'
sortWeight = 1000000
id = '8e0cecb1-6120-4b0d-920f-c6aa560aed95'

[[headers]]
key = 'Authorization'
value = 'Bearer 1f8bced4-0973-47aa-9e70-4367d27ab8c3'
disabled = true

[auth]
type = 'NO_AUTH'

[body]
type = 'JSON'
raw = '''
{
  "token":"d1dd6866-b7a7-4822-874d-2b304acb9438"
}'''
```
