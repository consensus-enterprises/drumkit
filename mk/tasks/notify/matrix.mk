MATRIX_MESSAGE    ?= "Test message from Drumkit."
MATRIX_CI_SUCCESS ?= "✅  <strong>Success</strong>"
MATRIX_CI_FAILURE ?= "❎  <strong>Failure</strong>"
MATRIX_CI_MESSAGE ?= "building <em><a href='$(CI_PROJECT_URL)/tree/$(CI_COMMIT_REF_NAME)'>$(CI_COMMIT_REF_NAME)</a></em> branch of <a href='$(CI_PROJECT_URL)'>$(CI_PROJECT_NAME)</a>. See <a href='$(CI_PROJECT_URL)/pipelines/$(CI_PIPELINE_ID)'>Pipeline \#$(CI_PIPELINE_ID)</a>.<br />Commit: <a href='$(CI_PROJECT_URL)/commit/$(CI_COMMIT_SHA)'>$$(git rev-parse --short HEAD)</a>: $$(git log -1 --pretty=%B)"

matrix-message:
	@echo $(MATRIX_MESSAGE) | $(MK_DIR)/scripts/mcat.py --stdin

matrix-ci-success:
	@echo $(MATRIX_CI_SUCCESS) $(MATRIX_CI_MESSAGE) | $(MK_DIR)/scripts/mcat.py --stdin

matrix-ci-failure:
	@echo $(MATRIX_CI_FAILURE) $(MATRIX_CI_MESSAGE) | $(MK_DIR)/scripts/mcat.py --stdin

