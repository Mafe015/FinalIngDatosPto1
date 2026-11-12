output "bucket" {
  value = aws_s3_bucket.datos.bucket
}
output "database" {
  value = aws_glue_catalog_database.db.name
}
output "tabla" {
  value = aws_glue_catalog_table.entregas.name
}
output "workgroup" {
  value = aws_athena_workgroup.wg.name
}