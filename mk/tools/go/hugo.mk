# We can't use MK_OS here because hugo uses inconsistent capitalization in their distribution URLs,
# and we can't use OS because it is not set yet when this file loads:
local_OS          ?= $(shell uname)

hugo_NAME         ?= Hugo
hugo_RELEASE      ?= 0.142.0

ifeq ($(local_OS),Darwin)
        hugo_OS   = darwin-universal
else
# We assume Linux if not Mac.
        hugo_OS   = Linux-64bit
endif

hugo_DOWNLOAD_URL ?= https://github.com/gohugoio/hugo/releases/download/v$(hugo_RELEASE)/hugo_$(hugo_RELEASE)_$(hugo_OS).tar.gz
