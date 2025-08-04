# 2.1. dataeng_glue_database
resource "aws_glue_catalog_database" "dataeng_glue_database" {
  name = var.dataeng_database_name
}

# 2.2. dataeng_glue_table_clientes
resource "aws_glue_catalog_table" "dataeng_glue_table_clientes" {
  database_name = aws_glue_catalog_database.dataeng_glue_database.name
  name          = "tb_raw_clientes"
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "json",
    "compressionType" = "gzip"
  }
  storage_descriptor {
    location = "s3://${var.dataeng_bucket_name}/raw/clientes/"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = true
    number_of_buckets = -1
    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "json.schemas.ignore.malformed" = "true",
        "paths" = "id,nome,data_nasc,cpf,email,interesses"
      }
    }
    columns {
        name = "id"
        type = "bigint"
    }
    columns {
        name = "nome"
        type = "string"
    }
    columns {
        name = "data_nasc"
        type = "date"
    }
    columns {
        name = "cpf"
        type = "string"
    }
    columns {
        name = "email"
        type = "string"
    }  
    columns {
        name = "interesses"
        type = "array<string>"
    }  
  }
}


resource "aws_glue_catalog_table" "dataeng_glue_table_pedidos" {
  database_name = aws_glue_catalog_database.dataeng_glue_database.name
  name          = "tb_raw_pedidos"
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "csv",
    "compressionType" = "gzip",
    "skip.header.line.count" = "1"
  }
  storage_descriptor {
    location = "s3://dataeng-6abdr-841727080701/raw/pedidos/"
    input_format = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed = true
    number_of_buckets = -1
    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "field.delim" = ";"
      }
    }
    columns {
        name = "ID_PEDIDO"
        type = "string"
    }

    columns {
        name = "PRODUTO"
        type = "string"
    }

    columns {
        name = "VALOR_UNITARIO"
        type = "float"
    }

    columns {
        name = "QUANTIDADE"
        type = "bigint"
    }

    columns {
        name = "DATA_CRIACAO"
        type = "timestamp"
    }      

    columns {
        name = "UF"
        type = "string"
    }

    columns {
        name = "ID_CLIENTE"
        type = "bigint"
    }  
  } 
}

# 6. ./modules/glue_catalog/main.tf
resource "aws_glue_catalog_table" "dataeng_glue_table_stage_clientes" {
    database_name = aws_glue_catalog_database.dataeng_glue_database.name
    name          = "tb_stage_clientes"
    table_type    = "EXTERNAL_TABLE"
    parameters = {
        classification = "parquet",
        "compressionType" = "snappy",
        "skip.header.line.count" = "0"
    }
    storage_descriptor {
        location = "s3://${var.dataeng_bucket_name}/stage/clientes/"

        input_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
        compressed = true
        number_of_buckets = -1
        ser_de_info {
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
            parameters = {
                "serialization.format" = "1"
            }
        }
        columns {
            name = "id"
            type = "int"
        }
        columns {
            name = "nome"
            type = "string"
        }
        columns {
            name = "data_nasc"
            type = "date"
        }
        columns {
            name = "cpf"
            type = "string"
        }
        columns {
            name = "email"
            type = "string"
        }  
        columns {
            name = "interesses"
            type = "array<string>"
        }
    }
}  
