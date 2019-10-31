
//public and private subnets definations
//- Public
//- private 
//- Nat Gateway
//- Elastic ip (EIP)

//the Length function, counts trough the  availability zone lists
//length func takes in the total number of the 
//availiability zone lists
resource "aws_subnet" "dev_sbn_pub_res" {
  count                   = "${length(var.availability_zone)}"
  vpc_id                  = "${aws_vpc.dev_vpc_res.id}"                      #takes in the ID of the VPC defined in vpc.tf
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"  //created cider blocks for count number of availability zones
  availability_zone       = "${element(var.availability_zone, count.index)}" //element func takes a list  and index
  map_public_ip_on_launch = "true" // gives the subnet a public ip
  //associate_public_ip_address 
  tags = {


    Name = "Dev_Public Subnet ${element(var.availability_zone, count.index)}" //names the public subment appending a count begining from 0 to the
    //number in the availability_zone variable list                                                                            
  }
}

////////////////////////////////////////////////////
// Private Subnet

resource "aws_subnet" "dev_sbn_priv_res" {
  count                   = "${length(var.availability_zone)}"
  vpc_id                  = "${aws_vpc.dev_vpc_res.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zone))}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = "false" // doesn't give the subnet a public ip

  tags = {
    Name = "Dev_Private_Subnet ${element(var.availability_zone, count.index)}"
  }
}
######################################################
#Elastic IP for each public subnet in the different availability zones,
resource "aws_eip" "dev_eip_res" {
  count = "${length(var.availability_zone)}"
  vpc   = true

  tags = {
    Name = "Dev_EIP -${element(var.availability_zone, count.index)}"
  }
}
###########################################################
# Nat Gateway
#this connets to the public subnet to give the private subnet
#access to the internet
resource "aws_nat_gateway" "dev_natg_res" {
  count         = "${length(var.availability_zone)}"
  subnet_id     = "${element(aws_subnet.dev_sbn_pub_res.*.id, count.index)}" //fetches all the IDs within the specified subnet group
  allocation_id = "${element(aws_eip.dev_eip_res.*.id, count.index)}"        //fetches all the IDs within the specified EIP group

  tags = {
    Name = "Dev Nat - ${element(var.availability_zone, count.index)}"
  }
}


