from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator
from airflow.operators.python import BranchPythonOperator
from datetime import datetime, timedelta
from airflow.models.variable import Variable
import pendulum, requests

local_tz = pendulum.timezone('Asia/Seoul')
SERVER_API = Variable.get("SERVER_API")

# 프로젝트의 모든 DAG 공통 사항 기재
default_args = {
    "owner" : "Hanul",
    "depends_on_past" : False,
    'start_date': datetime(2023, 9, 4, 15, 0, 0, tzinfo=local_tz),
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
    schedule_interval='5 * * * *',
    default_args=default_args
)


def check_db():
    api_url = f'http://{SERVER_API}/flags/404'
    response = requests.get(api_url)
    data = response.text
    if data == '0':
        return 'BLOB'
    else:
        return 'ERROR'
    
    
start = EmptyOperator(task_id="start", dag=dag)
check_flag = BranchPythonOperator(task_id='Check.Flag',python_callable=check_db, dag=dag)
blob = BashOperator(task_id = "BLOB", bash_command= f'curl http://{SERVER_API}/blob/404', dag = dag)
error = EmptyOperator(task_id = 'ERROR', dag = dag)
end = EmptyOperator(task_id="end", dag=dag)

start >> check_flag >> blob
check_flag >> error
blob >> end