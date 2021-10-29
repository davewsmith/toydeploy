from datetime import datetime
import uuid

from app import create_app, db
from app.toy.models import ToyData


app = create_app()


@app.shell_context_processor
def make_shell_context():
    """Add context variables for `flask shell`
    """
    return {
        # app is exported automagically
        'db', db,
    }


@app.cli.command(short_help="Add a Toy")
def toy():
    toy = ToyData(created_at=datetime.now(), toy_data=str(uuid.uuid1()))
    db.session.add(toy)
    db.session.commit()
    print("Toy added")
