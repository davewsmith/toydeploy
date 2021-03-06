from logging.config import dictConfig
import os

from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy

from config import Config


db = SQLAlchemy()
migrate = Migrate()


style_css_path = os.path.join(os.path.dirname(__file__), 'static', 'style.css')
style_css_mtime = int(os.stat(style_css_path).st_mtime)


def create_app(config_class=Config):
    dictConfig({
        'version': 1,
        'disable_existing_loggers': True,
        'formatters': {
            'default': {
                'format': '[%(asctime)s]'
                          ' %(levelname)s'
                          ' in %(module)s.%(funcName)s:'
                          ' %(message)s',
            }
        },
        'handlers': {
            'wsgi': {
                'class': 'logging.StreamHandler',
                'formatter': 'default'
            }
        },
        'loggers': {
            '': {
                'level': 'DEBUG',
                'handlers': ['wsgi'],
            },
        }
    })

    app = Flask(__name__)
    app.config.from_object(config_class)

    db.init_app(app)
    if app.config['SQLALCHEMY_DATABASE_URI'].startswith('sqlite'):
        # Enable SQLite3 foreign key support so that deletes will cascade
        from sqlalchemy import event  # noqa
        from sqlalchemy.engine import Engine  # noqa

        @event.listens_for(Engine, "connect")
        def _set_sqlite_pragma(dbapi_connection, connection_record):
            cursor = dbapi_connection.cursor()
            cursor.execute("PRAGMA foreign_keys=ON;")
            cursor.close()

    migrate.init_app(app, db)

    from app.errors import bp as errors_bp  # noqa
    app.register_blueprint(errors_bp)

    from app.toy import bp as toy_bp  # noqa
    app.register_blueprint(toy_bp)

    @app.context_processor
    def cache_busters():
        return {
            'style_css_mtime': style_css_mtime,
        }

    return app
