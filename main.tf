# Insecure IaC - Terraform para AWS
# NÃO usar em produção. Apenas para testes de scanners de IaC.

provider "aws" {
  region = "us-east-1"
}

# 1. Security Group com portas abertas para o mundo (0.0.0.0/0)
resource "aws_security_group" "insecure_sg" {
  name        = "insecure-sg"
  description = "Security group inseguro com portas abertas"

  ingress {
    description = "Porta HTTP aberta para o mundo"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Má prática: acesso irrestrito
  }

  ingress {
    description = "Porta do banco de dados aberta para o mundo"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Má prática: banco exposto publicamente
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Má prática: saída irrestrita
  }
}

# 2. Instância EC2 com chave SSH hardcoded
resource "aws_instance" "insecure_app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
  instance_type = "t2.micro"
  key_name      = "hardcoded-ssh-key"     # Má prática: chave SSH exposta

  vpc_security_group_ids = [aws_security_group.insecure_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              curl -sL https://rpm.nodesource.com/setup_20.x | bash -
              yum install -y nodejs git
              # Clonar aplicação insegura (simulação)
              git clone https://github.com/example/insecure-app.git /opt/insecure-app
              cd /opt/insecure-app
              npm install
              npm start
              EOF

  tags = {
    Name = "InsecureAppInstance"
  }
}

# 3. RDS exposto publicamente
resource "aws_db_instance" "insecure_db" {
  identifier           = "insecure-db"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"                # Versão desatualizada
  instance_class       = "db.t2.micro"
  username             = "admin"              # Usuário hardcoded
  password             = "Admin123!"          # Senha hardcoded
  publicly_accessible  = true                 # Banco acessível publicamente
  skip_final_snapshot  = true                 # Sem snapshot final (risco de perda de dados)

  vpc_security_group_ids = [aws_security_group.insecure_sg.id]
}

