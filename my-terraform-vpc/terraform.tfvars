cidr_block        = "10.20.0.0/16"
vpc_name          = "dev_env_vpc"
availability_zone = ["ca-central-1a", "ca-central-1b"]
asg_ip_addr = "dev_bastion_asg_res.self.self.public_ip"