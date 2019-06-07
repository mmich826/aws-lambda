resource "aws_iam_role" "inv-pipe-s3-lambda-exec-role" {
  name = "inv-pipe-s3-lambda-exec-role${var.cars-env != "prod" ? "-${var.cars-env}" : "" }"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": [
         "lambda.amazonaws.com"
       ]
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy" "inv-pipe-s3-lambda-policy" {
  name = "inv-pipe-s3-lambda-policy${var.cars-env != "prod" ? "-${var.cars-env}" : "" }"
  role = "${aws_iam_role.inv-pipe-s3-lambda-exec-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask"
      ],
      "Resource": [
          "arn:aws:ecs:us-east-1:421956431754:task-definition/inv-pipe-s3-pilot*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "${aws_iam_role.inv-pipe-s3-ecs-exec-role.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "inv-pipe-s3-ecs-exec-role" {
  name = "inv-pipe-s3-ecs-exec-role${var.cars-env != "prod" ? "-${var.cars-env}" : "" }"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": [
         "ecs-tasks.amazonaws.com"
       ]
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy" "inv-pipe-s3-ecs-policy" {
  name = "inv-pipe-s3-ecs-policy${var.cars-env != "prod" ? "-${var.cars-env}" : "" }"
  role = "${aws_iam_role.inv-pipe-s3-ecs-exec-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecs:List*",
        "ecs:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
