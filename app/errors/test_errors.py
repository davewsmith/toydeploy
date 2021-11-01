from app.testing import FlaskTest


class ErrorTest(FlaskTest):

    def test_404(self):
        rv = self.client.get('/nosuchroute')
        self.assertEqual(404, rv.status_code)
        self.assertTrue('/nosuchroute' in rv.get_data(as_text=True))
