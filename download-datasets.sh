#! /bin/bash

# Cria o diretório data se não existir
mkdir -p /tmp/data/input/pedidos
mkdir -p /tmp/data/input/clientes

# Download the datasets
# pedidos
curl -L -o /tmp/data/input/pedidos/pedidos.gz https://raw.githubusercontent.com/infobarbosa/datasets-csv-pedidos/main/data/pedidos/pedidos-2024-01.csv.gz

# clientes
curl -L -o /tmp/data/input/clientes/clientes.gz https://raw.githubusercontent.com/infobarbosa/dataset-json-clientes/main/data/clientes.json.gz