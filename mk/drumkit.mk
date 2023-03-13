MK_D = drumkit/mk.d
BOOTSTRAP_D = drumkit/bootstrap.d
MK_D_EXISTS ?= $(shell if [[ -d $(MK_D) ]]; then echo 1; fi)
MK_D_NONEMPTY ?= $(shell if [[ `ls -A $(MK_D)` ]]; then echo 1; fi)
make := $(MAKE) -s

drumkit $(MK_D) $(BOOTSTRAP_D):
	@mkdir -p $@

d:
	@ln -s .mk/d .

BOOTSTRAP_FILES = $(shell if [[ -d .mk ]];then cd .mk/; fi && ls $(BOOTSTRAP_D)/*)
$(BOOTSTRAP_FILES):
	@ln -s ../../.mk/$@ $@
init-drumkit: d $(MK_D) $(BOOTSTRAP_D) $(BOOTSTRAP_FILES)

clean-drumkit:
	@rm -rf drumkit d

update-drumkit: update-drumkit-prompt
	@if [ $(DRUMKIT_CONFIRM) == 'y' ]; then echo; else echo; echo "Cancelled."; exit 1; fi
	@echo "Updating Drumkit."
	@cd $(MK_DIR) && git pull
	@git add .mk
	@git commit -m"Update Drumkit."
update-drumkit: DRUMKIT_CONFIRM ?= $(shell bash -c 'read -s -p "Proceed? (y/n):" CONFIRM; echo $$CONFIRM')

update-drumkit-prompt: update-drumkit-check
	@echo "You are about to update Drumkit in this project."
	@echo "This will perform the following operations:"
	@echo "  1. Pull the latest changes from Drumkit."
	@echo "  2. Commit the changs to the Drumkit submodule."

update-drumkit-check:
	@if (( $(DRUMKIT_CLEAN) > 0 )); then echo "Drumkit directory has been changed. Cannot proceed."; exit 1; fi
	@if (( $(DRUMKIT_CLEAN_ROOT) > 0 )); then echo "This repository contains staged changes. Please commit them, or unstage (reset) them. Cannot proceed."; exit 1; fi
update-drumkit-check: DRUMKIT_CLEAN ?= $(shell bash -c 'git diff --name-only --exit-code .mk 2>&1 > /dev/null; echo $$?')
update-drumkit-check: DRUMKIT_CLEAN_ROOT ?= $(shell bash -c 'git diff --cached --name-only --exit-code 2>&1 > /dev/null; echo $$?')

# vi:syntax=makefile
