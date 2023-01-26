variable "openstack_cloud" {
  description = "The key for this project's cloud in `clouds.yaml`."
  type = string
  default = "CHANGE_ME"
}

# We are hoping to supply multiple keys when provisioning clusters, but have
# yet to figure out a working syntax. Heredoc, as suggested here, does not work:
# https://stackoverflow.com/questions/60722012/make-terraform-resource-key-multiline
variable "admins" {
  description = "Our admin team and their SSH public keys."
  type = map
  default = {
    christopher = {
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZ/UZdtU2KQXpFm2z6chGiJ01IFD2wZlu2BSsbAkgrP ergonlogic@fafnir"
    },
    dan = {
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZykEmlvgdvS6yLkvTSwq4kzKBPxHvRSYNf9EOlz9kP dan@shprintze"
    },
  }
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type = string
}

variable "cluster_keypair" {
  description = "The keypair with which to pre-seed Kubernetes cluster nodes."
  type = string
  default = "christopher-keypair"
}

variable "cluster_template_id" {
  description = "The container orchestration engine (COE) template to use when instantiating the Kubernetes cluster."
  type = string
  # ref. https://dashboard.vexxhost.net/project/cluster_templates
  default = "cdf4cfc8-2dce-4671-8639-a66f1a325e5c"
}

variable "cluster_master_count" {
  description = "The number of VMs to deploy for the control plane."
  type = number
  default = 3
}

variable "cluster_master_flavor" {
  description = "The type of VMs to deploy for the control plane."
  type = string
  default = "v3-starter-2"
}

variable "cluster_node_count" {
  description = "The number of VMs to deploy for the cluster nodes."
  type = number
  default = 3
}

variable "cluster_node_flavor" {
  description = "The type of VMs to deploy for the cluster nodes."
  type = string
  default = "v3-starter-4"
}

# N.B. 'merge_labels' doesn't work, so we need to reproduce all the labels from
# the template. This is all just to remove 'PodSecurityPolicy'; see below.
variable "cluster_labels" {
  description = "Labels to pass to the COE template."
  type = map
  default = {
    # Disable PodSecurityPolicy  <-- This interferes with certificate generation, and has been deprecated.
    # @TODO: Remove this once we're using a more recent version of Kubernetes, where PodSecurityPolicy has been removed.
    admission_control_list        = "NodeRestriction,NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,TaintNodesByCondition,Priority,DefaultTolerationSeconds,DefaultStorageClass,StorageObjectInUseProtection,PersistentVolumeClaimResize,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,RuntimeClass"
    boot_volume_size              = "100"
    cloud_provider_tag            = "v1.18.0"
    container_infra_prefix        = "registry.public.yul1.vexxhost.net/magnum/"
    etcd_volume_size              = "20"
    helm_client_sha256            = "270acb0f085b72ec28aee894c7443739271758010323d72ced0e92cd2c96ffdb"
    helm_client_tag               = "v3.4.0"
    helm_client_url               = "https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz"
    kube_tag                      = "v1.21.1"
    master_lb_floating_ip_enabled = "true"
  }
}

