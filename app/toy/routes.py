from flask import current_app, render_template

from app.toy import bp


@bp.route('/')
def home():
    current_app.logger.info("proof that logging is set up")
    bindings = dict()
    return render_template("toy/home.html", **bindings)
