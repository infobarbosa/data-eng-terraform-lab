provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

data "aws_caller_identity" "current" {}

locals {
    dataeng_account_id = data.aws_caller_identity.current.account_id
    dataeng_turma = "6abdr"
}


module "s3" {
  source  = "./modules/s3"
  dataeng_account_id = local.dataeng_account_id
  dataeng_turma = local.dataeng_turma
}

# 9. Module VPC em `./main.tf`
module "vpc" {
  source  = "./modules/vpc"
}

module "security_groups" {
  source        = "./modules/security_groups"
  vpc_id        = module.vpc.vpc_id
}

# 5. module glue_catalog
module "glue-catalog" {
  source  = "./modules/glue_catalog"

  dataeng_database_name = "dataengdb"
  dataeng_bucket_name   = module.s3.dataeng_bucket
}

# 10. EMR
module "emr" {
  source  = "./modules/emr"

  dataeng_private_subnet_id = module.vpc.private_subnet_id
  dataeng_emr_master_sg_id = module.security_groups.emr_master_sg_id
  dataeng_emr_core_sg_id = module.security_groups.emr_core_sg_id
  dataeng_emr_service_access_sg_id = module.security_groups.emr_service_access_sg_id
  dataeng_bucket_name = module.s3.dataeng_bucket

  depends_on = [module.vpc]
}
