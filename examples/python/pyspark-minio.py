from pyspark.sql import SparkSession
from pyspark import SparkConf

spark = SparkSession.builder.getOrCreate()
sc = spark.sparkContext

#sc._jsc.hadoopConfiguration().set("fs.s3a.access.key", "minio")
#sc._jsc.hadoopConfiguration().set("fs.s3a.secret.key", "minio123")
#sc._jsc.hadoopConfiguration().set("fs.s3a.endpoint", "http://minio.s3:9000")
#sc._jsc.hadoopConfiguration().set("fs.s3a.path.style.access", "true")
#sc._jsc.hadoopConfiguration().set("fs.s3a.connection.ssl.enabled", "false")
#sc._jsc.hadoopConfiguration().set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
#sc._jsc.hadoopConfiguration().set("spark.hadoop.fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider")

df = spark.read.csv("s3a://spark/p103.csv")
df.show()
