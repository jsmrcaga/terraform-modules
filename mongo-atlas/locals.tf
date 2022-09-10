locals {
	project = defaults(var.project, {
    teams = "" // for some reason terraform expects a string here...
    is_collect_database_specifics_statistics_enabled = true
    is_data_explorer_enabled = true
    is_performance_advisor_enabled = true
    is_realtime_performance_panel_enabled = true
    is_schema_advisor_enabled =  true
  })

  cluster = defaults(var.cluster, {
    type = "REPLICA_SET"
    auto_scaling = true
    mongo_version = "5.0"
    plan = "M0"
    cloud_provider = "TENANT"
    backing_cloud_provider = "AWS"
    cloud_region = "EU_WEST_3"
  }) 
}
