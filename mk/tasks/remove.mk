# Generic deletion method.

.remove: ## [FILES_TO_REMOVE] Delete a list of files.
	@for FILE_TO_REMOVE in $(FILES_TO_REMOVE); do \
            if [ -e "$$FILE_TO_REMOVE" ] || [ -L "$$FILE_TO_REMOVE" ]; then \
                echo -e "$(YELLOW)Removing file: '$$FILE_TO_REMOVE'.$(RESET)"; \
                rm "$$FILE_TO_REMOVE"; \
            else \
                echo -e "$(ORANGE)Not removing non-existent file: '$$FILE_TO_REMOVE'.$(RESET)"; \
            fi \
        done
