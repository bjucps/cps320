import requests

product = { "description": "Sour cream", "price": '1.5' }

r = requests.post("http://localhost:5000/products", json=product)
print(f'Response code: {r.status_code}\n{r.text}')
