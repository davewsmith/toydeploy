from flask import Blueprint

bp = Blueprint('main', __name__, template_folder='templates')

from app.toy import routes  # noqa
