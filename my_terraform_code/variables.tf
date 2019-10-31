variable "amitype" {
  //default = "ami-00223fdf00dd4fd79"
  //default = "ami-0b85d4ff00de6a225"
  default = "ami-09cb623ff4de9f9e4" //packer ami
}
variable "security_groups" {
  type    = "list"
  default = ["sg-0307343eac81e4e2e", "sg-0a63aa30b7835c2ac"]
}

