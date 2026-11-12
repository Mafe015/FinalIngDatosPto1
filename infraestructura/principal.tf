terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "datos" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "datos" {
  bucket                  = aws_s3_bucket.datos.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "p_entregas" {
  bucket = aws_s3_bucket.datos.id
  key    = "entregas/"
}

resource "aws_s3_object" "p_resultados" {
  bucket = aws_s3_bucket.datos.id
  key    = "resultados-athena/"
}

resource "aws_glue_catalog_database" "db" {
  name = "entregas_db"
}

resource "aws_glue_catalog_table" "entregas" {
  name          = "entregas"
  database_name = aws_glue_catalog_database.db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"                       = "TRUE"
    "skip.header.line.count"         = "1"
    "projection.enabled"             = "true"
    "projection.fecha.type"          = "date"
    "projection.fecha.format"        = "yyyy-MM-dd"
    "projection.fecha.range"         = "2026-10-01,2026-10-03"
    "projection.fecha.interval"      = "1"
    "projection.fecha.interval.unit" = "DAYS"
    "storage.location.template"      = "s3://${aws_s3_bucket.datos.bucket}/entregas/fecha=$${fecha}/"
  }

  partition_keys {
    name = "fecha"
    type = "string"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.datos.bucket}/entregas/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "field.delim" = ","
      }
    }

    columns {
      name = "id_envio"
      type = "string"
    }
    columns {
      name = "ciudad"
      type = "string"
    }
    columns {
      name = "transportadora"
      type = "string"
    }
    columns {
      name = "estado"
      type = "string"
    }
    columns {
      name = "duracion_minutos"
      type = "int"
    }
  }
}

resource "aws_athena_workgroup" "wg" {
  name          = "entregas_wg"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.datos.bucket}/resultados-athena/"
    }
  }
}