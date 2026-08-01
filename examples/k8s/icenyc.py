import pyspark
from pyspark.sql import SparkSession
conf = (pyspark.SparkConf().setAppName('iceberg nyc'))
## Start Spark Session
spark = SparkSession.builder.config(conf=conf).getOrCreate()
df = spark.table("iceberg.nyc_yellowtaxi_tripdata")
df.createOrReplaceTempView("nyc")

resultsDF = spark.sql("SELECT vendorid, payment_type FROM nyc")
resultsDF.show(2)
spark.sql("SELECT count(*) FROM nyc").show()
