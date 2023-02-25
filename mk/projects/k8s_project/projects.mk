BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)

.k8s-init-branch-environment:
	$(ECHO) "Setting up an environment for branch $(BRANCH_NAME)."
	@$(make) init-k8s-environment \
            K8S_ENVIRONMENT_NAME=$(BRANCH_NAME)
	@$(make) init-k8s-drupal-app \
            K8S_ENVIRONMENT_NAME=$(BRANCH_NAME)

.new-branch-environment-intro:
	$(ECHO) "You are about to create a new branch environment for: '$(BRANCH_NAME)'."

.new-branch-environment: .new-branch-environment-intro
.new-branch-environment: .confirm-proceed
.new-branch-environment: .k8s-init-branch-environment
.new-branch-environment: # Create a new environment for the current branch.
	$(ECHO) "$(WHITE)Next step, run: make $(BRANCH_NAME)-create-environment $(RESET)"
