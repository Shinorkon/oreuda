"""add health and quest fields

Revision ID: 001
Revises: 
Create Date: 2026-05-31 19:55:00

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add dynamic quest fields
    op.add_column('quests', sa.Column('target_value', sa.Integer(), nullable=True))
    op.add_column('quests', sa.Column('current_value', sa.Integer(), server_default='0'))
    op.add_column('quests', sa.Column('metric_type', sa.String(), nullable=True))

    # Create health_snapshots table
    op.create_table(
        'health_snapshots',
        sa.Column('id', sa.Integer(), primary_key=True, index=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.id'), nullable=False, index=True),
        sa.Column('date', sa.Date(), nullable=False, index=True),
        sa.Column('steps', sa.Integer(), server_default='0'),
        sa.Column('calories_burned', sa.Integer(), server_default='0'),
        sa.Column('sleep_minutes', sa.Integer(), server_default='0'),
        sa.Column('resting_hr', sa.Integer(), nullable=True),
        sa.Column('workouts_count', sa.Integer(), server_default='0'),
        sa.Column('workout_volume_kg', sa.Float(), server_default='0.0'),
        sa.Column('weight_kg', sa.Float(), nullable=True),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
    )

    # Create lyfta_integrations table
    op.create_table(
        'lyfta_integrations',
        sa.Column('id', sa.Integer(), primary_key=True, index=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.id'), unique=True, nullable=False),
        sa.Column('api_key_hash', sa.String(255), nullable=False),
        sa.Column('is_active', sa.Boolean(), server_default='true'),
        sa.Column('last_sync_at', sa.DateTime(), nullable=True),
        sa.Column('workouts_imported', sa.Integer(), server_default='0'),
        sa.Column('exercises_imported', sa.Integer(), server_default='0'),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.func.now(), onupdate=sa.func.now()),
    )


def downgrade() -> None:
    op.drop_column('quests', 'target_value')
    op.drop_column('quests', 'current_value')
    op.drop_column('quests', 'metric_type')
    op.drop_table('health_snapshots')
    op.drop_table('lyfta_integrations')
