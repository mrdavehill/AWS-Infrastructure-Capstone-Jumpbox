#######################################################
# provider
#######################################################
variable "region" {
  type        = string
  description = "The region the provider will be configured for."
}

#######################################################
# vpc
#######################################################
variable "cidr" {
    type        = string
    description = "RFC1918 CIDR block for the VPC." 
}

#######################################################
# instance
#######################################################
variable "instance_type" {
    type        = string
    description = "Instance type."
}

variable "associate_public_ip_address" {
    type        = bool
    description = "Allocate a public IP - used for ec2 instance connect."
}