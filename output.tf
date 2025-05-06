#######################################################
# pet name
#######################################################
output "random_pet" {
  value       = random_pet.this
  description = "This is the vpc name."
}

#######################################################
# vpc
#######################################################
output "vpc" {
  value       = module.vpc
  description = "All vpc module outputs."
}

#######################################################
# vpc endpoint
#######################################################
output "aws_vpc_endpoint" {
  value       = aws_vpc_endpoint.this
  description = "The s3 vpc endpoint outputs."
}

#######################################################
# instance
#######################################################
output "aws_instance" {
  value       = aws_instance.this
  description = "The ec2 outputs."
}

output "aws_ami" {
  value       = data.aws_ami.this
  description = "AMI data source filter outputs."
}

#######################################################
# iam
#######################################################
output "aws_iam_role" {
  value       = aws_iam_role.this
  description = "The iam role outputs."
}

output "aws_iam_policy" {
  value       = aws_iam_policy.this
  description = "The iam policy outputs."
}

output "aws_iam_role_policy_attachment" {
  value       = aws_iam_role_policy_attachment.this
  description = "The iam policy attachment outputs."
}

#######################################################
# s3
#######################################################
output "aws_s3_bucket" {
  value       = aws_s3_bucket.this
  description = "The s3 bucket outputs."
}