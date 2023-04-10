module permissions {
  source = "./permissions"

  task_definition = {
    family = var.task_definition.family
  }
}

locals {
  task_definition_with_image = merge(
    # Log confg comes first in case we override it later
    {
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.task_logs.name,
          awslogs-region = var.aws.region,
          awslogs-stream-prefix = var.task_definition.logs_prefix == "" ? var.task_definition.family : var.task_definition.logs_prefix
        }
      }
    },
    # Then the default task def (without logs obviously)
    local.default_task_definition,
    # The parent's definition
    var.task_definition.definition,
    # And finally the image from our newly created repository, not really important
    # since it will be overridden later in deployments
    {
      image = "${aws_ecr_repository.ecr_repo.repository_url}/${var.ecr.image_name}:latest"
    }
  )
}

resource "aws_ecs_task_definition" "taskdef" {
  family = var.task_definition.family

  container_definitions = jsonencode([local.task_definition_with_image])

  # For some reason using var.task_definition is creating unknown values
  # and thus cannot create/update our resource
  # so we went back to var for now
  cpu = local.cpu_values[var.task_definition.cpu]
  memory = var.task_definition.memory

  task_role_arn = module.permissions.task_role.arn
  execution_role_arn = module.permissions.ecs_agent_role.arn

  network_mode = var.task_definition.network_mode // awwsvpc for fargate

  requires_compatibilities = var.task_definition.requires_compatibilities

  dynamic volume {
    for_each = var.task_definition.volumes
    iterator = each

    content {
      name = each.key
      host_path = each.value
    }
  }
}
