from datetime import datetime

from flask import url_for

from app import db
from app.testing import FlaskTest
from app.toy.models import ToyData


class ToyTest(FlaskTest):

    def test_url_for_home(self):
        self.assertEqual('/', url_for('toy.home'))

    def test_home(self):
        rv = self.client.get(url_for('toy.home'))
        self.assertEqual(200, rv.status_code)
        self.assertTemplateUsed('toy/home.html')

    def test_home_shows_toy_data(self):
        toy = ToyData(created_at=datetime.now(), toy_data="Kazoo")
        db.session.add(toy)
        db.session.commit()

        rv = self.client.get(url_for('toy.home'))
        self.assertTrue(b'Kazoo' in rv.data)
        # print(dir(rv))
        # self.assertEqual("", dir(rv))
