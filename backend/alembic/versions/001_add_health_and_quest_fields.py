"""add health and quest fields

Revision ID: 001
Revises: 
Create Date: 2026-05-31 19:55:00

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create health_snapshots table (new)
    op.create_table(
        'health_snapshots',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('date', sa.Date(), nullable=False),
        sa.Column('steps', sa.Integer(), server_default='0'),
        sa.Column('calories_burned', sa.Integer(), server_default='0'),
        sa.Column('sleep_minutes', sa.Integer(), server_default='0'),
        sa.Column('resting_hr', sa.Integer(), nullable=True),
        sa.Column('workouts_count', sa.Integer(), server_default='0'),
        sa.Column('workout_volume_kg', sa.Float(), server_default='0.0'),
        sa.Column('weight_kg', sa.Float(), nullable=True),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.text('NOW()')),
        sa.PrimaryKeyConstraint('id'),
    )
    op.create_index('ix_health_snapshots_user_id', 'health_snapshots', ['user_id'])
    op.create_index('ix_health_snapshots_date', 'health_snapshots', ['date'])

    # Create lyfta_integrations table (new)
    op.create_table(
        'lyfta_integrations',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('api_key_hash', sa.String(255), nullable=False),
        sa.Column('is_active', sa.Boolean(), server_default='true'),
        sa.Column('last_sync_at', sa.DateTime(), nullable=True),
        sa.Column('workouts_imported', sa.Integer(), server_default='0'),
        sa.Column('exercises_imported', sa.Integer(), server_default='0'),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('NOW()')),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.text('NOW()')),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('user_id'),
    )

    # Add columns to quests table if they don't exist
    from sqlalchemy import inspect
    conn = op.get_bind()
    inspector = inspect(conn)
    columns = [c['name'] for c in inspector.get_columns('quests')] if 'quests' in inspector.get_table_names() else []

    if 'target_value' not in columns:
        op.add_column('quests', sa.Column('target_value', sa.Integer(), nullable=True))
    if 'current_value' not in columns:
        op.add_column('quests', sa.Column('current_value', sa.Integer(), server_default='0'))
    if 'metric_type' not in columns:
        op.add_column('quests', sa.Column('metric_type', sa.String(), nullable=True))


def downgrade() -> None:
    op.drop_table('health_snapshots')
    op.drop_table('lyfta_integrations')
    op.drop_column('quests', 'target_value')
    op.drop_column('quests', 'current_value')
    op.drop_column('quests', 'metric_type')
