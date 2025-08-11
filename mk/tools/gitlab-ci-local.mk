local_OS   ?= $(shell uname)
ifeq ($(local_OS),Darwin)
  URL_OS   ?= macos
else
  URL_OS   ?= linux
endif

GITLAB_CI_LOCAL_VERSION ?= 4.61.0
GITLAB_CI_LOCAL_URL=https://github.com/firecow/gitlab-ci-local/releases/download/$(GITLAB_CI_LOCAL_VERSION)/$(URL_OS).gz
GITLAB_CI_LOCAL_GZ=$(SRC_DIR)/gitlab-ci-local.gz
GITLAB_CI_LOCAL=$(BIN_DIR)/gitlab-ci-local
GITLAB_CI_LOCAL_CONFIG=.gitlab-ci-local-env

gitlab-ci-local: docker $(GITLAB_CI_LOCAL_GZ) $(GITLAB_CI_LOCAL) $(GITLAB_CI_LOCAL_CONFIG) ## Install and configure gitlab-ci-local.
	$(ECHO) "Checking that gitlab-ci-local is in PATH."
	@which gitlab-ci-local
	@$(GITLAB_CI_LOCAL) --version

$(GITLAB_CI_LOCAL_GZ): $(SRC_DIR)
	$(ECHO) "Downloading gitlab-ci-local from $(GITLAB_CI_LOCAL_URL)"
	@mkdir -p $(BIN_DIR)
	@curl -L --output $(GITLAB_CI_LOCAL_GZ) $(GITLAB_CI_LOCAL_URL)

$(GITLAB_CI_LOCAL): $(BIN_DIR)
	$(ECHO) "Unzipping gitlab-ci-local."
	@gzip -dc $(GITLAB_CI_LOCAL_GZ) > $(GITLAB_CI_LOCAL)
	@echo "Making gitlab-ci-local executable."
	@chmod 755 $(GITLAB_CI_LOCAL)

$(GITLAB_CI_LOCAL_CONFIG):
	cp $(FILES_DIR)/gitlab-ci-local/gitlab-ci-local-env $(PROJECT_ROOT)/$@

clean-gitlab-ci-local:
	rm $(GITLAB_CI_LOCAL_GZ)
	rm $(GITLAB_CI_LOCAL)
	rm $(GITLAB_CI_LOCAL_CONFIG)
