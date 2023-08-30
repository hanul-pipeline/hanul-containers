from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator
from datetime import datetime, timedelta
import pendulum

local_tz = pendulum.timezone('Asia/Seoul')

# 프로젝트의 모든 DAG 공통 사항 기재
default_args = {
    "owner" : "Hanul",
    "depends_on_past" : True,
    'start_date': datetime(2023, 8, 16, tzinfo=local_tz),
    "retries" : 3,
    "retry_delay" : timedelta(seconds=15)
}

# 프로젝트마다 변동될 DAG 사항들 기재
dag = DAG(
    'hanul-airflow',
    description='Test DAG',
    tags=['hanul', 'curl', 'gcs'],
    max_active_runs=1, # 동시에 실행되는 DAG의 수
    concurrency=1, # 동시에 실행되는 작업의 수
    schedule_interval='*/30 * * * *',
    user_defined_macros={},
    default_args=default_args
)

start = EmptyOperator(
    task_id="start",
    dag=dag
)


