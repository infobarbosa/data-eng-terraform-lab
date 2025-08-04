# 2. ./modules/emr/main.tf
resource "aws_emr_cluster" "dataeng_emr" {
  name          = "dataeng-emr"
  release_label = "emr-7.2.0"
  applications  = ["Hadoop", "Spark"]
  service_role  = "EMR_DefaultRole"
  log_uri = "s3://${var.dataeng_bucket_name}/emr/logs/"
  ec2_attributes {
    instance_profile = "EMR_EC2_DefaultRole"
    subnet_id        = var.dataeng_private_subnet_id
    emr_managed_master_security_group = var.dataeng_emr_master_sg_id
    emr_managed_slave_security_group  = var.dataeng_emr_core_sg_id
    service_access_security_group = var.dataeng_emr_service_access_sg_id
  }
  master_instance_group {
    instance_type = "m4.large"
  }
  core_instance_group {
    instance_type = "m4.large"
    instance_count = 1
  }
  bootstrap_action {
    path = "s3://${var.dataeng_bucket_name}/scripts/bootstrap-actions.sh"
    name = "Install boto3 e awsglue"
  }  
  step {
    name = "Setup Hadoop Debugging"
    action_on_failure = "TERMINATE_CLUSTER"
    hadoop_jar_step {
      jar = "command-runner.jar"
      args = ["state-pusher-script"]
    }
  }
  step {
    name = "Clientes Spark Job"
    action_on_failure = "CONTINUE"
    hadoop_jar_step {
      jar = "command-runner.jar"
      args = [
        "spark-submit", 
        "s3://${var.dataeng_bucket_name}/scripts/clientes_spark_job.py",
        "${var.dataeng_bucket_name}"
      ]
    }
  }
  tags = {
    Name = "dataeng-emr"
  }
}

# 7. ./modules/emr/main.tf
resource "aws_s3_object" "clientes_spark_job" {
    bucket = var.dataeng_bucket_name
    key    = "scripts/clientes_spark_job.py"
    source = "./modules/emr/scripts/clientes_spark_job.py"
}

# 8. ./modules/emr/main.tf
resource "aws_s3_object" "bootstrap_actions_sh" {
    bucket = var.dataeng_bucket_name
    key    = "scripts/bootstrap-actions.sh"
    source = "./modules/emr/scripts/bootstrap-actions.sh"
}  
