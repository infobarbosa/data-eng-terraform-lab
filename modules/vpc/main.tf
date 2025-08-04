# 2. VPC
resource "aws_vpc" "dataeng_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true  
  tags = {
    Name = "dataeng-vpc"
  }
}

# 3. Subnets 
# 3.1 Subnet pública
resource "aws_subnet" "dataeng_public_subnet" {
  vpc_id            = aws_vpc.dataeng_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dataeng-public-subnet"
  }
}

# 3.2 Subnet privada
resource "aws_subnet" "dataeng_private_subnet" {
  vpc_id            = aws_vpc.dataeng_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dataeng-private-subnet"
  }
}

# 4. Internet Gateway
resource "aws_internet_gateway" "dataeng_igw" {
  vpc_id = aws_vpc.dataeng_vpc.id
  tags = {
    Name = "dataeng-igw"
  }
}

###############################
## ElasticIP
###############################
resource "aws_eip" "dataeng_eip_nat" {
  domain = "vpc"
  tags = {
    Name = "dataeng-nat-eip"
  }
}

###############################
## NAT Gateway
###############################
resource "aws_nat_gateway" "dataeng_nat_gw" {
  allocation_id = aws_eip.dataeng_eip_nat.id
  subnet_id     = aws_subnet.dataeng_public_subnet.id
  depends_on    = [aws_internet_gateway.dataeng_igw]
  tags = {
    Name = "dataeng-nat-gw"
  }
}


# 5. Tabelas de rotas
# 5.1 - Tabela de rotas para a subnet pública (route table)
resource "aws_route_table" "dataeng_public_rt" {
  vpc_id = aws_vpc.dataeng_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dataeng_igw.id
  }
  tags = {
    Name = "dataeng-public-rt"
  }
}

# 5.2 - Tabela de rotas para a subnet privada (route table)
resource "aws_route_table" "dataeng_private_rt" {
  vpc_id = aws_vpc.dataeng_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dataeng_nat_gw.id
  }
  tags = {
    Name = "dataeng-private-rt"
  }
}


# 6. aws_route_table_association
resource "aws_route_table_association" "dataeng_public_association" {
  subnet_id      = aws_subnet.dataeng_public_subnet.id
  route_table_id = aws_route_table.dataeng_public_rt.id
}

resource "aws_route_table_association" "dataeng_private_association" {
  subnet_id      = aws_subnet.dataeng_private_subnet.id
  route_table_id = aws_route_table.dataeng_private_rt.id
}


##################################################################################################
## NAT Gateway
# Mantém o tráfego entre o EMR e o S3 dentro da rede da AWS, não passando pela internet pública.
##################################################################################################
resource "aws_vpc_endpoint" "dataeng_vpce_s3" {
  vpc_id       = aws_vpc.dataeng_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_route_table.dataeng_private_rt.id]
  tags = {
    Name = "dataeng-vpce-s3"
  }
}


