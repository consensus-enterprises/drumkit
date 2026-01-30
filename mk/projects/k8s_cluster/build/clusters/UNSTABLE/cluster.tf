# N.B. Variables cannot be used in resource names. As such, if the
# 'cluster_name' is changed, we will have to update it here too.
resource "openstack_containerinfra_cluster_v1" "${CLUSTER_NAME}" {
  name                = var.cluster_name
  cluster_template_id = var.cluster_template_id
  master_count        = var.cluster_master_count
  master_flavor       = var.cluster_master_flavor
  node_count          = var.cluster_node_count
  flavor              = var.cluster_node_flavor
  keypair             = var.cluster_keypair
  labels              = var.cluster_labels

  # N.B. Variables cannot be used in dependency declarations. As such, if the
  # 'cluster_keypair' is changed, we will have to update it here too.
  depends_on = [openstack_compute_keypair_v2.${CLUSTER_NAME_LC}-cluster-keypair]
}
