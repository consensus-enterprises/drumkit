DRUMKIT_CONTAINER_REGISTRY_URL ?= registry.gitlab.com/consensus.enterprises/drumkit
CONTAINER_PROJECT_NAME          = drumkit
DRUMKIT_DOCKER_IMAGES           = docker/ubuntu-24.04 docker/base docker/docker docker/ddev docker/gitlab-ddev

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

docker-login:
	docker login registry.gitlab.com

ci-image: packer
	@if [ -z ${CONTAINER_SCRIPT} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_SCRIPT$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_PROJECT_NAME} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_PROJECT_NAME$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_REGISTRY_URL} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_REGISTRY_URL$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_REGISTRY_USERNAME} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_REGISTRY_USERNAME$(YELLOW).$(RESET)"; exit 1; fi
	@if [ -z ${CONTAINER_REGISTRY_PASSWORD} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)CONTAINER_REGISTRY_PASSWORD$(YELLOW).$(RESET)"; exit 1; fi
	@echo "Building packer image for CI: $(CONTAINER_SCRIPT)"
	@echo "Using project name: $(CONTAINER_PROJECT_NAME)"
	@echo "Using container registry: $(DRUMKIT_CONTAINER_REGISTRY_URL)"
	@packer build $(CONTAINER_SCRIPT)

ci-images: $(DRUMKIT_DOCKER_IMAGES)

$(DRUMKIT_DOCKER_IMAGES): packer clone
	@make -s ci-image CONTAINER_SCRIPT=scripts/packer/$@.json CONTAINER_PROJECT_NAME=$(CONTAINER_PROJECT_NAME) CONTAINER_REGISTRY_URL=$(DRUMKIT_CONTAINER_REGISTRY_URL)

ci-local: gitlab-runner
	gitlab-runner exec docker --docker-privileged tests
