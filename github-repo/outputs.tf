output repo {
	value = github_repository.repo
}

output default_branch {
	value = github_branch_default.default_branch
}

output branch_protections {
  value = github_branch_protection.branch_protection
}

output actions_secrets {
  value = github_actions_secret.actions_secrets
}
