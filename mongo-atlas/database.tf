resource "mongodbatlas_project" "project" {
  name = var.project.name
  org_id = var.project.organization_id
  project_owner_id = local.project.owner_id

  # Build teams specification
  dynamic "teams" {
    for_each = local.project.teams
    iterator = each

    content {
      team_id = each.key
      role_names = each.value
    }
  }

  is_collect_database_specifics_statistics_enabled = local.project.is_collect_database_specifics_statistics_enabled
  is_data_explorer_enabled = local.project.is_data_explorer_enabled
  is_performance_advisor_enabled = local.project.is_performance_advisor_enabled
  is_realtime_performance_panel_enabled = local.project.is_realtime_performance_panel_enabled
  is_schema_advisor_enabled = local.project.is_schema_advisor_enabled
}

# Very simple cluster config
resource "mongodbatlas_cluster" "db_cluster" {
  # Cluster config
  project_id = mongodbatlas_project.project.id
  name = var.cluster.name

  # for some reason M0 clusters do not accept cluster_type (HTTP 500)
  # cluster_type = local.cluster.type

  auto_scaling_disk_gb_enabled = local.cluster.auto_scaling
  mongo_db_major_version = local.cluster.mongo_version

  # Provider
  provider_instance_size_name = local.cluster.plan
  provider_name = local.cluster.cloud_provider
  backing_provider_name = local.cluster.backing_cloud_provider
  provider_region_name = local.cluster.cloud_region
}
