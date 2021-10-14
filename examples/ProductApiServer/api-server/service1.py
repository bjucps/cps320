from flask import Flask, request, abort, jsonify, Response
import json

app = Flask(__name__)

nextProductId = 0

class Product:
    def __init__(self, description: str, price: float):
        global nextProductId
        self.id = nextProductId
        self.description = description
        self.price = price
        nextProductId += 1
    def to_dict(self):
        return  vars(self)

product_db = [
    Product("Dental Floss", .89),
    Product("Olive Garden Salad Dressing", 2.50)
]

@app.route("/products", methods=['GET'])
def product_list():
    products = [product.to_dict() for product in product_db]
    return jsonify(products)

@app.route("/products", methods=['POST'])
def create_product():
    product_dict = request.get_json()
    desc = product_dict['description']
    price = float(product_dict['price'])
    
    p = Product(desc, price)
    product_db.append(p)
    return jsonify(p.to_dict())

@app.route("/products/<int:product_id>", methods=['DELETE'])
def delete_product(product_id: int):
    for (inx, item) in enumerate(product_db):
        if item.id == product_id:
            product_db.pop(inx)
            return

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)

