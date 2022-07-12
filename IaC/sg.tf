###################
# SG for alb
###################
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name        = "${var.project_name}-alb-sg"
  description = "alb sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

   egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

   tags = local.tags
}

###################
# SG for asg
###################
module "asg_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name        = "${var.project_name}-asg-sg"
  description = "asg sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

   egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "${var.project_name}-app-port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

   tags = local.tags
}
