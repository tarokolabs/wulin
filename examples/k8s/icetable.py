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

table_ddl = """create table iceberg.nyc_yellowtaxi_tripdata
          (vendorid                             bigint,
          tpep_pickup_datetime                  timestamp,
          tpep_dropoff_datetime                 timestamp,
          passenger_count                       double,
          trip_distance                         double,
          ratecodeid                            double,
          store_and_fwd_flag                    string,
          pulocationid                          bigint,
          dolocationid                          bigint,
          payment_type                          bigint,
          fare_amount                           double,
          extra                                 double,
          mta_tax                               double,
          tip_amount                            double,
          tolls_amount                          double,
          improvement_surcharge                 double,
          total_amount                          double,
          congestion_surcharge                  double,
          airport_fee                           double
          )
          USING iceberg
          PARTITIONED BY (months(tpep_pickup_datetime))"""

spark.sql(table_ddl)

