import pyspark
from pyspark.sql import SparkSession
conf = (pyspark.SparkConf().setAppName('iceberg nyc'))
## Start Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()

spark.sql("ALTER TABLE iceberg.nyc_yellowtaxi_tripdata ADD COLUMN fare_per_distance FLOAT AFTER trip_distance")
spark.sql("UPDATE iceberg.nyc_yellowtaxi_tripdata SET fare_per_distance = fare/trip_distance")
spark.sql("DELETE FROM iceberg.nyc_yellowtaxi_tripdata WHERE fare_per_distance > 4.0 OR trip_distance > 2.0")

df = spark.table("iceberg.nyc_yellowtaxi_tripdata")
df.createOrReplaceTempView("nyc")
resultsDF = spark.sql("SELECT fare_per_distance FROM nyc where fare_per_distance > 3.5")
resultsDF.show(2)
