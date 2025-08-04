resource "aws_security_group" "dataeng_emr_master" {
  name        = "dataeng-emr-master-sg"
  description = "permite acesso ao master vindo de conexao ssh e tambem dos core nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dataeng-emr-master-sg"
  }
}

resource "aws_security_group_rule" "emr_master_rule1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dataeng_emr_master.id
  source_security_group_id = aws_security_group.dataeng_emr_core.id
}

resource "aws_security_group_rule" "emr_master_rule2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dataeng_emr_master.id
  cidr_blocks = ["0.0.0.0/0"]
}


# --- Ponto de Segurança: Security Group para os Nós Core & Task ---
# Permite comunicação interna do cluster, mas nenhum acesso de entrada da internet.
resource "aws_security_group" "dataeng_emr_core" {
  name        = "dataeng-emr-core-sg"
  description = "Allow all traffic from master and other core nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dataeng-emr-core-sg"
  }
}

resource "aws_security_group_rule" "emr_core_rule1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dataeng_emr_core.id
  source_security_group_id = aws_security_group.dataeng_emr_master.id
}

resource "aws_security_group_rule" "emr_core_rule2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dataeng_emr_core.id
  self              = true
}

resource "aws_security_group_rule" "emr_core_rule3" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.dataeng_emr_core.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "dataeng_emr_service_access" {
  name        = "dataeng-emr-service-access-sg"
  description = "Allow EMR service to communicate with the cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "dataeng-emr-service-access-sg"
  }
}

resource "aws_security_group_rule" "emr_service_access_rule" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dataeng_emr_service_access.id
  source_security_group_id = aws_security_group.dataeng_emr_master.id
}
