behat ?= behat --stop-on-failure --colors

ifdef BEHAT_TAGS
  BEHAT_TAGS_REAL := --tags '$(BEHAT_TAGS)'
else
  BEHAT_TAGS_REAL =
endif

run-behat-ci: behat
	$(behat) $(BEHAT_TAGS_REAL); \
  export RESULT=$$?; \
  make -s ntfy-ci; \
  exit $$RESULT 
