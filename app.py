from flask import Flask, jsonify
from newspaper import Article

app = Flask(__name__)

def scrape_article(url):
    article = Article(url)
    article.download()
    article.parse()
    return article.text

@app.route('/scrape', methods=['GET'])
def scrape():
    url = 'https://example.com/your-article-url'
    result = scrape_article(url)
    return jsonify({'scraped_text': result})

if __name__ == '__main__':
    app.run(debug=True)
