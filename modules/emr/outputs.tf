# 4. ./modules/emr/outputs.tf
output "dataeng_emr_cluster_id" {
  value = aws_emr_cluster.dataeng_emr.id
}
