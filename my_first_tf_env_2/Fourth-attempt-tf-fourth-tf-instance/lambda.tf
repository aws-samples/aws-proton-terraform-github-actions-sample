/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:987544922694:service/Fourth-attempt-tf/service-instance/fourth-tf-instance

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.service_instance.inputs.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.service_instance.inputs.handler

  s3_bucket = var.service_instance.inputs.function_s3_bucket
  s3_key    = var.service_instance.inputs.function_s3_key

  runtime = var.service_instance.inputs.lambda_runtime

  vpc_config {
    subnet_ids         = [var.environment.outputs.subnet_id]
    security_group_ids = [var.environment.outputs.security_group_id]
  }
}