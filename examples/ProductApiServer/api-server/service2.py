from flask import Flask, request, abort, jsonify, Response
from werkzeug.exceptions import HTTPException
import json
import time
from threading import Lock

app = Flask(__name__)

lock = Lock()

nextProductId = 0

class Product:
    def __init__(self, description: str, price: float):
        global nextProductId
        self.id = nextProductId
        self.description = description
        self.price = price
        nextProductId += 1
    def to_dict(self):
        time.sleep(1)
        print(vars(self))
        return  vars(self)

product_db = [
    Product("Dental Floss", .89),
    Product("Olive Garden Salad Dressing", 2.50)
]

# ----------------------------------------
# Central error handler. 
# Converts abort() and unhandled application exceptions to JSON responses, and logs them
# ----------------------------------------
@app.errorhandler(Exception)
def handle_error(e):
    
    if isinstance(e, HTTPException):
        return jsonify(error=str(e)), e.code

    # An unhandled exception was thrown ... log the details
    data = request.json if request.json else request.data
    app.logger.error('%s %s\nRequest body: %s\n', request.method, request.full_path, data, exc_info=e)

    return jsonify(error=str(e)), 500

@app.before_request
def start_request():
    app.logger.warning('%s %s - Starting request processing', request.method, request.full_path)

@app.route("/products", methods=['GET'])
def product_list():
    products = [product.to_dict() for product in product_db]
    return jsonify(products)

@app.route("/products", methods=['POST'])
def create_product():
    product_dict = request.get_json()
    try:
        desc = product_dict['description']
        price = float(product_dict['price'])
        if price < 0:
            abort(400, description=f'Price may not be negative.')
    except Exception as e:
        abort(400, description=f'Invalid request: {e}')
    

    with lock:
        matching_products = [p for p in product_db
                             if p.description == desc]
        if len(matching_products) == 1:
            abort(400, description=f'Duplicate description.')

        p = Product(desc, price)
        product_db.append(p)
        
    return jsonify(p.to_dict())

@app.route("/products/<int:product_id>", methods=['DELETE'])
def delete_product(product_id: int):
    for (inx, item) in enumerate(product_db):
        if item.id == product_id:
            product_db.pop(inx)
            return ''

    abort(404, description=f'No product with id {product_id} exists.')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)

