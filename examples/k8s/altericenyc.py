import pyspark
from pyspark.sql import SparkSession
conf = (pyspark.SparkConf().setAppName('iceberg nyc'))
## Start Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()

df = spark.table("iceberg.nyc_yellowtaxi_tripdata")
df.createOrReplaceTempView("nyc")
resultsDF = spark.sql("SELECT fare_amount,trip_distance FROM nyc")
resultsDF.show(2)

# Rename column "fare_amount" in nyc.taxis_large to "fare"
spark.sql("ALTER TABLE iceberg.nyc_yellowtaxi_tripdata RENAME COLUMN fare_amount TO fare")

# Move "distance" next to "fare" column
spark.sql("ALTER TABLE iceberg.nyc_yellowtaxi_tripdata ALTER COLUMN trip_distance AFTER fare")

df = spark.table("iceberg.nyc_yellowtaxi_tripdata")
df.createOrReplaceTempView("nyc")
resultsDF = spark.sql("SELECT fare, trip_distance FROM nyc")
resultsDF.show(2)
