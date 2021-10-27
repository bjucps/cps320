# To use this, 
# pip install flask_sqlalchemy

from flask import Flask, request, abort, jsonify, Response
from werkzeug.exceptions import HTTPException
import json
import time
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///products.sqlite3'
db = SQLAlchemy(app)

# Define model class
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    description = db.Column(db.String(80), nullable=False)
    price = db.Column(db.Float, nullable=False)

    def to_dict(self):        
        # See https://stackoverflow.com/questions/7102754/jsonify-a-sqlalchemy-result-set-in-flask for a general solution
        return { 'id': self.id, 'description': self.description, 'price': self.price}

db.create_all() # Create tables from model classes

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
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products])

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

    p = Product(description=desc, price=price)
    db.session.add(p)
    db.session.commit()
        
    return jsonify(p.to_dict())

@app.route("/products/<int:product_id>", methods=['DELETE'])
def delete_product(product_id: int):
    p = Product.query.filter_by(id=product_id).first()
    if p:
        db.session.delete(p)
        db.session.commit()
        return ''
    else:
        abort(404, description=f'No product with id {product_id} exists.')

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)

