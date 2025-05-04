#######################################################
# pet name
#######################################################
resource "random_pet" "this" {}

#######################################################
# vpc
#######################################################
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.21.0"
  name                 = random_pet.this.id
  cidr                 = var.cidr
  azs                  = slice(data.aws_availability_zones.this.names, 0, 0)
  private_subnets      = [cidrsubnet(var.cidr, 0, 0)]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
/*
#######################################################
# vpc endpoint
#######################################################
resource "aws_vpc_endpoint" "this" {
  vpc_id       = module.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
}
*/
#######################################################
# instance
#######################################################
resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_role.this.name
  subnet_id            = module.vpc.private_subnets[0]
  tags   = {
    Name = random_pet.this.id
  }
  user_data = <<EOF
#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
EOF
}

#######################################################
# iam
#######################################################
resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode({
    Version       = "2012-10-17"
    Statement     = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = "s3fullaccess"
      },
    ]
  })
}

resource "aws_iam_policy" "this" {
  policy          = jsonencode({
    Version       = "2012-10-17"
    Statement     = [
      {   
        Sid       = "ListObjects"
        Effect    = "Allow"
        Action    = [
          "s3:ListBucket"
        ]
        Resource  = [aws_s3_bucket.this.arn]
      },
      {   
        Sid       = "GetPutObjects"
        Effect    = "Allow"
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource  = ["${aws_s3_bucket.this.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

#######################################################
# s3
#######################################################
resource "aws_s3_bucket" "this" {
  bucket = data.aws_caller_identity.this.account_id
}