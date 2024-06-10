from flask import Flask, request, render_template, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Visitor(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    ip_address = db.Column(db.String(45), unique=True)

@app.route('/')
def index():
    visitor_ip = request.remote_addr
    visitor = Visitor.query.filter_by(ip_address=visitor_ip).first()
    
    if visitor is None:
        new_visitor = Visitor(ip_address=visitor_ip)
        db.session.add(new_visitor)
        db.session.commit()
    
    total_visitors = Visitor.query.count()
    
    return render_template('index.html', total_visitors=total_visitors)

@app.route('/version')
def version():
    return jsonify(version="1.0.0")

with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)
