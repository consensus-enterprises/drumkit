# Create (and clean up) backups of Drupal sites.

.PHONY: backup backup-real clean-backups restore restore-validate restore-real

BACKUP_DIR  = $(TMP_DIR)/backups
BACKUP_FILE = $(SITE_URL)-database-$(TIMESTAMP).sql
LATEST_FILE := $(SITE_URL)-database-latest.sql
SNAPSHOT_FILE = $(SITE_URL)-database-snapshot.sql
RESTORE_FILE := $(BACKUP_DIR)/$(LATEST_FILE)

backup:
	@$(MAKE-QUIET) backup-real
	@$(ECHO) "$(YELLOW)Generated backup for $(GREY)$(SITE_URL)$(YELLOW) at $(GREY)$(BACKUP_DIR)/$(BACKUP_FILE)$(YELLOW).$(RESET)"
backup-real:
	mkdir -p $(BACKUP_DIR)
	# Note that we call the Drush command directly here, since we want to avoid any verbose or debug output.
	$(DRUSH_CMD) --uri=$(SITE_URL) sql:dump > $(BACKUP_DIR)/$(BACKUP_FILE)
	rm -f $(BACKUP_DIR)/$(LATEST_FILE)
	cd $(BACKUP_DIR); ln -s $(BACKUP_FILE) $(LATEST_FILE)
clean-backups:
	rm -f $(TMP_DIR)/backups/*
	@$(ECHO) "$(YELLOW)Deleted all backups.$(RESET)"

restore-validate:
ifneq ($(RESTORE_FILE), $(BACKUP_DIR)/$(LATEST_FILE))
	@$(ECHO) "$(RED)$(BOLD)RESTORE_FILE$(RESET)$(RED) is only valid when restoring a single site's database.$(RESET)"
	@exit 1
endif
restore: restore-validate
	@$(MAKE-QUIET) restore-real
restore-real:
	$(DRUSH) sql:query --file $(APP_PATH)$(RESTORE_FILE) $(QUIET)
	@$(ECHO) "$(YELLOW)Restored $(GREY)$(SITE_URL)$(YELLOW) from backup at $(GREY)$(RESTORE_FILE)$(YELLOW).$(RESET)"

snapshot:
	@$(MAKE-QUIET) snapshot-real LATEST_FILE=$(SNAPSHOT_FILE)
snapshot-real:
	@$(MAKE-QUIET) backup-real LATEST_FILE=$(SNAPSHOT_FILE) $(QUIET)
	@$(ECHO) "$(YELLOW)Generated snapshot for $(GREY)$(SITE_URL)$(YELLOW) at $(GREY)$(BACKUP_DIR)/$(SNAPSHOT_FILE)$(YELLOW).$(RESET)"

restore-snapshot:
	@$(MAKE-QUIET) restore-snapshot-real LATEST_FILE=$(SNAPSHOT_FILE)
restore-snapshot-real:
	@$(MAKE-QUIET) restore-real LATEST_FILE=$(SNAPSHOT_FILE) $(QUIET)
	@$(ECHO) "$(YELLOW)Restored $(GREY)$(SITE_URL)$(YELLOW) from snapshot at $(GREY)$(RESTORE_FILE)$(YELLOW).$(RESET)"
