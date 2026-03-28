resource "aws_s3_bucket" "input" {
    bucket = "file-pipeline-input-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "output" {
  bucket = "file-pipeline-output-${data.aws_caller_identity.current.account_id}"
}