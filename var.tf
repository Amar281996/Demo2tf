variable "aws_region" {
    type = string
    description = "where ec2 should be there"
    default = "us-west-2"
}
variable "aws_profile" {
    type = string
    description = "aws user credentials"
    default = "default"
}
variable "cidr_vpc" {
    type = string
    default = "10.0.0.0/16"
}
variable "cidr_subnet" {
    type = string
    description = "subnet cidr range"
    default = "10.0.1.0/24"
}