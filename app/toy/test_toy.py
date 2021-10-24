from flask import url_for

from app.testing import FlaskTest


class ToyTest(FlaskTest):

    def test_url_for_home(self):
        self.assertEqual('/', url_for('main.home'))

    def test_home(self):
        rv = self.client.get(url_for('main.home'))
        self.assertEqual(200, rv.status_code)
        self.assertTemplateUsed('toy/home.html')
