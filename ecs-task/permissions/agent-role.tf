resource "aws_iam_role" "ecs_role_for_ecr" {
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
          Service = ["ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_policy_for_ecr" {
  name = "${var.task_definition.family}_policy_ecs_for_ecr"

  role = aws_iam_role.ecs_role_for_ecr.id

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
