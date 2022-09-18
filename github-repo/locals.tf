locals {
	branches = defaults(var.branches, {
    enforce_admins = true
    allows_deletions = false
    require_signed_commits = false
    required_linear_history = true

    required_pull_request_reviews = {
      dismiss_stale_reviews = false
      restrict_dismissals = false
      require_code_owner_reviews = false
      required_approving_review_count = 0
    }

    required_status_checks = {
      strict = false
    }
  })

  environments = defaults(var.environments, {
    protected_branches = true
    custom_branch_policies = true

    reviewers = {
      users = ""
      teams = ""
    }
  })
}
