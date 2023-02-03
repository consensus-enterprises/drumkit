SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_cluster/clusters.mk

K8S_CLUSTER_DEFAULT_NAME = UNSTABLE
K8S_CLUSTER_RESOURCES_DIR =.mk/mk/projects/k8s_cluster
K8S_CLUSTER_NAME  ?= $(K8S_CLUSTER_DEFAULT_NAME)
K8S_CLUSTER_TEMPLATE_DIR  = $(K8S_CLUSTER_RESOURCES_DIR)/$(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_DEFAULT_NAME)
K8S_CLUSTER_DIR = build/clusters
K8S_CLUSTER_DRUMKIT_PREFIX= 25_cluster

# This list of vars will be passed to all templating operations below:
K8S_CLUSTER_TEMPLATE_VARS = \
    PROJECT_NAME=$(PROJECT_NAME) \
    CLUSTER_NAME=$(K8S_CLUSTER_NAME) \
    CLUSTER_NAME_LC=$(call lc,$(K8S_CLUSTER_NAME))

K8S_CLUSTER_FILES = \
    $(K8S_CLUSTER_DIR)/base/providers.tf \
    $(K8S_CLUSTER_DIR)/base/variables.tf \
    $(K8S_CLUSTER_DIR)/base/versions.tf \
    $(K8S_CLUSTER_DIR)/.gitignore \
    drumkit/bootstrap.d/40_kubernetes.sh

K8S_CLUSTER_TEMPLATE_FILES = \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/cluster.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/keypair.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/terraform.tfvars

K8S_CLUSTER_SYMLINKS = \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/providers.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/variables.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/versions.tf

K8S_CLUSTER_DRUMKIT_FILES= \
    drumkit/mk.d/$(K8S_CLUSTER_DRUMKIT_PREFIX)_$(K8S_CLUSTER_NAME).mk

# @TODO: Prompt for the Openstack cloud key during init, and pre-populate these vars.
init-k8s-cluster: init-k8s-cluster-intro
init-k8s-cluster: $(K8S_CLUSTER_FILES)
init-k8s-cluster: $(K8S_CLUSTER_TEMPLATE_FILES)
init-k8s-cluster: $(K8S_CLUSTER_SYMLINKS)
init-k8s-cluster: $(K8S_CLUSTER_DRUMKIT_FILES)
init-k8s-cluster: ## Initialize configuration and Drumkit targets to create and manage Kubernetes clusters on Openstack.
	$(ECHO)
	$(ECHO) "To build a cluster, you will need to specify which Openstack cloud"
	$(ECHO) "you would like to use in 'build/clusters/base/variables.tf'."
	$(ECHO) "Replace the 'default' for the 'openstack_cloud' variable with the"
	$(ECHO) "appropriate key from '~/.config/openstack/clouds.yaml'."
	$(ECHO)
	$(ECHO) "In addition, you will need to specify this name in 'Makefile' as:"
	$(ECHO) "    OS_CLOUD = <your-cloud-name>"
	$(ECHO)
	$(ECHO) "You should update the documentation in the following files to reflect"
	$(ECHO) "the intended use of this cluster:"
	$(ECHO) $(K8S_CLUSTER_DRUMKIT_FILES)
	$(ECHO)
	$(ECHO) "Created a 'kubectl' alias that uses the correct kubeconfig."
	$(ECHO) "$(WHITE)Remember to re-bootstrap Drumkit.'.$(RESET)"

init-k8s-cluster-intro:
	$(ECHO) ">>> $(WHITE)Creating '$(K8S_CLUSTER_NAME)' cluster.$(RESET) <<<"
	$(ECHO)

$(K8S_CLUSTER_TEMPLATE_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_CLUSTER_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_CLUSTER_TEMPLATE_DIR)/$(@F) \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_CLUSTER_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_CLUSTER_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_CLUSTER_RESOURCES_DIR)/$@ \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_CLUSTER_SYMLINKS):
	$(ECHO) "$(YELLOW)Creating symlink: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@ln -s ../base/$(@F) $@

$(K8S_CLUSTER_DRUMKIT_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_CLUSTER_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_CLUSTER_RESOURCES_DIR)/$(@D)/$(K8S_CLUSTER_DRUMKIT_PREFIX)_$(K8S_CLUSTER_DEFAULT_NAME).mk \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

