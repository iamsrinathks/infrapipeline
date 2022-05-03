terraform {
  backend "s3" {
    encrypt = true
    bucket         = "myassessmentbuckettesting01052022"
    dynamodb_table = "terraform-tf-state-lock"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }
}
