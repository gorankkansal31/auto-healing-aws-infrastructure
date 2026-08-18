variable "project_name" {
    type= string
}



variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "ec2_sg_id" {
    type =string
}

variable "key_name" {
    type = string
    }