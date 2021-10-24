from logging.config import dictConfig
import os

from flask import Flask

from config import Config


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

    from app.toy import bp as toy_bp  # noqa
    app.register_blueprint(toy_bp)

    @app.context_processor
    def cache_busters():
        return {
            'style_css_mtime': style_css_mtime,
        }

    return app
