resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Public web traffic to the application load balancer"
  vpc_id      = var.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.name}-alb-sg" }
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "HTTP only from the regional ALB security group"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Application HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.name}-app-sg" }
}

resource "aws_security_group" "database" {
  name        = "${var.name}-database-sg"
  description = "MySQL only from application instances"
  vpc_id      = var.vpc_id
  ingress {
    description     = "MySQL from application"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.name}-database-sg" }
}

resource "aws_security_group" "quarantine" {
  name        = "${var.name}-quarantine-sg"
  description = "Isolated group for incident response; no ingress or egress rules"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.name}-quarantine-sg" }
}
