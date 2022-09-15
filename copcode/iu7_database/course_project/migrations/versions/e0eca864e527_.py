"""empty message

Revision ID: e0eca864e527
Revises: 4dbc0c41baca
Create Date: 2019-09-03 19:01:18.316852

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'e0eca864e527'
down_revision = '4dbc0c41baca'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('book', sa.Column('image', sa.Text(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('book', 'image')
    # ### end Alembic commands ###
