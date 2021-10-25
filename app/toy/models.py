from app import db


class ToyData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, index=True)
    toy_data = db.Column(db.String(255))
