from flask import Flask, request, jsonify
import requests
from newspaper import Article
from transformers import GPT2LMHeadModel, GPT2Tokenizer
import torch

app = Flask(__name__)

# Load GPT-2 Model and Tokenizer
model_name = "gpt2"
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
model = GPT2LMHeadModel.from_pretrained(model_name)

# Function to scrape article content using newspaper3k
def scrape_article(url):
    article = Article(url)
    article.download()
    article.parse()
    return article.text, article.top_image

# Function to rewrite content using GPT-2
def rewrite_content(content):
    inputs = tokenizer.encode(content, return_tensors="pt", max_length=1024, truncation=True)
    outputs = model.generate(inputs, max_length=1500, num_return_sequences=1, no_repeat_ngram_size=2)
    rewritten_content = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return rewritten_content

@app.route('/scrape', methods=['POST'])
def scrape():
    data = request.get_json()
    url = data['url']
    content, image_url = scrape_article(url)
    return jsonify({'content': content, 'image_url': image_url})

@app.route('/rewrite', methods=['POST'])
def rewrite():
    data = request.get_json()
    content = data['content']
    rewritten_content = rewrite_content(content)
    return jsonify({'rewritten_content': rewritten_content})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=10000)
