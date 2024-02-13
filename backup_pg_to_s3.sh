#!/bin/bash

# Nome do banco de dados
DB_NAME="xxxxxx"

# Diretório temporário para salvar o dump
DUMP_PATH="/opt/backups"
DUMP_FILE="${DUMP_PATH}/backup_$(date +\%Y\%m\%d\%H\%M\%S).sql.gz"

# Credenciais do banco de dados
PG_USER="postgres"
PG_PASSWORD="xxxx"
PG_HOST="localhost"
PG_PORT="5432"

# Bucket S3
S3_BUCKET="nome do bucket na aws"
S3_PATH="path do bucket na amazon | nome da pasta"

# Criar o dump
export PGPASSWORD=${PG_PASSWORD}
pg_dump -h ${PG_HOST} -U ${PG_USER} -p ${PG_PORT} -d ${DB_NAME} | gzip > ${DUMP_FILE}

# Verifica se pg_dump rodou com sucesso
if [ $? -eq 0 ]; then
  echo "PostgreSQL: Backup realizado com sucesso."
else
  echo "PostgreSQL: Falha ao realizar o backup."
  exit 1
fi

# Envia para o S3
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=
aws s3 cp --debug ${DUMP_FILE} s3://${S3_BUCKET}/${S3_PATH}/

# Remove o dump local
rm -f ${DUMP_FILE}
