resource "aws_s3_bucket" "dataeng_bucket" {
    bucket = "dataeng-${var.dataeng_turma}-${var.dataeng_account_id}"
    force_destroy = true

    tags = {
        Name        = "dataeng_bucket"
        Environment = "Dev"
    }
}

resource "aws_s3_object" "dataset_clientes" {
    bucket = aws_s3_bucket.dataeng_bucket.id
    key    = "raw/clientes/clientes.json.gz"
    source = "/tmp/data/input/clientes/clientes.json.gz"
}

resource "aws_s3_object" "dataset_pedidos" {
    bucket = aws_s3_bucket.dataeng_bucket.id
    key    = "raw/pedidos/pedidos-2024-01.csv.gz"
    source = "/tmp/data/input/pedidos/pedidos-2024-01.csv.gz"
}


