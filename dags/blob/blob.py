from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': True,
    'start_date': datetime(2023, 8, 16),
    'retries': 3,
     "retry_delay" : timedelta(seconds=15)
}
test_dag = DAG(
    'hanul-airflow',
    description='Test DAG',
    tags=['hanul', 'curl', 'gcs'],
    max_active_runs=1, # 동시에 실행되는 DAG의 수
    concurrency=1, # 동시에 실행되는 작업의 수
    default_args=default_args,
    schedule_interval = '0 * * * *' # 한시간마다 진행
)
start = EmptyOperator(
    task_id='start',
    bash_command="""
        echo "Start";
    """
)
read_bash = BashOperator(
    task_id='read_python',
    bash_commad = """
        python3 curl.py /hanul/
    """,
    dag =test_dag
)
curl_bash = BashOperator(
    task_id='curl',
    bash_commad = """
        curl 'localhost:9000/test?'
    """,
    dag =test_dag
)

end= EmptyOperator(
    task_id='END',
    bash_command="""
        echo "End"
    """
)


start >> read_bash >> end
start >> curl_bash >> end