```toml
name = 'dsService'
method = 'GET'
url = 'http://10.118.102.247:9820/expense/v1/getExpense?user_id=a1ce3b90-dd7b-4864-be8a-a990568f3f7e'
sortWeight = 3000000
id = 'ba90d051-b0f4-49d7-a6fe-ec09b97f34c9'

[[queryParams]]
key = 'user_id'
value = 'a1ce3b90-dd7b-4864-be8a-a990568f3f7e'

[[headers]]
key = 'x-user-id'
value = 'Adarsh'

[body]
type = 'PLAIN'
raw = '''
{
  "user_id": "you have spent INR 9999 for washingmachine in blinkit"
}'''
```
