# We are hoping to supply multiple keys when provisioning clusters, but have
# yet to figure out a working syntax. Heredoc, as suggested here, does not work:
# https://stackoverflow.com/questions/60722012/make-terraform-resource-key-multiline

resource "openstack_compute_keypair_v2" "${CLUSTER_NAME_LC}-cluster-keypair" {
  name       = "${CLUSTER_NAME_LC}-cluster-keypair"
  public_key = var.admins.christopher.public_key
}
