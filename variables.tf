#######################################################
# provider
#######################################################
variable "region" {
  type        = string
  description = "The region the provider will be configured for"
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