module "primary_network" {
  source       = "../modules/network"
  name         = "${var.project}-primary"
  region       = var.primary_region
  vpc_cidr     = var.primary_vpc_cidr
  azs          = var.primary_azs
  subnet_cidrs = var.primary_subnet_cidrs
  providers    = { aws = aws }
}

module "standby_network" {
  source       = "../modules/network"
  name         = "${var.project}-standby"
  region       = var.standby_region
  vpc_cidr     = var.standby_vpc_cidr
  azs          = var.standby_azs
  subnet_cidrs = var.standby_subnet_cidrs
  providers    = { aws = aws.standby }
}

module "primary_security" {
  source    = "../modules/security"
  name      = "${var.project}-primary"
  vpc_id    = module.primary_network.vpc_id
  providers = { aws = aws }
}

module "standby_security" {
  source    = "../modules/security"
  name      = "${var.project}-standby"
  vpc_id    = module.standby_network.vpc_id
  providers = { aws = aws.standby }
}

resource "aws_iam_role" "ec2_ssm" {
  name               = var.ec2_ssm_role_name
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = var.ec2_ssm_role_name
  role = aws_iam_role.ec2_ssm.name
}
