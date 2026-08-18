variable "project_name"  {
    type= string
}
variable "launch_template_id"  {
    type = string
}

variable "target_group_arn" {
    type = string
}


variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}