SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_cluster/clusters.mk

K8S_CLUSTER_DEFAULT_NAME = UNSTABLE
K8S_CLUSTER_RESOURCES_DIR =.mk/mk/projects/k8s_cluster
K8S_CLUSTER_NAME  ?= $(K8S_CLUSTER_DEFAULT_NAME)
K8S_CLUSTER_TEMPLATE_DIR  = $(K8S_CLUSTER_RESOURCES_DIR)/$(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_DEFAULT_NAME)
K8S_CLUSTER_DIR = build/clusters

K8S_CLUSTER_BASE_FILES = \
    $(K8S_CLUSTER_DIR)/base/providers.tf \
    $(K8S_CLUSTER_DIR)/base/variables.tf \
    $(K8S_CLUSTER_DIR)/base/versions.tf

K8S_CLUSTER_TEMPLATE_FILES = \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/cluster.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/keypair.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/terraform.tfvars

K8S_CLUSTER_SYMLINKS = \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/providers.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/variables.tf \
    $(K8S_CLUSTER_DIR)/$(K8S_CLUSTER_NAME)/versions.tf

# @TODO: Prompt for the Openstack cloud key during init, and pre-populate these vars.
init-k8s-cluster: init-k8s-cluster-intro
init-k8s-cluster: $(K8S_CLUSTER_BASE_FILES)
init-k8s-cluster: $(K8S_CLUSTER_TEMPLATE_FILES)
init-k8s-cluster: $(K8S_CLUSTER_SYMLINKS)
init-k8s-cluster: $(K8S_CLUSTER_DIR)/.gitignore
init-k8s-cluster: drumkit/mk.d/25_cluster_$(K8S_CLUSTER_NAME).mk
init-k8s-cluster: ## Initialize configuration and Drumkit targets to create and manage Kubernetes clusters on Openstack.
	@$(ECHO)
	@$(ECHO) "To build a cluster, you will need to specify which Openstack cloud"
	@$(ECHO) "you would like to use in 'build/clusters/base/variables.tf'."
	@$(ECHO) "Replace the 'default' for the 'openstack_cloud' variable with the"
	@$(ECHO) "appropriate key from '~/.config/openstack/clouds.yaml'."
	@$(ECHO)
	@$(ECHO) "In addition, you will need to specify this name in 'Makefile' as:"
	@$(ECHO) "    OS_CLOUD = <your-cloud-name>"
	@$(ECHO)

init-k8s-cluster-intro:
	@$(ECHO) ">>> $(WHITE)Creating '$(K8S_CLUSTER_NAME)' cluster.$(RESET) <<<"
	@$(ECHO)

$(K8S_CLUSTER_DIR)/.gitignore:
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@cp $(K8S_CLUSTER_RESOURCES_DIR)/$(K8S_CLUSTER_DIR)/$(@F) $@

drumkit/mk.d/25_cluster_$(K8S_CLUSTER_NAME).mk:
	@$(ECHO) "$(YELLOW)Creating makefile: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@CLUSTER_NAME=$(K8S_CLUSTER_NAME) CLUSTER_NAME_LC=$(call lc,$(K8S_CLUSTER_NAME)) mustache ENV $(K8S_CLUSTER_RESOURCES_DIR)/drumkit/mk.d/25_cluster_$(K8S_CLUSTER_DEFAULT_NAME).mk > $@

$(K8S_CLUSTER_TEMPLATE_FILES):
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@CLUSTER_NAME=$(K8S_CLUSTER_NAME) CLUSTER_NAME_LC=$(call lc,$(K8S_CLUSTER_NAME)) mustache ENV $(K8S_CLUSTER_TEMPLATE_DIR)/$(@F) > $@
$(K8S_CLUSTER_BASE_FILES):
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@CLUSTER_NAME=$(K8S_CLUSTER_NAME) CLUSTER_NAME_LC=$(call lc,$(K8S_CLUSTER_NAME)) mustache ENV $(K8S_CLUSTER_RESOURCES_DIR)/$@ > $@
$(K8S_CLUSTER_SYMLINKS):
	@$(ECHO) "$(YELLOW)Creating symlink: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@ln -s ../base/$(@F) $@
