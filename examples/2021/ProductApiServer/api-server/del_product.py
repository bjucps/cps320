import requests

r = requests.delete("http://localhost:5000/products/1")
print(f'Response code: {r.status_code}\n{r.text}')
