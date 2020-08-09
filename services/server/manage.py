from flask.cli import FlaskGroup

from .project import create_app, db
from .project.api.models import Book


app = create_app()
cli = FlaskGroup(create_app=create_app)


@cli.command('recreate_db')
def recreate_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command('seed_db')
def seed_db():
    """Seeds the database."""
    db.session.add(Book(
        title='Effective DevOps: Building a Culture of Collaboration, Affinity, and Tooling at Scale',
        author='Jennifer Davis, Ryn Daniels',
        read=False
    ))
    db.session.add(Book(
        title='Practical DevOps',
        author='Joakim Verona',
        read=False
    ))
    db.session.add(Book(
        title='Site Reliability Engineering',
        author='Niall Murphy, Betsy Beyer, Chris Jones, Jennifer Petoff',
        read=False
    ))
    db.session.add(Book(
        title='The DevOps HandBook',
        author='Gene Kim, Jez Humble, John Willis, and Patrick, Debois',
        read=False
    ))
    db.session.add(Book(
        title='Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation',
        author='Jez Humble and David Farley',
        read=False
    ))
    db.session.commit()


if __name__ == '__main__':
    cli()
