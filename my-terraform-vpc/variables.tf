variable "cidr_block" {
  default     = ""
  description = "VPC Ip Range"
}

variable "vpc_name" {
  default     = ""
  description = "specify VPC name"

}

variable "availability_zone" {
  //default = ""
  description = "specify availability zone"
  type        = "list"

}

variable "asg_ip_addr" {
  description = "records the ip of the asg"
}



