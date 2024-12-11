from flask import Flask, request, jsonify
import requests
from newspaper import Article

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, Render!"

if __name__ == '__main__':
    app.run(debug=True)
