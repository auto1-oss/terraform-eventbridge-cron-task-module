#
# This file is part of the auto1-oss/terraform-eventbridge-cron-task-module.
#
# (c) AUTO1 Group SE https://www.auto1-group.com
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "${var.ecs_task_prefix}${var.task_name}"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  path               = var.ecs_iam_path
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  for_each   = var.ecs_iam_policies
  role       = aws_iam_role.ecs_role.name
  policy_arn = each.value
}
