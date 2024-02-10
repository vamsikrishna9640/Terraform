variable "vpc_cidr" {
    description = "value for cidr"
    type = string
  
}
variable "azs" {
    description = "values for azs"
    type = list(string)
  
}
variable "public_subnets" {
    description = "values for sub"
    type = list(string)
  
}
variable "instance_type" {
    description = "instance type for jenkins-server"
    type = string
  
}
