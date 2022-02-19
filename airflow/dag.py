from datetime import datetime, timedelta

from pendulum.tz.timezone import Timezone

from airflow import DAG
from airflow.operators.bash import BashOperator


default_args = {
    "owner": "subsurface",
    "depends_on_past": False,
    "retries": 0
}

with DAG(
    dag_id='DB_DAG',
    description="""
        DAG created for subsurface conference. Contains several Bash tasks
        that result in individual TaskInstances on the Kubernetes platform.
        Purpose is to show the number of connections made with the database.
    """,
    schedule_interval=None,
    start_date=datetime(2022, 1, 1, tzinfo=Timezone('Europe/Amsterdam')),
    dagrun_timeout=timedelta(minutes=30),
    catchup=False,
    is_paused_upon_creation=False,
    default_args=default_args,
    tags=['subsurface', 'db-check']
) as d:
    t1 = BashOperator(
        task_id="bash_1",
        bash_command="sleep 10",
        skip_exit_code=None
    )

    t2 = BashOperator(
        task_id="bash_2",
        bash_command="sleep 10",
        skip_exit_code=None
    )

    t3 = BashOperator(
        task_id="bash_3",
        bash_command="sleep 30",
        skip_exit_code=None
    )

    [t1, t2] >> t3
