CONTAINER_REGISTRY_URL ?= registry.gitlab.com/consensus.enterprises/drumkit
CONTAINER_PROJECT_NAME = drumkit

local_ref = $(shell git rev-parse HEAD)
clone_ref = $(shell [ -d .clone ] && (cd .clone && git rev-parse HEAD))

clone: ## Create a local clone of our repo that will be used inside the CI packer image.
ifneq ($(local_ref),$(clone_ref))
	@echo "Cloning a fresh copy of our code in to .clone directory."
	@rm -rf .clone
	@mkdir -p .clone
	@git clone --recursive . .clone
else
	@echo ".clone directory is up to date, skipping reclone."
endif

ci-image: packer
	@if [ -z ${CONTAINER_SCRIPT} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_SCRIPT$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_PROJECT_NAME} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_PROJECT_NAME$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_REGISTRY_URL} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_REGISTRY_URL$(YELLOW).$(RESET)"; exit 1; fi
	@echo "Building packer image for CI: $(CONTAINER_SCRIPT)"
	@packer build $(CONTAINER_SCRIPT)

ci-images: clone
	@echo "Building packer images for CI."
	@echo "Using project name: $(CONTAINER_PROJECT_NAME)"
	@echo "Using container registry: $(CONTAINER_REGISTRY_URL)"
	@for script in `ls scripts/packer/json/*.json`; do make -s ci-image CONTAINER_SCRIPT=$$script CONTAINER_PROJECT_NAME=$(CONTAINER_PROJECT_NAME) CONTAINER_REGISTRY_URL=$(CONTAINER_REGISTRY_URL); done

ci-local: gitlab-runner
	gitlab-runner exec docker tests
