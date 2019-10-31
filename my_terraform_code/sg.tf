resource "aws_security_group" "tf_test_sg" {
  name_prefix = "test Security group"
  description = "allow inbound traffic"
  vpc_id      = "vpc-8cafdae4"
  lifecycle {
    create_before_destroy = "true"
  }
  tags = {
    name = "terraform SG"
  }
}
//ingress
resource "aws_security_group_rule" "ssh_tf_test_sg" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_test_sg.id}"

}
resource "aws_security_group_rule" "egress_tf_test_sg" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.tf_test_sg.id}"

}
