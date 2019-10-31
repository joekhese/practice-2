#############################################
# Auto scaling group / EC2 gate keeper
// -launch configuration
// -Template file
// - auto scalling group
// - security group
// - SG rules
#################################################

#################################################
# Post Boot Script
#################################################
data "template_file" "dev_priv_post_boot_script" {
  template = "${file("${path.module}/templates/private_userdata.sh")}"
}

data "template_cloudinit_config" "dev_priv_script" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.dev_priv_post_boot_script.rendered}"
  }


}

################################################
# Launch config specific to ASG 
################################################
resource "aws_launch_configuration" "dev_priv_asg_lc" {
  name_prefix                 = "private_asg"
  image_id                    = "ami-00223fdf00dd4fd79"
  instance_type               = "t2.micro"
  key_name                    = "terraform-key"
  enable_monitoring           = "true"
  security_groups             = ["${aws_security_group.dev_priv_sg_res.id}"]
  associate_public_ip_address = true
  user_data                   = "${data.template_cloudinit_config.dev_priv_script.rendered}"
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "dev_priv_asg_res" {
  name                 = "${aws_launch_configuration.dev_priv_asg_lc.name}-asg" // refrencing the name of the Launch configuration
  min_size             = "1"
  max_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.dev_priv_asg_lc.name}"
  vpc_zone_identifier  = "${aws_subnet.dev_sbn_priv_res.*.id}" //keep in all subnets across all AZs, connected to the private subnet

  tags = [
    {
      key                 = "Name"
      value               = "Private ASG"
      propagate_at_launch = true
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}

