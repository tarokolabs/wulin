import pyspark
from pyspark.sql import SparkSession
conf = (
    pyspark.SparkConf()
        .setAppName('iceberg')
        .set('spark.jars.packages', 'org.apache.iceberg:iceberg-spark-runtime-3.5_2.12-1.7.1')
        .set('spark.sql.extensions', 'org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions')
        .set('spark.sql.catalog.iceberg', 'org.apache.iceberg.spark.SparkCatalog')
        .set('spark.sql.catalog.iceberg.type', 'hadoop')
        .set('spark.sql.catalog.iceberg.warehouse', 'iceberg-warehouse')
)
## Start Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()
df = spark.read.parquet("yellow_tripdata_2022-11.parquet")
df.writeTo("iceberg.nyc_yellowtaxi_tripdata").append()
