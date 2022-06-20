terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}
resource "aws_vpc" "paytmvpc" {
    cidr_block = var.cidr_vpc
}
resource "aws_subnet" "paytmprivatesub" {
    vpc_id = aws_vpc.paytmvpc.id
    cidr_block = var.cidr_subnet
}
resource "aws_security_group" "paytmsg" {
    vpc_id = aws_vpc.paytmvpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["10.0.0.0/23"]
    }
}

resource "aws_key_pair" "paytmkpk" {
    key_name = "paytmkpk"
    public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSQH+8IXoslP4+b6d2k+rdtNm8RzYAXwSDE3SNLk7ZQfLmKF0ifxcEydQ3CfrQp49O+DuvCe2NpT+BDk3MsiuLbdZjULpGtAaaNdtzrLPxsCvP6e/8Pb9X0bA0oOQ12Xvd4UFJV3VJsCfdJg7VU1sw9hgqKiVA99t7hOwFfL2G8FL31J1UAkGsnhTy3aa4LGrcN5pNpIvCLsZ/V8sq2JV35aXntpdHb/AYc1C0wmrp3xF+35B0nTGbIjWLZ2NKuqaaCghkmHb4hYgXfGOZ7kIVxLQC6tgCeSGGdCYEX3vPuZAQkOOcjHLL8xX4ZDArEXnkzhYNPB/4aHKO9gPBBEnjKsIXSKCNLDqCgX5q+zeYeWBsmgoCmxYR3O3JmcinTe7FmBy1dA5pKaBfre21T6WZdoPlslCE/Os4S6NB5e9UGF5hlE7z35I7arbZaAUvaf7NfNec8UMvURoYMxJ+coUtwn3d8Beb3XdmoHVWz3iLSk4tiGl6iFWTHWxoOPFCHa8= SRS@DESKTOP-99M97DV"
}
resource "aws_instance" "payec2" {
    subnet_id = aws_subnet.paytmprivatesub.id
    vpc_security_group_ids = [aws_security_group.paytmsg.id]
    key_name = aws_key_pair.paytmkpk.key_name
    instance_type = "t2.micro"
    ami = "ami-0710ecdf2e1467a25"
    tags = {
      Name = "paytmec2"  
    }

}