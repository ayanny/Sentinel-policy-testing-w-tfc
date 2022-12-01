



variable "region" {
    description "AWS Region for Resource Provisioning"
    type = string
    default = "ca-central-1"
}

variable "access_key" {
  description = "AWS AWS_ACCESS_KEY"
  type = string
}

variable "secret_key" {
  description = "AWS SECRET ACCESS KEY"
  type = string
}