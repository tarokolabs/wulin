import pyspark
from pyspark.sql import SparkSession

conf = (
    pyspark.SparkConf().setAppName('iceberg')
)

## Start Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()

df = spark.table("iceberg.nyc_yellowtaxi_tripdata").show()
