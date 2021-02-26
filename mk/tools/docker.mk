local_OS          ?= $(shell uname)
ifeq ($(local_OS),Darwin)
    hugo_OS   ?= macOS
else
    hugo_OS   ?= $(local_OS)
endif

docker:
	@echo "Ensuring Docker is installed."
ifeq ($(local_OS),Darwin)
	@which docker > /dev/null || echo "Docker is not intalled. To use Docker with Lando on macOS, check the lando intsallation instructions."
else
	@which docker > /dev/null || (curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm get-docker.sh)
	@echo "Ensuring $(USER) is in docker group."
	@groups|grep docker > /dev/null || sudo usermod -aG docker $(USER)
endif

