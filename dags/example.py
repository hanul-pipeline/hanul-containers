from datetime import datetime, timedelta
import pendulum

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator

local_tz = pendulum.timezone('Asia/Seoul')

# 프로젝트의 모든 DAG 공통 사항 기재
default_args = {
    "owner" : "Hanul",
    "depends_on_past" : True,
    "retries" : 1,
    "retry_delay" : timedelta(minutes=1)
}

# 프로젝트마다 변동될 DAG 사항들 기재
dag = DAG(
    dag_id='example',
    description='Test DAG',
    tags=['exaple', 'start', 'todo'],
    max_active_runs=1, # 동시에 실행되는 DAG의 수
    concurrency=1, # 동시에 실행되는 작업의 수
    start_date=datetime(year=2023, month=8, day=7, hour=0, minute=0, tzinfo=local_tz),
    schedule_interval='*/30 * * * *',
    user_defined_macros={},
    default_args=default_args
)

start = EmptyOperator(
    task_id="start",
    dag=dag
)

echo = BashOperator(
    task_id="echo",
    bash_command="""
    echo "Hello, World!"    
    """,
    dag=dag
)

def branch_func():
    pass
branch = BranchPythonOperator(
    task_id="branch",
    python_callable=branch_func,
    dag=dag
)

end = EmptyOperator(
    task_id="end",
    dag=dag
)

start >> echo >> branch >> end