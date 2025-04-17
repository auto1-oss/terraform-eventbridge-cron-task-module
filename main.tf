#
# This file is part of the auto1-oss/terraform-eventbridge-cron-task-module.
#
# (c) AUTO1 Group SE https://www.auto1-group.com
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

locals {

  # TODO: Define log configuration based on user input and launch type
  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = data.aws_region.current.name
      awslogs-group         = var.task_name
      awslogs-create-group  = "true"
      awslogs-stream-prefix = var.task_name
    }
  }
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "task" {
  family                   = var.task_name
  task_role_arn            = aws_iam_role.ecs_role.arn
  execution_role_arn       = aws_iam_role.ecs_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" # fargate demands this
  cpu                      = tostring(var.cpu)
  memory                   = tostring(var.memory)
  container_definitions = jsonencode([{
    name             = var.task_name
    image            = "${var.image_name}:${var.image_version}"
    cpu              = var.cpu
    memory           = var.memory
    environment      = var.environment_vars
    essential        = true
    logConfiguration = local.log_configuration
    secrets          = var.secrets
  }])
}
