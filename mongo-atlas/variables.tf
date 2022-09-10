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
      teams = optional(map(list(string)))
      is_collect_database_specifics_statistics_enabled = optional(bool)
      is_data_explorer_enabled = optional(bool)
      is_performance_advisor_enabled = optional(bool)
      is_realtime_performance_panel_enabled = optional(bool)
      is_schema_advisor_enabled = optional(bool)
    })
}

variable cluster {
    type = object({
      name = string
      type = optional(string)
      auto_scaling = optional(bool)
      mongo_version = optional(string)
      plan = optional(string)
      cloud_provider = optional(string)
      backing_cloud_provider = optional(string)
      cloud_region = optional(string)
    })
}
