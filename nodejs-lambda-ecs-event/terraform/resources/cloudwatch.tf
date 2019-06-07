resource "aws_cloudwatch_log_group" "inv-pipe-s3-lambda-log-group" {
  name = "/ecs/${var.project-name}${var.env != "prod" ? "-${var.env}" : "" }"
}

resource "aws_cloudwatch_log_stream" "debugStreamName" {
  log_group_name = "${aws_cloudwatch_log_group.inv-pipe-s3-lambda-log-group.name}"
  name           = "debug-stream"
}

resource "aws_cloudwatch_log_stream" "infoStreamName" {
  log_group_name = "${aws_cloudwatch_log_group.inv-pipe-s3-lambda-log-group.name}"
  name           = "info-stream"
}

resource "aws_cloudwatch_log_stream" "errorStreamName" {
  log_group_name = "${aws_cloudwatch_log_group.inv-pipe-s3-lambda-log-group.name}"
  name           = "error-stream"
}

resource "aws_cloudwatch_event_rule" "inv-pipe-s3-lambda-trigger" {
  name        = "inv-pipe-s3-lambda-trigger"
  description = "Event rule to trigger lambda function to start ECS task every day"
  schedule_expression = "${var.cron_time}"
}

resource "aws_cloudwatch_event_target" "inv-pipe-s3-lambda-target" {
  target_id = "inv-pipe-s3-lambda-target"
  rule = "${aws_cloudwatch_event_rule.inv-pipe-s3-lambda-trigger.name}"
  arn = "${aws_lambda_function.inv-pipe-s3-lambda.arn}"
}
