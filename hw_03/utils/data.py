import pyspark
from pyspark.sql.functions import col, hour, dayofweek, month, when


def load_dataset(
    session: pyspark.sql.session.SparkSession,
    schema: pyspark.sql.types.StructType,
    filename: str
) -> pyspark.sql.dataframe.DataFrame:
    df = session\
        .read\
        .option("header", "true")\
        .schema(schema)\
        .csv(filename)

    return df


def save_dataset_to_parquet(
    dataframe: pyspark.sql.dataframe.DataFrame,
    filename: str,
    partitions: int
) -> None:
    dataframe.repartition(partitions)\
        .write\
        .mode("overwrite")\
        .parquet(filename)


def prepare_dataset(
    dataframe: pyspark.sql.dataframe.DataFrame
) -> pyspark.sql.dataframe.DataFrame:
    """
    - удаляет строки с пустыми записями, NaN, NULL
    - удаляет дубликаты
    - удаляет строки с отрицательными значениями customer_id
    - удаляет tx_datetime, вытащив из него полезную информацию
    - удаляет tx_fraud_scenario
    """
    df = dataframe.dropna()
    print("Удалены строки с NaN")


    df = df.dropDuplicates(["transaction_id"])
    print("Удалены дубликаты")


    df = df.filter(col("customer_id") >= 0)
    print("Удалены строки с customer_id < 0")


    df = df \
        .withColumn("tx_hour", hour(col("tx_datetime"))) \
        .withColumn("tx_day_of_week", dayofweek(col("tx_datetime"))) \
        .withColumn("tx_month", month(col("tx_datetime"))) \
        .withColumn("is_weekend", when(col("tx_day_of_week").isin(1, 7), 1).otherwise(0)
    )
    print("Созданы новые фичи из колонки 'tx_datetime'")

    cols_to_drop = [
        "tx_datetime",
        "transaction_id",
        "tx_time_days",
        "tx_fraud_scenario"
    ]

    df = df.drop(*cols_to_drop)
    print(f"Удалены колонки: {cols_to_drop}")

    return df
