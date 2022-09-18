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
}

resource github_branch_protection "branch_protection" {
  repository_id = github_repository.repo.id

  for_each = local.branches
  pattern = each.key
  
  # Force status checks for admins
  enforce_admins = each.value.enforce_admins

  # Allows branch to be deleted
  allows_deletions = each.value.allows_deletions

  require_signed_commits = each.value.require_signed_commits

  # Forces no merge commits
  required_linear_history = each.value.required_linear_history

  # List of people that can push to the branch
  push_restrictions = each.value.push_restrictions

  required_pull_request_reviews {
    dismiss_stale_reviews = each.value.required_pull_request_reviews.dismiss_stale_reviews
    restrict_dismissals = each.value.required_pull_request_reviews.restrict_dismissals
    dismissal_restrictions = each.value.required_pull_request_reviews.dismissal_restrictions
    pull_request_bypassers = each.value.required_pull_request_reviews.pull_request_bypassers
    require_code_owner_reviews = each.value.required_pull_request_reviews.require_code_owner_reviews
    required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
  }

  required_status_checks {
    strict = each.value.required_status_checks.strict
    contexts = each.value.required_status_checks.contexts
  }
}
