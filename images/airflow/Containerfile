ARG VER=0.0
FROM dkreg.taroko:5000/usdt.hdp341
RUN apt update && apt upgrade -y 
RUN apache-airflow-client
RUN airflow db migrate
RUN airflow users create --username admin --password admin --firstname admin --lastname admin --role Admin --email admin@example.com
