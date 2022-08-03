variable "image_name" {
  description = "Container image name"

  type = string
}

variable "image_version" {
  description = "Container image version"

  type = string
}

variable "task_name" {
  description = "The name of ECS tasks launched by EventBridge (this name will be used for other resources provision as well)"

  type = string
}

variable "cpu" {
  description = "Amount of CPU allocated to the ECS task"

  type = number
}

variable "memory" {
  description = "Amount of Memory allocated to the ECS task"

  type = number
}

variable "log_group" {
  description = "Name of the AWS CloudWatch Log stream"

  type = string
}

variable "fargate_arn" {
  description = "ARN of the ECS Cluster"

  type = string
}

variable "subnets" {
  description = "Subnet(s) where the tasks will be launched/attached"

  type    = list(string)
  default = []
}


variable "security_groups" {
  description = "List of security groups attached to the Task ENI"

  type    = list(any)
  default = []
}

variable "environment_vars" {
  description = "Environment variables for the ECS task"

  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets for the ECS task"

  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "ecs_task_prefix" {
  description = "Define the Prefix for the ECS task and IAM role name."

  type    = string
  default = "ecstask_"
}

variable "ecs_iam_policies" {
  description = "List of policies to be attached on the created IAM role"

  type    = set(string)
  default = []
}

variable "ecs_iam_path" {
  description = "Path where the IAM role will be created"

  type    = string
  default = ""
}

variable "create_eventbridge_bus" {
  description = "Whether to provision the event bridge bus or use the account's default one"

  type    = bool
  default = false
}

variable "schedules" {
  description = "Define a list of cloudwatch events schedule expressions for the target. The value could be either a cron-expression or rate expression (see AWS official doc for details"

  type    = map(string)
  default = {}
}

