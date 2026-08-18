variable "project_name" {
    type= string
}

variable "private_subnet_1_id"{
    type = string
}

variable "private_subnet_2_id" {
    type = string
}


variable "rds_sg_id"  {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
    sensitive =true
}

variable "db_name" {
    type = string
    default = "appdb"
}

variable "instance_class" {
    type = string
    default = "db.t3.micro"
}



