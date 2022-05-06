terraform {
  backend "s3" {
    bucket = "assessment-s3bucket"
    key    = "terraform_state/infra"
    region = "eu-west-2"
    dynamodb_table = "assessment-tf-state-lock"
  }
}
