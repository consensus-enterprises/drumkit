NTFY_TITLE   ?= ntfy[matrix]
NTFY_MESSAGE ?= $(NOTIFY_MESSAGE)
NTFY_BACKEND ?= matrix
NTFY_URL     ?= https://matrix.org
NTFY_ROOM    ?= INVALID
NTFY_TOKEN   ?= INVALID

ntfy = ntfy --backend '$(NTFY_BACKEND)' --option token '$(NTFY_TOKEN)' --option url '$(NTFY_URL)' --option roomId '$(NTFY_ROOM)'

ntfy-check-room:
ifeq ($(NTFY_ROOM),INVALID)
	$(ECHO) "$(RED)$(BOLD)ERROR:$(RESET) Ensure the NTFY_ROOM environment variable is set."
	@exit 1
endif

ntfy-check-token:
ifeq ($(NTFY_TOKEN),INVALID)
	$(ECHO) "$(RED)$(BOLD)ERROR:$(RESET) Ensure the NTFY_TOKEN environment variable is set."
	@exit 1
endif

ntfy: ntfy-check-room ntfy-check-token
	@$(ntfy) --title "$(NTFY_TITLE)" send "$(NTFY_MESSAGE)"

ntfy-ci:
ifeq ($(NOTIFY_CI_RESULT),0)
	@make -s ntfy-ci-success confirmation="$(GREEN)$(BOLD)✅ SUCCESS$(RESET)"
else
	@make -s ntfy-ci-failure confirmation="$(RED)$(BOLD)❎ FAILURE$(RESET)"
endif

ntfy-ci-success: NTFY_TITLE=$(NOTIFY_CI_SUCCESS)
ntfy-ci-failure: NTFY_TITLE=$(NOTIFY_CI_FAILURE)
ntfy-ci-success ntfy-ci-failure: NTFY_MESSAGE=$(NOTIFY_CI_MESSAGE)
ntfy-ci-success ntfy-ci-failure: ntfy
	$(ECHO) "$(confirmation) notification sent."

