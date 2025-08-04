# 3. ./modules/glue_catalog/variables.tf
variable "dataeng_database_name" {
  description = "O nome do database no Glue Catalog"
  type        = string
}

variable "dataeng_bucket_name" {
  description = "O nome do bucket no AWS S3"
  type        = string
}
