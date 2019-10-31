provider "aws" {
  access_key = "AKIA53TLIOI4JIHMG4J6"
  secret_key = "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"
  region     = "ca-central-1"
}
terraform {
  required_version = ">=0.12.9"

  backend "s3" {
    bucket  = "khese-terraform-statefile-test"
    key     = "joe_sfile_dir/terraform.tfstate"
    region  = "ca-central-1"
    encrypt = "true"
  }


}
