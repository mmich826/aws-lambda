data "archive_file" "lambda_zip" {
    type        = "zip"
    source_file = "../../handler.js"
    output_path = "../../build/inv-pipe-s3-lambda.zip"
}

resource "aws_lambda_function" "inv-pipe-s3-lambda" {
  function_name = "inv-pipe-s3-lambda"
  handler = "handler.handler"
  runtime = "nodejs6.10"
  filename = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  role = "${aws_iam_role.inv-pipe-s3-lambda-exec-role.arn}"
}

resource "aws_lambda_permission" "inv-pipe-s3-lambda-permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.inv-pipe-s3-lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.inv-pipe-s3-lambda-trigger.arn}"
}
