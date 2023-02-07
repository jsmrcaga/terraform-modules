resource "github_repository_environment" "environment" {
  for_each = var.environments
  environment = each.key
  repository = github_repository.repo.name

  reviewers {
    users = each.value.reviewers.users
    teams = each.value.reviewers.teams
  }

  deployment_branch_policy {
    protected_branches = each.value.protected_branches
    custom_branch_policies = each.value.custom_branch_policies
  }
}
