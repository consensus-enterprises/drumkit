BOOTSTRAP_D = drumkit/bootstrap.d
BOOTSTRAP_D_EXISTS ?= $(shell if [[ -d $(BOOTSTRAP_D) ]]; then echo 1; fi)
BOOTSTRAP_D_NONEMPTY ?= $(shell if [[ `ls -A $(BOOTSTRAP_D)` ]]; then echo 1; fi)
DRUMKIT_BOOTSTRAP_SCRIPTS ?= $(shell cd $(MK_DIR); ls -r drumkit/bootstrap.d/*)

$(DRUMKIT_BOOTSTRAP_SCRIPTS):
	@cd $(BOOTSTRAP_D) && ln -s ../../.mk/$@ .

ifeq ($(BOOTSTRAP_D_EXISTS), 1)
  ifeq ($(BOOTSTRAP_D_NONEMPTY), 1)
    include $(BOOTSTRAP_D)/*.mk
  endif
endif

# We need to call a sub-make here, in order to re-bootstrap, since ansible
# requires a special env var.
test-self-bootstrap: ansible-doc
	$(MAKE) test-self-bootstrap-real
test-self-bootstrap-real:
	ansible-doc --help

