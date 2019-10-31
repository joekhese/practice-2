#######################################
//route traffic from subnets
//- route table
//- route
//- Route associations
##########################################################
//Public Route Table
##########################################################
resource "aws_route_table" "dev_rt_tbl_public_res" {
  count  = "${length(var.availability_zone)}" //creating multiple tables= number of AZs
  vpc_id = "${aws_vpc.dev_vpc_res.id}"        // attaching to this vpc
  tags = {
    Name = "Dev Public Route Table - ${element(var.availability_zone, count.index)}"
  }
}
############################################################
#Route for public route table
############################################################
resource "aws_route" "dev_rt_cidr_res" {
  count                  = "${length(var.availability_zone)}"
  route_table_id         = "${element(aws_route_table.dev_rt_tbl_public_res.*.id, count.index)}" //referencing the above route table
  gateway_id             = "${element(aws_internet_gateway.dev_igw_res.*.id, count.index)}"      // referencing the IGW in vpc.tf
  destination_cidr_block = "0.0.0.0/0"                                                           //all outbound traffic allowed
}
################################################################
//Public Route Table Association
################################################################
resource "aws_route_table_association" "dev_rt_assoc_public_res" {
  count          = "${length(var.availability_zone)}"
  subnet_id      = "${element(aws_subnet.dev_sbn_pub_res.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.dev_rt_tbl_public_res.*.id, count.index)}"
}

################################################################
//Private Route Table 
################################################################
resource "aws_route_table" "dev_rt_tbl_private_res" {
  count  = "${length(var.availability_zone)}"
  vpc_id = "${aws_vpc.dev_vpc_res.id}"
  tags = {
    Name = "Dev Private Route Table - ${element(var.availability_zone, count.index)}"
  }
}
############################################################
#Route for Private route table
############################################################

resource "aws_route" "dev_rt_ngw_res" { //private route table connects to the NatGW
  count                  = "${length(var.availability_zone)}"
  route_table_id         = "${element(aws_route_table.dev_rt_tbl_private_res.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0" //allows all outbound traffic
  nat_gateway_id         = "${element(aws_nat_gateway.dev_natg_res.*.id, count.index)}"
}
################################################################
//Private Route Table Association
################################################################
resource "aws_route_table_association" "dev_rt_assoc_private_res" {
  count          = "${length(var.availability_zone)}"
  subnet_id      = "${element(aws_subnet.dev_sbn_priv_res.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.dev_rt_tbl_private_res.*.id, count.index)}"


}
