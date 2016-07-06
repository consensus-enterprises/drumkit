DRUSH_DIR        ?= $(LOCAL_DIR)/drush
DRUSH_ALIAS_PATH ?= $(DRUSH_DIR)/$(SITE).alias.drushrc.php
DRUSHRC_HOME     ?= $(shell echo ~/.drushrc.php)
DRUSHRC_DRUMKIT  ?= $(DRUSH_DIR)/.drumkit.drushrc.php

.PHONY: drush-alias-help debug-drush-alias drush-alias

drush-alias-help:
	@echo "make drush-alias"
	@echo "  Generate a Drush alias for the dev site."

debug-drush-alias:
	@echo "DRUSH_DIR: $(DRUSH_DIR)"
	@echo "DRUSH_ALIAS_PATH: $(DRUSH_ALIAS_PATH)"
	@echo "DRUSHRC_DRUMKIT: $(DRUSHRC_DRUMKIT)"
	@echo "DRUSHRC_HOME: $(DRUSHRC_HOME)"

drush-alias: $(DRUSH_ALIAS_PATH)

$(DRUSH_ALIAS_PATH): $(DRUSHRC_DRUMKIT)
	@if [ ! -s $(DRUSH_ALIAS_PATH) ]; then \
	  echo "Creating Drush alias @$(SITE)."; \
    echo "<?php" > $(DRUSH_ALIAS_PATH); \
    echo "  \$$aliases['$(SITE)'] = array('root' => '$(PLATFORM_ROOT)','uri' => '$(SITE_URI)');" >> $(DRUSH_ALIAS_PATH); \
  fi
	@$(drush) site-alias | grep "@$(SITE)" 2>&1 > /dev/null; \
  if [ "$$?" == 0 ]; then \
    echo "The @$(SITE) alias is ready for use."; \
  fi

$(DRUSHRC_DRUMKIT): $(DRUSHRC_HOME) $(DRUSH_DIR)
	@if [ ! -s $(DRUSHRC_DRUMKIT) ]; then \
	  echo "Initializing Drumkit include drushrc file."; \
    echo "<?php" > $(DRUSHRC_DRUMKIT); \
  fi
	@grep "$(DRUSH_DIR)" $(DRUSHRC_DRUMKIT) 2>&1 > /dev/null; \
  if [ "$$?" != 0 ]; then \
    echo "Registering alias search path in Drumkit drushrc file."; \
    echo "  \$$options['alias-path'][] = '$(DRUSH_DIR)';" >> $(DRUSHRC_DRUMKIT); \
  fi
	@grep "$(DRUSHRC_DRUMKIT)" $(DRUSHRC_HOME) 2>&1 > /dev/null; \
  if [ "$$?" != 0 ]; then \
    echo "Registering Drumkit include in main drushrc file."; \
    echo "include_once('$(DRUSHRC_DRUMKIT)');" >> $(DRUSHRC_HOME); \
	fi

$(DRUSHRC_HOME):
	@if [ ! -s $(DRUSHRC_DRUMKIT) ]; then \
    echo "Initializing main drushrc file."; \
    echo "<?php" > $(DRUSHRC_HOME); \
  fi

# vi:syntax=makefile
