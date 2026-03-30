resource "aws_s3_bucket" "input" {
  bucket = "file-pipeline-input-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

output "input_bucket_name" {
  value = aws_s3_bucket.input.bucket
}

resource "aws_s3_bucket" "output" {
  bucket = "file-pipeline-output-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

output "output_bucket_name" {
  value = aws_s3_bucket.output.bucket
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}

resource "aws_lambda_function" "processor" {
  function_name    = "file-pipeline-processor"
  role             = data.aws_iam_role.labrole.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      OUTPUT_BUCKET = aws_s3_bucket.output.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input.arn
}

resource "aws_s3_bucket_notification" "input_notification" {
  bucket = aws_s3_bucket.input.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}