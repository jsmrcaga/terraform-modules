output "cluster" {
	value = aws_ecs_cluster.cluster
}

output "service" {
	value = aws_ecs_service.service
}

output "taskdef" {
	value = aws_ecs_task_definition.taskdef
}

output "task_role" {
  value = module.permissions.task_role
}

output "ecs_agent_role" {
  value = module.permissions.ecs_agent_role
}
