ifdef BEHAT_CI_TAGS
  BEHAT_TAGS_REAL := --tags '$(BEHAT_CI_TAGS)'
else
  BEHAT_TAGS_REAL =
endif

run-behat-ci: behat
	$(behat) $(BEHAT_TAGS_REAL); \
  export RESULT=$$?; \
  make -s ansible-playbook 2>&1 >/dev/null; \
  source d; make -s matrix-ci; \
  exit $$RESULT
