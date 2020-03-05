GITLAB_RUNNER_URL=https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
GITLAB_RUNNER=$(BIN_DIR)/gitlab-runner

gitlab-runner:
	@which gitlab-runner || make -s gitlab-runner-real gitlab-runner-config

gitlab-runner-real: docker
	@echo "Downloading gitlab-runner."
	@curl -L --output $(GITLAB_RUNNER) $(GITLAB_RUNNER_URL) 
	@chmod 755 $(GITLAB_RUNNER)

gitlab-runner-config:
	@echo "Configuring gitlab-runner."
	@printf "[[runners]]\n\
		clone_url = $(PROJECT_ROOT)\n\
[[runners.docker]]\n\
		pull_policy = if-not-present\n" > .config.toml

