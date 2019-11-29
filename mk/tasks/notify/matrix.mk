MATRIX_MESSAGE ?= $(NOTIFY_MESSAGE)
MATRIX_URL     ?= https://matrix.org
MATRIX_ROOM    ?= INVALID
MATRIX_TOKEN   ?= INVALID

matrix = ansible localhost -m matrix -a 'msg_plain="" msg_html="$(MATRIX_MESSAGE)" room_id="$(MATRIX_ROOM)" hs_url="$(MATRIX_URL)" token="$(MATRIX_TOKEN)"'

matrix-check-room:
ifeq ($(MATRIX_ROOM),INVALID)
	$(ECHO) "$(RED)$(BOLD)ERROR:$(RESET) Ensure the MATRIX_ROOM environment variable is set."
	@exit 1
endif

matrix-check-token:
ifeq ($(MATRIX_TOKEN),INVALID)
	$(ECHO) "$(RED)$(BOLD)ERROR:$(RESET) Ensure the MATRIX_TOKEN environment variable is set."
	@exit 1
endif

matrix: matrix-check-room matrix-check-token ansible
	@$(matrix)

matrix-ci:
ifeq ($(NOTIFY_CI_RESULT),0)
	@make -s matrix-ci-success confirmation="$(GREEN)$(BOLD)✅ SUCCESS$(RESET)"
else
	@make -s matrix-ci-failure confirmation="$(RED)$(BOLD)❎ FAILURE$(RESET)"
endif

matrix-ci-success: MATRIX_STATUS=$(NOTIFY_CI_SUCCESS)
matrix-ci-failure: MATRIX_STATUS=$(NOTIFY_CI_FAILURE)
matrix-ci-success matrix-ci-failure: MATRIX_MESSAGE=$(MATRIX_STATUS) $(NOTIFY_CI_MESSAGE)
matrix-ci-success matrix-ci-failure: matrix
	$(ECHO) "$(confirmation) notification sent."

