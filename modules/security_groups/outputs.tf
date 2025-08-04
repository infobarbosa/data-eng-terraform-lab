output "emr_master_sg_id" {
  value = aws_security_group.dataeng_emr_master.id
}

output "emr_core_sg_id" {
  value = aws_security_group.dataeng_emr_core.id
}

output "emr_service_access_sg_id" {
  value = aws_security_group.dataeng_emr_service_access.id
}