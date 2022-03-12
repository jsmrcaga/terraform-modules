resource github_repository "repo" {
  name = var.name
  description = var.description

  visibility = var.visibility

  has_issues = var.has_issues
  has_projects = var.has_projects
  has_wiki = var.has_wiki

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge = var.allow_auto_merge

  topics = var.topics

  vulnerability_alerts = var.vulnerability_alerts

  pages {
    cname = var.pages.cname

    source {
      branch = var.pages.branch
      path = var.pages.path
    }
  }
}

resource github_actions_secret "actions_secrets" {
  for_each = var.actions.secrets

  repository = github_repository.repo.name

  secret_name = each.key
  plaintext_value = each.value
}

resource github_branch_protection "branch_protection" {
  for_each = var.branches
  pattern = each.key
  
  # Force status checks for admins
  enforce_admins = lookup(each.value, "enforce_admins", true)

  # Allows branch to be deleted
  allows_deletions = lookup(each.value, "allows_deletions", false)

  require_signed_commits = lookup(each.value, "require_signed_commits", false)

  # Forces no merge commits
  required_linear_history = lookup(each.value, "required_linear_history", true)

  # List of people that can push to the branch
  push_restrictions = lookup(each.value, "push_restrictions", null)

  required_pull_request_reviews = lookup(each.value, "required_pull_request_reviews", null)
  required_status_checks = lookup(each.value, "required_status_checks", null)
}
