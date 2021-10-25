from flask import Blueprint

bp = Blueprint('toy', __name__, template_folder='templates')

from app.toy import routes  # noqa
from app.toy import models  # noqa
