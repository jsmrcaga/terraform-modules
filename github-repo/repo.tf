resource github_repository "repo" {
  name = var.name
  description = var.description

  archived = var.archived
  auto_init = var.auto_init

  visibility = var.visibility

  has_wiki = var.has_wiki
  has_issues = var.has_issues
  has_projects = var.has_projects
  has_downloads = var.has_downloads
  has_discussions = var.has_discussions

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge = var.allow_auto_merge

  squash_merge_commit_title = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message
  merge_commit_title = var.merge_commit_title
  merge_commit_message = var.merge_commit_message

  homepage_url = var.homepage_url
  is_template = var.is_template

  archive_on_destroy = var.archive_on_destroy
  delete_branch_on_merge = var.delete_branch_on_merge
  web_commit_signoff_required = var.web_commit_signoff_required

  gitignore_template = var.gitignore_template
  license_template = var.license_template

  topics = var.topics

  vulnerability_alerts = var.vulnerability_alerts

  dynamic "pages" {
    # null is handled on locals
    for_each = local.pages
    iterator = each

    content {
      cname = each.value.cname

      # Cannot make this dynamic since at least 1 is required
      source {
        branch = coalesce(each.value.source.branch, "master")
        path = coalesce(each.value.source.path, "/")
      }
    }
  }
}

resource github_branch_default "default_branch" {
  repository = github_repository.repo.name
  branch = var.default_branch
}

resource github_branch_protection "branch_protection" {
  repository_id = github_repository.repo.id

  for_each = var.branches
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
