variable public_key {
  type = string
}

variable private_key {
  type = string
}

variable project {
    type = object({
      name = string
      organization_id = string
      owner_id = optional(string)
      teams = optional(map(list(string)), {})
      is_collect_database_specifics_statistics_enabled = optional(bool, true)
      is_data_explorer_enabled = optional(bool, true)
      is_performance_advisor_enabled = optional(bool, true)
      is_realtime_performance_panel_enabled = optional(bool, true)
      is_schema_advisor_enabled = optional(bool, true)
    })
}

variable cluster {
    type = object({
      name = string
      type = optional(string, "REPLICA_SET")
      auto_scaling = optional(bool, true)
      mongo_version = optional(string, "5.0")
      plan = optional(string, "M0")
      cloud_provider = optional(string, "TENANT")
      backing_cloud_provider = optional(string, "AWS")
      cloud_region = optional(string, "EU_WEST_3")
    })
}

variable users {
  type = list(object({
    username = string
    password = string
    roles = map(string)
  }))

  default = []
}
