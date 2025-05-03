#######################################################
# pet name
#######################################################
output "random_pet" {
  value = random_pet.this
}

#######################################################
# vpc
#######################################################
output "vpc" {
  value = module.vpc.this
}

#######################################################
# vpc endpoint
#######################################################
output "aws_vpc_endpoint" {
  value = aws_vpc_endpoint.this
}

#######################################################
# instance
#######################################################
output "aws_instance" {
  value = aws_instance.this
}

#######################################################
# iam
#######################################################
output "aws_iam_role" {
  value = aws_iam_role.this
}

output "aws_iam_policy" {
  value = aws_iam_policy.this
}

output "aws_iam_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.this
}

#######################################################
# s3
#######################################################
output "aws_s3_bucket" {
  value = aws_s3_bucket.this
}