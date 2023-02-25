CONFIRM := N

.confirm-proceed:
	@if [ $(CONFIRM) == 'y' ]; then \
            echo -e "CONFIRM variable set. Proceeding without confirmation prompt." ; \
        else \
            echo -e -n "Proceed? [y/N] "; \
            read ans; \
            [ $${ans:-N} = y ] ; \
        fi
