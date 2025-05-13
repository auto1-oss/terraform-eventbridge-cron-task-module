#
# This file is part of the auto1-oss/terraform-eventbridge-cron-task-module.
#
# (c) AUTO1 Group SE https://www.auto1-group.com
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

locals {

  # parse schedules into a event-bridge expected rules
  schedules_rules = { for key, expr in var.schedules :
    # Each rule/target will be created with name: <task-name>-<rule-name>.
    # the <rule-name> will be normalise into `camelCase` form. For example:
    #     every 5 minute => <task-name>-Every5Minute
    format("%s-%s", var.task_name, replace(title(key), " ", "")) => {
      name                = "Schedule ${var.task_name} on ${key}"
      description         = "Trigger for ${var.task_name} on ${key}"
      schedule_expression = expr
      fargate_arn         = var.fargate_arn
    }
  }
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus        = var.create_eventbridge_bus
  create_role       = true
  attach_ecs_policy = true
  role_path         = var.ecs_iam_path
  role_name         = "${var.ecs_task_prefix}eventbridge-${var.task_name}"

  # TODO: Support more than one tasks? 
  ecs_target_arns = [aws_ecs_task_definition.task.arn]

  rules = tomap({ for key, value in local.schedules_rules :
    key => {
      description         = value["description"]
      schedule_expression = value["schedule_expression"]
    }
  })

  targets = tomap({ for key, value in local.schedules_rules :
    key => [
      {
        name            = value["name"]
        arn             = value["fargate_arn"]
        input           = jsonencode({ "job" : "cron-by-rate" })
        attach_role_arn = true

        ecs_target = {
          launch_type         = "FARGATE"
          task_count          = 1 // always one - as this are jobs
          task_definition_arn = aws_ecs_task_definition.task.arn

          network_configuration = {
            subnets          = var.subnets
            security_groups  = var.security_groups
            assign_public_ip = false
          }
        }
      }
    ]
  })
}
