SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

NOTIFY_MESSAGE = Drumkit notification test.

NOTIFY_CI_BRANCH       ?= $(CI_COMMIT_REF_NAME)
NOTIFY_CI_BRANCH_URL   ?= $(CI_PROJECT_URL)/tree/$(CI_COMMIT_REF_NAME)
NOTIFY_CI_COMMIT       ?= $(CI_COMMIT_SHORT_SHA)
NOTIFY_CI_COMMIT_URL   ?= $(CI_PROJECT_URL)/commit/$(CI_COMMIT_SHA)
NOTIFY_CI_COMMIT_TITLE ?= $(CI_COMMIT_TITLE)
NOTIFY_CI_JOB          ?= $(CI_JOB_NAME)
NOTIFY_CI_JOB_URL      ?= $(CI_JOB_URL)
NOTIFY_CI_PIPELINE     ?= $(CI_PIPELINE_ID)
NOTIFY_CI_PIPELINE_URL ?= $(CI_PIPELINE_URL)
NOTIFY_CI_PROJECT      ?= $(CI_PROJECT_NAME)
NOTIFY_CI_PROJECT_URL  ?= $(CI_PROJECT_URL)

RESULT            ?= 0
NOTIFY_CI_RESULT  ?= $(RESULT)
NOTIFY_CI_SUCCESS ?= <strong>&check; Success</strong>
NOTIFY_CI_FAILURE ?= <strong>&\#128473; Failure</strong>
NOTIFY_CI_MESSAGE ?= running <a href='$(NOTIFY_CI_JOB_URL)'>$(NOTIFY_CI_JOB)</a> job on <em><a href='$(NOTIFY_CI_BRANCH_URL)'>$(NOTIFY_CI_BRANCH)</a></em> branch of <a href='$(NOTIFY_CI_PROJECT_URL)'>$(NOTIFY_CI_PROJECT)</a>. Pipeline <a href='$(NOTIFY_CI_PIPELINE_URL)'>\#$(NOTIFY_CI_PIPELINE)</a>.<br />Commit: <a href='$(NOTIFY_CI_COMMIT_URL)'>$(NOTIFY_CI_COMMIT)</a>: $(NOTIFY_CI_COMMIT_TITLE)

include $(SELF_DIR)notify/*.mk
