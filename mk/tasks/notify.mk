SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

NOTIFY_MESSAGE = Drumkit notification test.

NOTIFY_CI_BRANCH         ?= $(CI_COMMIT_REF_NAME)
NOTIFY_CI_BRANCH_URL     ?= $(NOTIFY_CI_PROJECT_URL)/tree/$(NOTIFY_CI_BRANCH)
NOTIFY_CI_PROJECT        ?= $(CI_PROJECT_NAME)
NOTIFY_CI_PROJECT_URL    ?= $(CI_PROJECT_URL)
NOTIFY_CI_PIPELINE       ?= $(CI_PIPELINE_ID)
NOTIFY_CI_PIPELINE_URL   ?= $(NOTIFY_CI_PROJECT_URL)/pipelines/$(NOTIFY_CI_PIPELINE)
NOTIFY_CI_COMMIT         ?= $(shell git rev-parse --short HEAD)
NOTIFY_CI_COMMIT_URL     ?= $(NOTIFY_CI_PROJECT_URL)/commit/$(NOTIFY_CI_COMMIT_SHA)
NOTIFY_CI_COMMIT_HASH    ?= $(CI_COMMIT_SHA)
NOTIFY_CI_COMMIT_MESSAGE ?= $(shell git log -1 --pretty=%B)

RESULT            ?= 0
NOTIFY_CI_RESULT  ?= $(RESULT)
NOTIFY_CI_SUCCESS ?= ✅  <strong>Success</strong>
NOTIFY_CI_FAILURE ?= ❎  <strong>Failure</strong>
NOTIFY_CI_MESSAGE ?= building <em><a href='$(NOTIFY_CI_BRANCH_URL)'>$(NOTIFY_CI_BRANCH)</a></em> branch of <a href='$(NOTIFY_CI_PROJECT_URL)'>$(NOTIFY_CI_PROJECT)</a>. See <a href='$(NOTIFY_CI_PIPELINE_URL)'>Pipeline \#$(NOTIFY_CI_PIPELINE)</a>.<br />Commit: <a href='$(NOTIFY_CI_COMMIT_URL)'>$(NOTIFY_CI_COMMIT)</a>: $(NOTIFY_CI_COMMIT_MESSAGE)

include $(SELF_DIR)notify/*.mk
