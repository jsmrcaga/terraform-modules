resource "aws_cloudwatch_log_group" "task_logs" {
  name = "ecs/${var.service.name}/${var.task_definition.family}"
}

# Allows our task to add logs
resource "aws_iam_role_policy" "task_policy_logs" {
  name = "${var.task_definition.family}_logs_policy"

  role = module.permissions.ecs_agent_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = [
        "arn:aws:logs:*:*:*"
      ]
    }]
  })
}
