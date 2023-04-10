resource "mongodbatlas_project" "project" {
  name = var.project.name
  org_id = var.project.organization_id
  project_owner_id = var.project.owner_id

  # Build teams specification
  dynamic "teams" {
    for_each = var.project.teams
    iterator = each

    content {
      team_id = each.key
      role_names = each.value
    }
  }

  is_collect_database_specifics_statistics_enabled = var.project.is_collect_database_specifics_statistics_enabled
  is_data_explorer_enabled = var.project.is_data_explorer_enabled
  is_performance_advisor_enabled = var.project.is_performance_advisor_enabled
  is_realtime_performance_panel_enabled = var.project.is_realtime_performance_panel_enabled
  is_schema_advisor_enabled = var.project.is_schema_advisor_enabled
}

# Very simple cluster config
resource "mongodbatlas_cluster" "db_cluster" {
  # Cluster config
  project_id = mongodbatlas_project.project.id
  name = var.cluster.name

  # for some reason M0 clusters do not accept cluster_type (HTTP 500)
  # cluster_type = var.cluster.type

  auto_scaling_disk_gb_enabled = var.cluster.auto_scaling
  mongo_db_major_version = var.cluster.mongo_version

  # Provider
  provider_instance_size_name = var.cluster.plan
  provider_name = var.cluster.cloud_provider
  backing_provider_name = var.cluster.backing_cloud_provider
  provider_region_name = var.cluster.cloud_region
}

resource "mongodbatlas_database_user" "db_users" {
  count = length(var.users)

  username = var.users[count.index].username
  password = var.users[count.index].password

  project_id = mongodbatlas_project.project.id
  auth_database_name = "admin"

  scopes {
    name = var.cluster.name
    type = "CLUSTER"
  }

  dynamic "roles" {
    for_each = var.users[count.index].roles
    iterator = each

    content {
      role_name = each.key
      database_name = each.value
    }
  }
}
