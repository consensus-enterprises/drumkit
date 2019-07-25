SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

MK_D = $(PROJECT_ROOT)/drumkit/mk.d
MK_D_EXISTS ?= $(shell if [[ -d $(MK_D) ]]; then echo 1; fi)
MK_D_NONEMPTY ?= $(shell if [[ `ls -A $(MK_D)` ]]; then echo 1; fi)

$(MK_D) drumkit/mk.d:
	@mkdir -p $(MK_D)

CONSENSUS_GIT_URL_BASE := https://gitlab.com/consensus.enterprises

# Dynamic submodule management in projects
# ----------------------------------------
#
# For a given project, we want to store the git submodule dependencies in a
# human-readable/maintainable format. We expect a submodules config file to be
# formatted like this (one pair per line, space-separated, git URL's and target
# paths):
#
# path/where/submodule/should/go https://gitlab.com/you/git/repo/url/here
#
# We read these pairs in and turn them into an associative array (hash) called
# whose name is passed to us, using the GMSL set function, so we can then add git submodules as
# needed.  
#
# Calls to the set function have to look like this (make is sensitive about the
# spacing; we canNOT add spaces): 
#
# $(call set,deps,path/where/submodule/should/go,https://gitlab.com/you/git/repo/url/here)

# $1 = config file path
# $2 = name of hash to initialize
# This awk one-liner will read in the config file and return a block of calls
# to the set function that we can then use to initialize our deps hash:
define _get_submodules
  $(shell awk '/^[^\#]/ {OFS=""; print "$$(call set,$(2),",$$1,",",$$2,")"}' $(1))
endef

# Useful for troubleshooting
define _print_submodules
  $(info $(call _get_submodules,$(1),$(2)))
endef

# The (only!) function that should actually be called from outside this file:
define initialize_submodules_hash
  $(eval $(call _get_submodules,$(1),$(2)))
endef


#project/.mk
#project/drumkit/mk.d
#project/roles/myrole/.mk
#project/roles/myrole/drumkit/mk.d
#project/roles/myrole/drumkit/submodules

include $(SELF_DIR)project/*.mk

ifeq ($(MK_D_EXISTS), 1)
  ifeq ($(MK_D_NONEMPTY), 1)
    include $(MK_D)/*.mk
  endif
endif

