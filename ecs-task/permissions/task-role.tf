resource "aws_iam_role" "task_role" {
  name = "${replace(var.task_definition.family, "-", "_")}_task_role"

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
