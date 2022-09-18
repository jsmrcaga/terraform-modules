resource github_actions_secret "actions_secrets" {
  for_each = var.actions.secrets

  repository = github_repository.repo.name

  secret_name = each.key
  plaintext_value = each.value
}
