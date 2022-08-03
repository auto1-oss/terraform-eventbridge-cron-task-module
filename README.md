# A Terraform module for event-driven ECS tasks with AWS EventBridge

This terraform modules provides the ability to provision one or more ECS tasks
that will be trigger by an AWS EventBridge (formally known as AWS CloudWatch
Events). 

Notice: As of now, the tasks only provides cron-scheduled types. But, in the future it
should provide any event-trigger AWS EventBridge provides.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | terraform-aws-modules/eventbridge/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Amount of CPU allocated to the ECS task | `number` | n/a | yes |
| <a name="input_create_eventbridge_bus"></a> [create\_eventbridge\_bus](#input\_create\_eventbridge\_bus) | Whether to provision the event bridge bus or use the account's default one | `bool` | `false` | no |
| <a name="input_ecs_iam_path"></a> [ecs\_iam\_path](#input\_ecs\_iam\_path) | Path where the IAM role will be created | `string` | `""` | no |
| <a name="input_ecs_iam_policies"></a> [ecs\_iam\_policies](#input\_ecs\_iam\_policies) | List of policies to be attached on the created IAM role | `set(string)` | `[]` | no |
| <a name="input_ecs_task_prefix"></a> [ecs\_task\_prefix](#input\_ecs\_task\_prefix) | Define the Prefix for the ECS task and IAM role name. | `string` | `"ecstask_"` | no |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | Environment variables for the ECS task | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_fargate_arn"></a> [fargate\_arn](#input\_fargate\_arn) | ARN of the ECS Cluster | `string` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Container image name | `string` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Container image version | `string` | n/a | yes |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | Name of the AWS CloudWatch Log stream | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount of Memory allocated to the ECS task | `number` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | Define a list of cloudwatch events schedule expressions for the target. The value could be either a cron-expression or rate expression (see AWS official doc for details | `map(string)` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets for the ECS task | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups attached to the Task ENI | `list(any)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet(s) where the tasks will be launched/attached | `list(string)` | `[]` | no |
| <a name="input_task_name"></a> [task\_name](#input\_task\_name) | The name of ECS tasks launched by EventBridge (this name will be used for other resources provision as well) | `string` | n/a | yes |

## Outputs

No outputs.

## Examples

```hlc
module "terraform-eventbridge-cron-task-module" {
  task_name     = "vacuum_cleaner"
  cpu           = 128
  memory        = 128
  image_name    = "registry/my/awesome-app"
  image_version = "latest"
  environment_vars = [
	{ name = "app_command", value = "vaccum_start" }
  ]
  
  schedules = {
	"15m" = "rate(15 minutes)"
	"6h"  = "rate(6 hours)"
  }
}
```
