resource "aws_s3_bucket" "dm_s3_res" {
  bucket = "khese-terraform-statefile-test"
  acl    = "private"

  tags = {
    Name        = "my_s3_bucket"
    Environment = "Dev"
  }

}
