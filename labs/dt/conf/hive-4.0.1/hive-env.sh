# 1. 宣告基本環境變數
export HADOOP_HOME=/opt/zfs/sys/hadoop-3.4.3   # 請確認為你實際的 Hadoop 3.x 路徑
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export TEZ_HOME=/opt/zfs/tez
export TEZ_CONF_DIR=$HADOOP_CONF_DIR           # 你的 tez-site.xml 存放位置

# 2. 處理 Tez Jar 檔載入
# 由於部分舊版腳本對萬用字元 (*) 的解析可能會有問題，最穩妥的做法是使用迴圈將 jar 檔絕對路徑拼接起來：
export TEZ_JARS=""
for jar in `ls $TEZ_HOME | grep jar`; do
    export TEZ_JARS=$TEZ_JARS:$TEZ_HOME/$jar
done
for jar in `ls $TEZ_HOME/lib | grep jar`; do
    export TEZ_JARS=$TEZ_JARS:$TEZ_HOME/lib/$jar
done

# 去除字串最前面的冒號 (:)
TEZ_JARS=${TEZ_JARS:1}

# 3. 設置 classpath 相關變數
# 推薦做法 A：使用 HIVE_AUX_JARS_PATH (專門給 Hive 自身的擴充機制)
#export HIVE_AUX_JARS_PATH=$TEZ_JARS

# 推薦做法 B：使用 HADOOP_CLASSPATH (讓底層 Hadoop 指令也能認識 Tez)
export HADOOP_CLASSPATH=$TEZ_CONF_DIR:$TEZ_JARS:$HADOOP_CLASSPATH
