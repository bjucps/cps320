# TO use this:
# pip install flask
# pip install eventlet

from flask import Flask
from flask_socketio import SocketIO
from flask_socketio import send, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, logger=True, engineio_logger=True)

@socketio.on('connect')
def on_connect(auth):
    print('Client connected')
    emit('hi', {'data': 'You are now connected'})

@socketio.on('disconnect')
def on_disconnect():
    print('Client disconnected')

@socketio.on('greeting')
def on_greeting(data):
    print(f'Greeting: {data}')

@app.route("/hello", methods=['GET'])
def hello():
    return "Hello, world!"

if __name__ == '__main__':
    socketio.run(app, use_reloader=True)
