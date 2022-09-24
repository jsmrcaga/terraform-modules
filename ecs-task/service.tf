data "aws_subnets" "general_subnets" {}

locals {
  network_config = local.service.launch_type == "FARGATE" ? [1] : []
}

resource "aws_ecs_service" "service" {
  name = var.service.name
  cluster = aws_ecs_cluster.cluster.arn

  task_definition = aws_ecs_task_definition.taskdef.arn

  desired_count = local.service.desired_count
  iam_role = null

  health_check_grace_period_seconds = local.service.health_check_grace_period_seconds
  launch_type = local.service.launch_type

  platform_version = local.service.platform_version

  deployment_maximum_percent = local.service.deployment_maximum_percent // 200 to be safe
  deployment_minimum_healthy_percent = local.service.deployment_minimum_healthy_percent

  dynamic network_configuration {
    for_each = local.network_config
    iterator = each

    content {
      subnets = data.aws_subnets.general_subnets.ids
    }
  }
}
