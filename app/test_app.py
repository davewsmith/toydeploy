from app.testing import FlaskTest


class AppTest(FlaskTest):

    def test_home_route(self):
        # Regardless of which blueprint provides it, `/` goes somewhere
        rv = self.client.get('/')
        self.assertEqual(200, rv.status_code)
