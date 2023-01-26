###########################
# Create/destroy clusters #
###########################

TF_CLUSTER_DIR     = build/clusters/$(K8S_CLUSTER_NAME)
terraform          = terraform -chdir=$(TF_CLUSTER_DIR)
K8S_SYSTEM_TOKEN  ?= $(shell $(kubectl) --namespace=kube-system get secrets |grep admin-token|awk '{print $$1}')
K8S_TOKEN         ?= $(shell $(kubectl) --namespace=kube-system describe secrets/$(K8S_SYSTEM_TOKEN) |grep "token:"|awk -F: '{print $$2}'|xargs)
K8S_INGRESS_VER    = v1.3.0
K8S_CERT_MGR_VER   = v1.9.1
K8S_DASHBOARD_URL ?= http://localhost:$(K8S_DASHBOARD_PORT)/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

#####################
# Terraform plugins #
#####################

## Download Terraform plugins.
.tf-init-$(K8S_CLUSTER_NAME): $(TF_CLUSTER_DIR)/.terraform.lock.hcl
$(TF_CLUSTER_DIR)/.terraform.lock.hcl: .mk/.local/bin/terraform
	@$(ECHO) "$(YELLOW)Downloading required Terraform plugins.$(RESET)"
	@$(terraform) init

## Remove Terraform plugins.
.clean-tf-init-$(K8S_CLUSTER_NAME):
	@$(ECHO) "$(YELLOW)Deleting Terraform plugins.$(RESET)"
	@rm -f $(TF_CLUSTER_DIR)/.terraform.lock.hcl
	@rm -rf $(TF_CLUSTER_DIR)/.terraform

################
# Cluster CRUD #
################

## Print the Terraform plan for the Kubernetes cluster.
.tf-plan-k8s-cluster: .tf-init-$(K8S_CLUSTER_NAME)
	@$(terraform) plan

## Build the Kubernetes cluster.
.tf-build-k8s-cluster: .tf-init-$(K8S_CLUSTER_NAME)
	@$(ECHO) "$(YELLOW)Building '$(K8S_CLUSTER_NAME)' cluster.$(RESET)"
	@$(terraform) apply
	@$(make) .k8s-kubeconfig K8S_CLUSTER_NAME=$(K8S_CLUSTER_NAME)
	@$(make) .k8s-ingress-controller K8S_CLUSTER_NAME=$(K8S_CLUSTER_NAME)
	@$(make) .k8s-cert-manager K8S_CLUSTER_NAME=$(K8S_CLUSTER_NAME)
	@# TODO: create environments on the cluster here?

## Destroy the Kubernetes cluster and associated resources.
.tf-destroy-k8s-cluster: .tf-init-$(K8S_CLUSTER_NAME)
	@$(terraform) destroy

##############
# Kubeconfig #
##############

# Generate the kubeconfig for the cluster via Openstack Magnum.
.k8s-kubeconfig:
	@$(ECHO) "$(YELLOW)Generating kubeconfig for '$(K8S_CLUSTER_NAME)' cluster.$(RESET)"
	@mkdir -p $(KUBECONFIG_DIR)
	@rm -f $(KUBECONFIG)
	@openstack coe cluster config --os-cloud=$(OS_CLOUD) $(K8S_CLUSTER_NAME) --dir $(KUBECONFIG_DIR) --force > /dev/null
	@sleep 5
	@mv $(KUBECONFIG) $(KUBECONFIG)-$(K8S_CLUSTER_NAME)
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(K8S_CLUSTER_NAME)
	@$(make) .k8s-kubeconfig-set-token # We need to call this in a sub-make, in order for K8S_TOKEN to be resolved at this point, and not earlier.
	@sleep 5

# Set a token that will allow access to the dashboard using the kubeconfig file.
.k8s-kubeconfig-set-token:
	@$(kubectl) config set-credentials admin --token=$(K8S_TOKEN)

# Switch to the specified cluster's kubeconfig.
.k8s-use-cluster:
	@$(ECHO) "$(YELLOW)Switching to '$(K8S_CLUSTER_NAME)' cluster.$(RESET)"
	@ln -sf config-$(K8S_CLUSTER_NAME) $(KUBECONFIG)

#######################
# Kubernetes services #
#######################

# Install ingress controller
.k8s-ingress-controller:
	@$(ECHO) "$(YELLOW)Installing Ingress Controller for '$(K8S_CLUSTER_NAME)' cluster.$(RESET)"
	@$(kubectl) apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-$(K8S_INGRESS_VER)/deploy/static/provider/cloud/deploy.yaml

# Install certificate manager
.k8s-cert-manager:
	@$(ECHO) "$(YELLOW)Installing Certificate Manager for '$(K8S_CLUSTER_NAME)' cluster.$(RESET)"
	@$(kubectl) apply -f https://github.com/cert-manager/cert-manager/releases/download/$(K8S_CERT_MGR_VER)/cert-manager.yaml

##############################################
# Kubernetes dashboard proxy and credentials #
##############################################

# Print instructions for connecting to the Kubernetes dashboard.
.k8s-info: .k8s-dashboard-url .k8s-auth
.k8s-dashboard-url:
	@$(ECHO) "$(YELLOW)Connect to the dashboard at the following URL:$(RESET)"
	@$(ECHO)
	@$(ECHO) $(K8S_DASHBOARD_URL)
	@$(ECHO)
.k8s-auth:
	@$(ECHO) "$(YELLOW)Use the following kubeconfig file to authenticate to the dashboard:$(RESET)"
	@$(ECHO)
	@$(ECHO) $(realpath $(KUBECONFIG))
	@$(ECHO)
	@$(ECHO) "$(YELLOW)Alternatively, use the following token to authenticate to the dashboard:$(RESET)"
	@$(ECHO)
	@$(ECHO) $(K8S_TOKEN)
	@$(ECHO)
.k8s-proxy:
	@$(ECHO) "$(YELLOW)Starting local kubectl proxy. Use CTRL-C to stop the proxy.$(RESET)"
	@kubectl --kubeconfig=.kube/config-$(K8S_CLUSTER_NAME) proxy --port=$(K8S_DASHBOARD_PORT)

