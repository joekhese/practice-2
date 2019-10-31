###################################################
//-multiple SGs
//-ssh
//-egress
####################################################

####################################################
// default ssh
####################################################

resource "aws_security_group" "dev_default_ssh_sg_res" {
  name_prefix = "Bastion Host SG"
  description = "allow ssh inbound on vpc ${aws_vpc.dev_vpc_res.id} VPC "
  vpc_id      = "${aws_vpc.dev_vpc_res.id}" // referencing the vpc with ID
  lifecycle {
    create_before_destroy = "true"
  }
  tags = {
    Name = "Bastion Host SG for - ${aws_vpc.dev_vpc_res.id}"
  }
}

######################################
//ingress
resource "aws_security_group_rule" "dev_ssh_ingress_res" {
  type              = "ingress"
  to_port           = "22"
  from_port         = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] // accepts all ranges of IP
  security_group_id = "${aws_security_group.dev_default_ssh_sg_res.id}"
}

resource "aws_security_group_rule" "dev_ssh_egress_res" {
  type              = "egress"
  to_port           = "0"           //allows all port numbers out
  from_port         = "0"           // allowsall port numbers out
  protocol          = "-1"          // allows all protocols out
  cidr_blocks       = ["0.0.0.0/0"] // allows everything out
  security_group_id = "${aws_security_group.dev_default_ssh_sg_res.id}"

}

##################################################################
# Security group for private ASG
##################################################################

resource "aws_security_group" "dev_priv_sg_res" {
  name_prefix = "Private ASG SG"
  description = "allow all traffic to the private ASG in ${aws_vpc.dev_vpc_res.id} VPC "
  vpc_id      = "${aws_vpc.dev_vpc_res.id}" // referencing the vpc with ID
  lifecycle {
    create_before_destroy = "true"
  }
  tags = {
    Name = "Private ASG SG for - ${aws_vpc.dev_vpc_res.id}"
  }
}

######################################
//ingress
resource "aws_security_group_rule" "dev_priv_ingress_res" {
  type              = "ingress"
  to_port           = "0"
  from_port         = "0"
  protocol          = "-1"
  cidr_blocks     = ["${var.asg_ip_addr}"] // accepts ip of bastion host
  security_group_id = "${aws_security_group.dev_priv_sg_res.id}"
}

resource "aws_security_group_rule" "dev_priv_egress_res" {
  type              = "egress"
  to_port           = "0"           //allows all port numbers out
  from_port         = "0"           // allowsall port numbers out
  protocol          = "-1"          // allows all protocols out
  cidr_blocks       = ["0.0.0.0/0"] // allows everything out
  security_group_id = "${aws_security_group.dev_priv_sg_res.id}"

}