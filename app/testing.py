import flask_testing

from app import create_app
from config import Config


class TestConfig(Config):
    # TESTING = True
    # WTF_CSRF_ENABLED = False
    # SQLALCHEMY_DATABASE_URI = 'sqlite://'
    pass


class FlaskTest(flask_testing.TestCase):

    def create_app(self):
        return create_app(TestConfig)

    def setUp(self):
        # db.create_all()
        pass

    def tearDown(self):
        # db.session.remove()
        # db.drop_all()
        pass
