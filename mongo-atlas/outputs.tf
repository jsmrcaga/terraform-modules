output "project_id" {
  value = mongodbatlas_project.project.id
}

output "cluster_id" {
  value = mongodbatlas_cluster.db_cluster.cluster_id
}

output "cluster_connection_string" {
  value = mongodbatlas_cluster.db_cluster.connection_strings[0].standard
}

output "cluster_connection_string_srv" {
  value = mongodbatlas_cluster.db_cluster.connection_strings[0].standard_srv
}
