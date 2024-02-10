module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Jenkins_vpc"
  cidr = var.vpc_cidr

  azs             = var.azs

  public_subnets  = var.public_subnets
  map_public_ip_on_launch = true

  enable_dns_hostnames = true

  tags = {
    Name = "jenkins_vpc"
    Terraform = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "jenkins_subnet"
  }


}

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins_sg"
  description = "Security group for jenkinsserver"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "jenkinsport"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
      
    }
    
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      
    },
   
    
  ]
  tags = {
      name = "jenkins_sg"
    }

}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type          = var.instance_type
  key_name               = "keypair"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = file("jenkins-install.sh")
  availability_zone = var.azs[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
