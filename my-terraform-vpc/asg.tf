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
data "template_file" "dev_post_boot_script" {
  template = "${file("${path.module}/templates/userdata.sh")}" //path module is the folderwhere your project files are stored
}
data "template_cloudinit_config" "dev_script" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"                                  // allowing text and shell script
    content      = "${data.template_file.dev_post_boot_script.rendered}" // refrencing template_file above
  }
}

################################################
# Launch config specific to Bastion Host ASG
################################################

resource "aws_launch_configuration" "degv_bastion_ls_res" {
  name_prefix                 = "bastion"
  image_id                    = "ami-00223fdf00dd4fd79"
  instance_type               = "t2.micro"
  key_name                    = "terraform-key"
  enable_monitoring           = "true"
  security_groups             = ["${aws_security_group.dev_default_ssh_sg_res.id}"]
  associate_public_ip_address = true
  user_data                   = "${data.template_cloudinit_config.dev_script.rendered}"
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "dev_bastion_asg_res" {
  name                 = "${aws_launch_configuration.degv_bastion_ls_res.name}-asg" // refrencing the name of the Launch configuration
  min_size             = "1"
  max_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.degv_bastion_ls_res.name}"
  vpc_zone_identifier  = "${aws_subnet.dev_sbn_pub_res.*.id}" //keep in all subnets across all AZs

  tags = [
    {
      key                 = "Name"
      value               = "Bastion ASG"
      propagate_at_launch = true
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}



