VCS_DOMAIN                ?= gitlab.com
VCS_GROUP_NAMESPACE       ?= consensus.enterprises/clients/$(CLIENT_NAME)
CONTAINER_REGISTRY_DOMAIN ?= registry.$(VCS_DOMAIN)
CONTAINER_REGISTRY_URL    ?= $(CONTAINER_REGISTRY_DOMAIN)/$(call lc,$(VCS_GROUP_NAMESPACE))/$(call lc,$(PROJECT_NAME))
DOCKERFILE_DIR            ?= build/images/docker
DOCKERFILE_PATH           ?= $(DOCKERFILE_DIR)/Dockerfile
DOCKER_IMAGE_TAG          ?= latest

.docker-login:
	@docker login $(CONTAINER_REGISTRY_DOMAIN)

.docker-image: .docker-login
	@docker build . -f $(DOCKERFILE_PATH).$(DOCKER_IMAGE_NAME) -t $(CONTAINER_REGISTRY_URL)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) # --no-cache --progress=plain
	@$(make) .docker-push DOCKER_IMAGE_NAME=$(DOCKER_IMAGE_NAME)

.docker-push:
	@docker push $(CONTAINER_REGISTRY_URL)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

####################################################
# Generate token to access private Gitlab registry #
####################################################

.gitlab-pull-secret-prompt:
	@echo "This operation will generate a Kubernetes secret."
	@echo "You will be prompted for a username and a token."
	@echo "These can be generated on Gitlab at:"
	@echo "  https://$(VCS_DOMAIN)/$(VCS_GROUP_NAMESPACE)/$(PROJECT_NAME)/-/settings/access_tokens"
	@echo "Use the following settings:"
	@echo "  - Role: 'developer'"
	@echo "  - Scope: 'read_registry'"
gitlab-pull-secret: .gitlab-pull-secret-prompt ## Generate a secret to allow Kubernetes to pull images from our private Gitlab registry.
	@read -s -p "Gitlab username:" USERNAME; echo;\
         read -s -p "Gitlab token:" TOKEN; echo; echo;\
         echo "Use this token to allow Kubernetes to pull images from our private registry:"; echo -n "  ";\
         echo -n "{\"auths\":{\"$(CONTAINER_REGISTRY_DOMAIN)\":{\"auth\":\"`echo -n "$$USERNAME:$$TOKEN"|base64`\"}}}"|base64
