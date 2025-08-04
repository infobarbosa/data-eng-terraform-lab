# 4. ./modules/glue_catalog/outputs.tf
output "glue_database_name" {
  value = aws_glue_catalog_database.dataeng_glue_database.name
}
