# resource "aws_s3_bucket" "tf_remote_state" {
#   bucket = "myassessmentbuckettesting01052022"
#     lifecycle {
#      prevent_destroy = true
#    }
#    force_destroy = true
#  }
#
# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.tf_remote_state.bucket
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
#
# resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
#   bucket = aws_s3_bucket.tf_remote_state.bucket
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
#
# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name         = "terraform-tf-state-lock"
#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
