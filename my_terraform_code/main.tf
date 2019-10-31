resource "aws_instance" "instance_demo" {
  ami           = "${var.amitype}" //calling the variable amitype in variables.tf
  count         = 1                // instance count of 3
  instance_type = "t2.micro"       //
  key_name      = "terraform-key"  //.pem key name

  tags = {
    Name = "instancedemo-${count.index}" //incrementing the instance tags
  } 
vpc_security_group_ids = ["${aws_security_group.tf_test_sg.id}"]
  
    connection {
    type        = "ssh"
    user        = "centos"
    private_key = "${file("./terraform-key.pem")}"
    timeout     = "3m"
    host        = "${self.public_ip}"
    #host        = "${self.private_ip}"
  }
}
# Post Boot Script
#################################################

data "template_file" "dev_post_boot_script" {
  template = "${file("${path.module}/templates/install.sh")}" //path module is the folderwhere your project files are stored
}
data "template_cloudinit_config" "dev_script" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"                                  // allowing text and shell script
    content      = "${data.template_file.dev_post_boot_script.rendered}" // refrencing template_file above
  }
  
}