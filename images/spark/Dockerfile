From quay.io/cloudwalker/spark-py:24.01
COPY hadoop-aws-3.3.4.jar aws-java-sdk-bundle-1.12.694.jar /opt/spark/jars/
RUN pip install numpy 
USER root
RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo bash wget curl nano tree && \
    curl -sSL https://d.juicefs.com/install | sh -
