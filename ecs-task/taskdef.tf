locals {
  task_definition_with_image = merge(
    local.default_task_definition,
    var.task_definition.definition,
    {
      image = "${aws_ecr_repository.ecr_repo.repository_url}/${var.ecr.image_name}:latest"
    }
  )

  uses_fargate = local.service.launch_type == "FARGATE"
}


resource "aws_iam_role" "ecs_role_for_ecr" {
  count = local.uses_fargate ? 1 : 0
  name = "${replace(var.task_definition.family, "-", "_")}_role_ecs_for_ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          # allows ECS to assume this role
          Service = ["lambda.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_policy_for_ecr" {
  count = local.uses_fargate ? 1 : 0
  name = "${var.task_definition.family}_policy_ecs_for_ecr"

  role = aws_iam_role.ecs_role_for_ecr[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
      ]
      Resource = "*"
    }]
  })
}

resource "aws_ecs_task_definition" "taskdef" {
  family = var.task_definition.family

  container_definitions = jsonencode([local.task_definition_with_image])

  cpu = local.cpu_values[local.task_definition.cpu]
  memory = local.task_definition.memory
  execution_role_arn = local.uses_fargate ? aws_iam_role.ecs_role_for_ecr[0].arn : local.task_definition.execution_arn

  network_mode = local.task_definition.network_mode // awwsvpc for fargate

  requires_compatibilities = local.uses_fargate ? ["FARGATE"] : local.task_definition.requires_compatibilities

  dynamic volume {
    for_each = local.task_definition.volumes
    iterator = each

    content {
      name = each.key
      host_path = each.value
    }
  }
}
