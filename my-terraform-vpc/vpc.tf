#vpc setup for our server
resource "aws_vpc" "dev_vpc_res" {
  cidr_block = "${var.cidr_block}" // calling on variable cdir_block defined in variables.tf 
  // & terraform.tvars

  tags = {
    Name = "${var.vpc_name}" // calling on variable vpc_name defined in variables.tf 
    // & terraform.tvars
  }
}
################################################
#internet gateway for communication with the internet
resource "aws_internet_gateway" "dev_igw_res" {
  vpc_id = "${aws_vpc.dev_vpc_res.id}"

  tags = {
    Name = "dev_igw_arch"
  }
}
