resource github_actions_secret "actions_secrets" {
  for_each = var.actions.secrets

  repository = github_repository.repo.name

  secret_name = each.key
  plaintext_value = each.value
}

resource github_actions_variable "variables" {
  for_each = var.actions.variables

  repository  = github_repository.repo.name
  variable_name = each.key
  value = each.value
}
