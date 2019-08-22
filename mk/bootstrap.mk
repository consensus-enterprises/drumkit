BOOTSTRAP_D = drumkit/bootstrap.d
BOOTSTRAP_D_EXISTS ?= $(shell if [[ -d $(BOOTSTRAP_D) ]]; then echo 1; fi)
BOOTSTRAP_D_NONEMPTY ?= $(shell if [[ `ls -A $(BOOTSTRAP_D)` ]]; then echo 1; fi)

ifeq ($(BOOTSTRAP_D_EXISTS), 1)
  ifeq ($(BOOTSTRAP_D_NONEMPTY), 1)
    include $(BOOTSTRAP_D)/*.mk
  endif
endif
