#######################################################
# provider
#######################################################
variable "region" {
  type        = string
  description = "The region the provider will be configured for"
}

#######################################################
# instance
#######################################################
variable "instance_type" {
    type        = string
    description = "Instance type"
}