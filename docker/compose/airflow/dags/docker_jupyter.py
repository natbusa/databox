from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.docker_operator import DockerOperator

default_args = {
        'owner'                 : 'airflow',
        'description'           : 'Use of the DockerOperator',
        'depend_on_past'        : False,
        'start_date'            : datetime(2018, 1, 3),
        'email_on_failure'      : False,
        'email_on_retry'        : False,
        'retries'               : 1,
        'retry_delay'           : timedelta(minutes=5)
}

with DAG('docker_jupyter', default_args=default_args, schedule_interval="5 * * * *", catchup=False) as dag:
        t2 = DockerOperator(
                task_id='docker_command',
                image='natbusa/pyspark-notebook:2.4.4-hadoop-3.2.1',
                api_version='auto',
                auto_remove=True,
                command="jupyter -h",
                docker_url="unix://var/run/docker.sock",
                network_mode="bridge"
        )

        t3 = BashOperator(
                task_id='print_hello',
                bash_command='echo "hello world"'
        )

        t2 >> t3

