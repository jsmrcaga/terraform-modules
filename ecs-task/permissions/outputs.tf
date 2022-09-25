output "task_role" {
  value = aws_iam_role.task_role
}

output "ecs_agent_role" {
  value = aws_iam_role.ecs_role_for_ecr
}
