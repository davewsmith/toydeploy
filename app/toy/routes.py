from flask import current_app, render_template

from app.toy import bp
from app.toy.models import ToyData


@bp.route('/')
def home():
    current_app.logger.info("proof that logging is set up")
    bindings = dict(toys=ToyData.query.all())
    return render_template("toy/home.html", **bindings)
