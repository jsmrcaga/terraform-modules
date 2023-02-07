variable github {
  type = object({
    token = string  
  })
}

variable name {
	type = string
}

variable description {
  type = string
  default = ""
}

variable topics {
  type = list(string)
}

variable visibility {
  type = string
  default = "private"
}

# Simple repo config
variable has_issues {
  type = bool
  default = true
}

variable has_projects {
  type = bool
  default = true
}

variable has_wiki {
  type = bool
  default = true
}

variable vulnerability_alerts {
  type = bool
  default = false
}

# Merging
variable allow_merge_commit {
  type = bool
  default = false
}

variable allow_squash_merge {
  type = bool
  default = false
}

variable allow_rebase_merge {
  type = bool
  default = true
}

variable allow_auto_merge {
  type = bool
  default = false
}


# Actions
variable actions {
  type = object({
    secrets = map(string)  
  })

  default = {
    secrets: {}
  }
}

# Environments
variable environments {
  # key = environment name
  # value = environment config
  type = map(object({
    wait_timer = optional(number)
    protected_branches = optional(bool, true)
    custom_branch_policies = optional(bool, true)

    reviewers = object({
      users = list(string)
      teams = optional(list(string), [])
    })
  }))

  default = {}
}

# Branch protection
variable branches {
  type = map(object({
    enforce_admins = optional(bool, true)
    allows_deletions = optional(bool, false)
    require_signed_commits = optional(bool, true)
    required_linear_history = optional(bool, true)
    push_restrictions = optional(set(string))
    
    required_status_checks = object({
      strict = optional(bool, false)
      contexts = optional(set(string))
    })

    required_pull_request_reviews = object({
      dismiss_stale_reviews = optional(bool, false)
      restrict_dismissals = optional(bool, false)
      dismissal_restrictions = optional(list(string))
      pull_request_bypassers = optional(list(string))
      require_code_owner_reviews = optional(bool, false)
      required_approving_review_count = optional(number, 0)
    })
  }))

  default = {}
}

variable pages {
  type = object({
    cname = optional(string)
    github_actions = optional(bool, true)

    source = optional(object({
      branch = string
      path = string
    }))
  })

  default = null
}
