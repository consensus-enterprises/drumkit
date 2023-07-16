# Create (and clean up) backups of Drupal sites.

.PHONY: backup backup-real latest-symlink clean-backups restore restore-validate restore-real snapshot snapshot-real restore-snapshot restore-snapshot-real ls-snaps snapshot-list rm-snap snapshot-remove rm-all-snaps remove-all-snapshots

SNAP          ?= snapshot
BACKUP_DIR     = $(TMP_DIR)/backups
BACKUP_FILE    = $(SITE_URL)-database-$(TIMESTAMP).sql
LATEST_DEFAULT = $(SITE_URL)-database-latest.sql
LATEST_FILE   := $(LATEST_DEFAULT)
SNAPSHOT_FILE  = $(SITE_URL)-snapshot-$(SNAP).sql
RESTORE_FILE  := $(BACKUP_DIR)/$(LATEST_FILE)

backup: ## Backup a timestampped database dump of the local site instance.
	@$(MAKE-QUIET) backup-real
	$(ECHO) "$(YELLOW)Generated backup for $(GREY)$(SITE_URL)$(YELLOW) at $(GREY)$(BACKUP_DIR)/$(BACKUP_FILE)$(YELLOW).$(RESET)"
backup-real:
	mkdir -p $(BACKUP_DIR)
	# Note that we call the Drush command directly here, since we want to avoid any verbose or debug output.
	$(DRUSH_CMD) --uri=$(SITE_URL) sql:dump > $(BACKUP_DIR)/$(BACKUP_FILE)
	@$(MAKE-QUIET) latest-symlink TIMESTAMP=$(TIMESTAMP)
latest-symlink:
	rm -f $(BACKUP_DIR)/$(LATEST_FILE)
	cd $(BACKUP_DIR); ln -s $(BACKUP_FILE) $(LATEST_FILE)
clean-backups:
	rm -f $(TMP_DIR)/backups/*
	$(ECHO) "$(YELLOW)Deleted all backups.$(RESET)"

restore-validate:
ifneq ($(RESTORE_FILE), $(BACKUP_DIR)/$(LATEST_FILE))
	$(ECHO) "$(RED)$(BOLD)RESTORE_FILE$(RESET)$(RED) is only valid when restoring a single site's database.$(RESET)"
	@exit 1
endif
restore: restore-validate ## Restore a database dump to the local site instance.
	@$(MAKE-QUIET) restore-real
restore-real:
	$(DDEV) db-import $(RESTORE_FILE) $(QUIET)
	$(ECHO) "$(YELLOW)Restored $(GREY)$(SITE_URL)$(YELLOW) from backup at $(GREY)$(RESTORE_FILE)$(YELLOW).$(RESET)"

snapshot: ## Take a snapshot of the database for easy restore. Optionally, name the snapshot w/ 'SNAP=<name>'.
	@$(MAKE-QUIET) snapshot-real LATEST_FILE=$(SNAPSHOT_FILE)
snapshot-real:
	@$(MAKE-QUIET) backup-real LATEST_FILE=$(SNAPSHOT_FILE)
ifneq ($(SNAPSHOT_FILE), $(LATEST_DEFAULT))
	@$(MAKE-QUIET) latest-symlink LATEST_FILE=$(LATEST_DEFAULT) TIMESTAMP=$(TIMESTAMP)
endif
	$(ECHO) "$(YELLOW)Generated snapshot for $(GREY)$(SITE_URL)$(YELLOW) at $(GREY)$(BACKUP_DIR)/$(SNAPSHOT_FILE)$(YELLOW).$(RESET)"

restore-snapshot: ## Restore the latest snapshot database dump into the local site instance. Optionally, restore a named snapshot w/ 'SNAP=<name>'.
	@$(MAKE-QUIET) restore-snapshot-real LATEST_FILE=$(SNAPSHOT_FILE)
restore-snapshot-real:
	@$(MAKE-QUIET) restore-real LATEST_FILE=$(SNAPSHOT_FILE) $(QUIET)
	$(ECHO) "$(YELLOW)Restored $(GREY)$(SITE_URL)$(YELLOW) from snapshot at $(GREY)$(RESTORE_FILE)$(YELLOW).$(RESET)"

ls-snaps: snapshot-list
snapshot-list: ## Show the named snapshots available. (alias: ls-snaps)
	@find $(BACKUP_DIR)/$(SITE_URL)-snapshot-*.sql -exec bash -c "stat --print=%y {} | date \"+%Y-%m-%d %T\" -f - | tr '\n' '\t'" \; -exec bash -c "basename {} | sed 's!$(SITE_URL)-snapshot-\(.*\).sql!\1!'" \;

rm-snap: snapshot-remove
snapshot-remove: ## Remove a named snapshot. (alias: rm-snap)
	rm $(BACKUP_DIR)/$(SNAPSHOT_FILE)

rm-all-snaps: remove-snapshots
remove-all-snapshots: ## Remove ALL named snapshots. (alias: rm-all-snaps)
	@find $(BACKUP_DIR)/$(SITE_URL)-snapshot-*.sql | xargs rm
