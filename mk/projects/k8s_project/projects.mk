BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)

.k8s-init-branch-environment:
	$(ECHO) "Setting up an environment for branch $(BRANCH_NAME)."
	@$(make) init-k8s-environment \
            K8S_ENVIRONMENT_NAME=$(BRANCH_NAME)
	@$(make) init-k8s-drupal-app \
            K8S_DRUPAL_APP_IMAGE_TAG=$(BRANCH_NAME) \
            K8S_ENVIRONMENT_NAME=$(BRANCH_NAME)

.new-branch-environment-intro:
	$(ECHO) "You are about to create a new branch environment for: '$(BRANCH_NAME)'."

.new-branch-environment: .new-branch-environment-intro
.new-branch-environment: .confirm-proceed
.new-branch-environment: .k8s-init-branch-environment
.new-branch-environment: # Create a new environment for the current branch.
	$(ECHO) "$(WHITE)Next step, run: make $(BRANCH_NAME)-create-environment $(RESET)"

.refresh-branch-environment-intro:
	$(ECHO) "You are about to update the '$(BRANCH_NAME)' environment with the latest changes in the branch."

.refresh-branch-environment: .refresh-branch-environment-intro
.refresh-branch-environment: .confirm-proceed
.refresh-branch-environment: # Update the environment for the current branch with the latest changes.
	#@$(make) build-branch-image CONFIRM=y
	$(make) .re-create \
            FILENAME=build/app/$(BRANCH_NAME)/component-drupal.patch.yaml \
            K8S_DRUPAL_APP_IMAGE_TAG=$(BRANCH_NAME) \
            K8S_ENVIRONMENT_NAME=$(BRANCH_NAME)

.re-create:
	rm $(FILENAME)
	$(make) $(FILENAME)

.build-branch-image-intro:
	$(ECHO) "You are about to update the Docker image for the '$(BRANCH_NAME)' branch."

.build-branch-image: .build-branch-image-intro
.build-branch-image: .confirm-proceed
.build-branch-image: ## Build a test Drupal Docker image using the current branch.
	@DOCKER_IMAGE_TAG=$(BRANCH_NAME) $(make) docker-image-drupal
