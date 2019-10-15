from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.docker_operator import DockerOperator
from airflow.operators.python_operator import BranchPythonOperator
from airflow.operators.dummy_operator import DummyOperator

import os.path

default_args = {
    'owner'         : 'airflow',
    'description'       : 'Use of the DockerOperator',
    'depend_on_past'    : False,
    'start_date'        : datetime(2018, 1, 3),
    'email_on_failure'      : False,
    'email_on_retry'    : False,
    'retries'           : 1,
    'retry_delay'       : timedelta(minutes=5)
}

def checkIfRepoIsAlreadyCloned():
    if os.path.exists('/usr/local/airflow/repos/tutorial'):
        return 'dummy'
    return 'git_clone'

with DAG(
    'docker_git_spark',
    default_args=default_args,
    schedule_interval="5 * * * *",
    catchup=False) as dag:

    t_git_clone = BashOperator(
        task_id='git_clone',
        bash_command='git clone https://github.com/natbusa/dlf-tutorial /usr/local/airflow/repos/tutorial'
    )

    t_git_pull = BashOperator(
        task_id='git_pull',
        bash_command='cd /usr/local/airflow/repos/tutorial && git pull',
        trigger_rule='one_success'
    )

    t_check_repo = BranchPythonOperator(
        task_id='does_repo_exist',
        python_callable=checkIfRepoIsAlreadyCloned
    )

    t_dummy = DummyOperator(
        task_id='dummy'
    )

    t_check_repo >> t_git_clone >> t_git_pull
    t_check_repo >> t_dummy >> t_git_pull

    t_docker = DockerOperator(
        task_id='docker_command',
        image='natbusa/pyspark-notebook:2.4.4-hadoop-3.2.1',
        api_version='auto',
        auto_remove=True,
        environment={
        },
        volumes=['airflow_repos:/home/jovyan/work/repos'],
        command='spark-submit --master spark://spark-master:7077 /home/jovyan/work/repos/tutorial/minimal.py',
        docker_url='unix://var/run/docker.sock',
        network_mode='datalabframework'
    )

    t_git_pull >> t_docker

