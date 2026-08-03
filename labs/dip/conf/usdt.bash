#!/usr/bin/env bash
export POD_NAMESPACE=default
export KUBERNETES_SERVICE_PORT=443
export KUBERNETES_SERVICE_HOST=kubernetes.default
export KUBERNETES_SERVICE_PORT_HTTPS=443
export NOW="--force --grace-period 0"
export KUBE_EDITOR="nano"
export TZ=Asia/Taipei

alias kg='kubectl get'
alias ka='kubectl apply'
alias kd='kubectl delete'
alias kt='kubectl top'
alias ks='kubectl get all -n kube-system'
alias kt='kubectl top'
alias kk='kubectl krew'
alias kp="kubectl get pods -o wide -A | sed 's/(.*)//' | tr -s ' ' | cut -d ' ' -f 1,2,4,7 | column -t"
alias dkimg='curl -X GET -s -u bigred:bigred http://dkreg.taroko:5000/v2/_catalog | jq ".repositories[]"'
alias kgip="kubectl get pod --template '{{.status.podIP}}'"
alias pingdup='sudo arping -D -I eth0 -c 2 '
alias ping='ping -c 4'
alias nano='nano -Ynone'
alias dir='ls -alh'
alias ssh='ssh -q'

adminuser=bigred
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
export HADOOP_HOME=/opt/zfs/sys/hadoop-3.4.1
export HADOOP_LOG_DIR=/tmp
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
# export HADOOP_USER_CLASSPATH_FIRST=true
[ -z $HADOOP_USER_NAME ] && [ $SHELL == '/bin/bash' ] && declare -r HADOOP_USER_NAME=$USER

# JobHistory log file path, 會自動產生目錄
export HADOOP_MAPRED_LOG_DIR="/tmp/jhslog"

export YARN_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
#export YARN_LOG_DIR=/tmp

# hadoop 3.2.1 及 3.1.3 這二個版本只要執行檔案傳送命令就會出現以下訊息
# hadoop fs -put -f /etc/passwd /tmp
# SASL encryption trust check: localHostTrusted = false, remoteHostTrusted = false
export HADOOP_ROOT_LOGGER="WARN,console"

export HIVE_HOME=/opt/zfs/sys/apache-hive-4.0.1-bin
export PIG_HOME=/opt/zfs/sys/pig-0.17.0
export PATH=/home/bigred/wulin/wk/dip/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PIG_HOME/bin:$HIVE_HOME/bin

export HBASE_HOME=/opt/zfs/sys/hbase-2.5.10
export HBASE_CONF_DIR=/opt/zfs/sys/hbase-2.5.10/conf
export ZOOKEEPER_HOME=/opt/zfs/sys/apache-zookeeper-3.8.4-bin
export ZOO_LOG_DIR=/tmp/logs
export PHOENIX_HOME=/opt/zfs/sys/phoenix-hbase-2.5-5.2.1-bin
export PATH=$PATH:$PHOENIX_HOME/bin:$ZOOKEEPER_HOME/bin:$HBASE_HOME/bin

export SPARK_HOME=/opt/zfs/sys/spark-3.4.4-bin-hadoop3
export SPARK_CONF_DIR=$SPARK_HOME/conf
export PYSPARK_PYTHON=/usr/bin/python3
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

([ "$USER" == "bigred" ] || [ "$USER" == "" ]) && env | grep -E '^PATH|HADOOP_HOME|HADOOP_LOG_DIR|HADOOP_CONF_DIR|JAVA_HOME|SPARK_HOME|HBASE_HOME' | sudo tee /etc/environment &>/dev/null

netstat -anp |  grep 0.0.0.0:8888 &>/dev/null
if [ "$?" != "0" ]; then
   which jupyter &>/dev/null
   if [ "$?" == "0" ]; then
      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
         --ServerApp.terminado_settings="shell_command=['/bin/bash']" \
         --FileContentsManager.delete_to_trash=False
   fi
fi
