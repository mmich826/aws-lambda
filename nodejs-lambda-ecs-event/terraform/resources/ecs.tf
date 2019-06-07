
resource "aws_ecs_cluster" "inv-pipe-s3-cluster" {
  name = "inv-pipe-s3${var.env != "prod" ? "-${var.env}" : "" }"
}

resource "aws_ecs_task_definition" "inv-pipe-s3-service" {
  family                   = "inv-pipe-s3${var.env != "prod" ? "-${var.env}" : "" }"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = "${aws_iam_role.inv-pipe-s3-ecs-exec-role.arn}"
  execution_role_arn       = "${aws_iam_role.inv-pipe-s3-ecs-exec-role.arn}"
  cpu                      = 512
  memory                   = 1024

  container_definitions = <<DEFINITION
      [{
          "name": "inv-pipe-s3-lambda${var.env != "prod" ? "-${var.env}" : "" }",
          "image": "${var.image_name}",
          "portMappings": [
            {
              "containerPort": 5050,
              "hostPort": 5050
            }
          ],
          "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                  "awslogs-group": "${aws_cloudwatch_log_group.inv-pipe-s3-lambda-log-group.name}",
                  "awslogs-region": "${lookup(module.cars_region.default_region, "${var.aws-infra-env}")}",
                  "awslogs-stream-prefix": "web"
              }
          },
          "environment": [
              {
                "Name": "FORCE_ECS_DEPLOYMENT",
                "Value": "5"
              }
          ]
      }]
DEFINITION
}

resource "aws_ecs_service" "inv-pipe-s3-lambda-service" {
  name                               = "inv-pipe-s3-lambda${var.env != "prod" ? "-${var.env}" : "" }"
  cluster                            = "${aws_ecs_cluster.inv-pipe-s3-cluster.id}"
  desired_count                      = 0
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  
  network_configuration = [{
    subnets = ["${lookup(module.cars_aws_network_ids.subnet_id, "${var.aws-infra-env}.${lookup(module.cars_region.default_region, "${var.aws-infra-env}")}.Application0Subnet")}",
      "${lookup(module.cars_aws_network_ids.subnet_id, "${var.aws-infra-env}.${lookup(module.cars_region.default_region, "${var.aws-infra-env}")}.Application1Subnet")}",
      "${lookup(module.cars_aws_network_ids.subnet_id, "${var.aws-infra-env}.${lookup(module.cars_region.default_region, "${var.aws-infra-env}")}.Application2Subnet")}",
    ]
  }]

  task_definition = "${aws_ecs_task_definition.inv-pipe-s3-service.family}:${aws_ecs_task_definition.inv-pipe-s3-service.revision}"
}
