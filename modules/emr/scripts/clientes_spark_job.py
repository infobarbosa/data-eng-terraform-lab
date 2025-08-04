import os
import sys
import logging
from datetime import datetime
from pyspark.sql import SparkSession

def main():

    # Inicialização da SparkSession
    spark = SparkSession \
        .builder \
        .appName("clientes_spark_job") \
        .config("hive.metastore.client.factory.class", "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory") \
        .enableHiveSupport() \
        .getOrCreate()

    log4jLogger = spark._jvm.org.apache.log4j
    logger = log4jLogger.LogManager.getLogger("clientes_spark_job")
    logger.info("Iniciando processamento [clientes_spark_job]")

    spark.catalog.setCurrentDatabase("dataengdb")

    # Determinando bucket S3
    logger.info("Definindo o bucket S3.")
    BUCKET_NAME = ""
    try:

        if len(sys.argv) < 2:
            logger.info("Uso: spark-submit clientes_spark_job.py <BUCKET_NAME>")
            sys.exit(1)

        BUCKET_NAME = sys.argv[1]
        logger.info(f"Bucket S3: {BUCKET_NAME}")

    except Exception as e:
        logger.exception("Erro ao listar buckets S3")
        sys.exit(1)

    # Carregando dados de clientes
    logger.info("Lendo dados da tabela 'tb_raw_clientes'")
    try:
        df_clientes = spark.sql("SELECT * FROM dataengdb.tb_raw_clientes")
        logger.info(f"Total de registros lidos: {df_clientes.count()}")
    except Exception as e:
        logger.exception("Erro ao ler dados da tabela 'tb_raw_clientes'")
        sys.exit(1)

    # Gravando os dados no S3 em formato Parquet
    output_path = f"s3://{BUCKET_NAME}/stage/clientes"
    logger.info(f"Gravando dados no path: {output_path}")
    try:
        df_clientes.write.format("parquet").mode("overwrite").save(output_path)
        logger.info("Dados gravados com sucesso.")
    except Exception as e:
        logger.exception("Erro ao gravar dados no S3")
        sys.exit(1)

    logger.info("Finalizando o script de processamento dos dados: clientes_spark_job")

if __name__ == "__main__":
    main()
