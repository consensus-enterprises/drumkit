SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

MK_D = $(PROJECT_ROOT)/drumkit/mk.d
MK_D_EXISTS ?= $(shell if [[ -d $(MK_D) ]]; then echo 1; fi)
MK_D_NONEMPTY ?= $(shell if [[ `ls -A $(MK_D)` ]]; then echo 1; fi)

$(MK_D) drumkit/mk.d:
	@mkdir -p $(MK_D)

CONSENSUS_GIT_URL_BASE := https://gitlab.com/consensus.enterprises

include $(SELF_DIR)project/*.mk

ifeq ($(MK_D_EXISTS), 1)
  ifeq ($(MK_D_NONEMPTY), 1)
    include $(MK_D)/*.mk
  endif
endif

# $1 = config file path
# $2 = name of hash to initialize
define get_submodules
  $(shell awk '/^[^\#]/ {OFS=""; print "$$(call set,$(2),",$$1,",",$$2,")"}' $(1))
endef

# Useful for troubleshooting
define print_submodules
  $(info $(call get_submodules,$(1),$(2)))
endef

define initialize_submodules_hash
  $(eval $(call get_submodules,$(1),$(2)))
endef
