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
  azs                  = slice(data.aws_availability_zones.this.names, 0, 1)
  public_subnets       = [cidrsubnet(var.cidr, 1, 0)]
  enable_dns_hostnames = true
}

#######################################################
# vpc endpoint
#######################################################
resource "aws_vpc_endpoint" "this" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
}

#######################################################
# instance
#######################################################
resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = module.vpc.public_subnets[0]
  security_groups             = [aws_security_group.this.id]
  tags   = {
    Name = random_pet.this.id
  }
  user_data = <<EOF
#!/bin/bash
sudo yum install -y yum-utils
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
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
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo mv ./aws-iam-authenticator /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
sudo service docker start
sudo yum update -y
sudo yum -y install docker
sudo systemctl enable docker
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "test_profile"
  role = aws_iam_role.this.name
}

#######################################################
# security groups
#######################################################
resource "aws_security_group" "this" {
  name              = random_pet.this.id
  description       = "Allow all"
  vpc_id            = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.this.id
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  security_group_id = aws_security_group.this.id
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
      },
      {
        "Sid": "AmazonFullAccess",
        "Effect": "Allow",
        "Action": [
            "*"
        ],
        "Resource": "*"
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
  bucket = "${data.aws_caller_identity.this.account_id}-${var.region}"
}
