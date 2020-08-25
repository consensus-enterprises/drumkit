GITLAB_RUNNER_URL=https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
GITLAB_RUNNER=$(BIN_DIR)/gitlab-runner

gitlab-runner: ## Install and configure local gitlab-runner.
	@which gitlab-runner || make -s gitlab-runner-real gitlab-runner-config

gitlab-runner-real: docker
	@echo "Downloading gitlab-runner."
	@mkdir -p $(BIN_DIR)
	@curl -L --output $(GITLAB_RUNNER) $(GITLAB_RUNNER_URL) 
	@chmod 755 $(GITLAB_RUNNER)
	@which gitlab-runner
	@$(GITLAB_RUNNER) --version

gitlab-runner-config:
	@echo "Configuring gitlab-runner."
	@printf "[[runners]]\n\
		clone_url = $(PROJECT_ROOT)\n\
[[runners.docker]]\n\
		pull_policy = if-not-present\n" > .config.toml

