KUBECONFIG_DIR ?= .kube
KUBECONFIG     ?= $(KUBECONFIG_DIR)/config
kubectl        ?= kubectl --kubeconfig=$(KUBECONFIG)
NAMESPACE      ?= $(call lc, $(ENVIRONMENT_NAME))

####################
# Environment CRUD #
####################

.k8s-plan-environment:
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(CLUSTER_NAME)
	$(ECHO) "$(YELLOW)Printing plan for '$(ENVIRONMENT_NAME)' environment on '$(CLUSTER_NAME)' cluster.$(RESET)"
	@$(kubectl) apply -k build/environments/$(ENVIRONMENT_NAME)/ --dry-run=client

.k8s-create-environment:
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(CLUSTER_NAME)
	@$(kubectl) config set-context $(ENVIRONMENT_NAME) --namespace=$(call lc,$(ENVIRONMENT_NAME)) --cluster=$(CLUSTER_NAME) --user=admin
	$(ECHO) "$(YELLOW)Creating '$(ENVIRONMENT_NAME)' environment on '$(CLUSTER_NAME)' cluster.$(RESET)"
	@$(kubectl) apply -k build/environments/$(ENVIRONMENT_NAME)/
	@$(make) .k8s-wait-for-pvcs ENVIRONMENT_NAME=$(ENVIRONMENT_NAME)

.k8s-print-resources:
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(CLUSTER_NAME)
	@$(kubectl) get all -n $(NAMESPACE)
	@$(kubectl) get pvc -n $(NAMESPACE)

.k8s-delete-environment:
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(CLUSTER_NAME)
	$(ECHO) "$(YELLOW)Deleting '$(ENVIRONMENT_NAME)' environment from '$(CLUSTER_NAME)' cluster.$(RESET)"
	@$(kubectl) delete -k build/environments/$(ENVIRONMENT_NAME)/

# Poll the Kubernetes cluster to determine when PVCs are fully provisioned.
.k8s-wait-for-pvcs:
	$(ECHO) "$(YELLOW)Waiting for storage to be fully provisioned in '$(ENVIRONMENT_NAME)' environment.$(RESET)"
	@while [[ `kubectl --kubeconfig=.kube/config get pvc -n $(NAMESPACE)` == *"Pending"* ]]; do sleep 1; if [[ $$(($$SECONDS%5)) == 0 ]]; then echo "Waited $$SECONDS seconds."; fi ; done; echo "Storage provisioning took $$SECONDS seconds."

###############################
# Switch between environments #
###############################

.k8s-use-environment:
	@$(make) .k8s-use-cluster K8S_CLUSTER_NAME=$(CLUSTER_NAME)
	$(ECHO) "$(YELLOW)Setting environment to $(WHITE)$(ENVIRONMENT_NAME)$(RESET) on the $(CLUSTER_NAME) cluster."
	@$(kubectl) config use-context $(ENVIRONMENT_NAME)
