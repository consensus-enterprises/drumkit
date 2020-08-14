ifdef BEHAT_CI_TAGS
  BEHAT_TAGS_REAL := --tags '$(BEHAT_CI_TAGS)'
else
  BEHAT_TAGS_REAL =
endif

ifdef MATRIX_ROOM
  matrix_sub_make = make -s matrix-ci
else
  matrix_sub_make = echo "Skipping matrix client: no MATRIX_ROOM defined."
endif

run-behat-ci: behat
	$(behat) $(BEHAT_TAGS_REAL); \
	export RESULT=$$?; \
	$(matrix_sub_make); \
	exit $$RESULT
