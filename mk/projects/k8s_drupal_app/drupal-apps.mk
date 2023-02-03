#############################
# Deploy/delete application #
#############################

.k8s-plan-app:
	$(ECHO) "$(YELLOW)Printing plan for deploying app to '$(ENVIRONMENT_NAME)' environment.$(RESET)"
	@$(make) .k8s-use-environment ENVIRONMENT_NAME=$(ENVIRONMENT_NAME) CLUSTER_NAME=$(CLUSTER_NAME)
	@$(kubectl) apply -k build/app/$(ENVIRONMENT_NAME)/ --dry-run=client

.k8s-deploy-app:
	$(ECHO) "$(YELLOW)Deploying app to '$(ENVIRONMENT_NAME)'.$(RESET)"
	@$(make) .k8s-use-environment ENVIRONMENT_NAME=$(ENVIRONMENT_NAME) CLUSTER_NAME=$(CLUSTER_NAME)
	@$(kubectl) apply -k build/app/$(ENVIRONMENT_NAME)/

.k8s-delete-app:
	$(ECHO) "$(YELLOW)Deleting app from '$(ENVIRONMENT_NAME)'.$(RESET)"
	@$(make) .k8s-use-environment ENVIRONMENT_NAME=$(ENVIRONMENT_NAME) CLUSTER_NAME=$(CLUSTER_NAME)
	@$(kubectl) delete -k build/app/$(ENVIRONMENT_NAME)/
