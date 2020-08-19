# We can't use MK_OS here because we need specific capitalization in the URLs we craft below,
# and we can't use OS because it is not set yet when this file loads:
local_OS          ?= $(shell uname)

hugo_NAME         ?= Hugo
hugo_RELEASE      ?= 0.74.3

ifeq ($(local_OS),Darwin)
        hugo_OS   ?= macOS
else
        hugo_OS   ?= $(local_OS)
endif

hugo_DOWNLOAD_URL ?= https://github.com/gohugoio/hugo/releases/download/v$(hugo_RELEASE)/hugo_extended_$(hugo_RELEASE)_$(hugo_OS)-64bit.tar.gz

# vi:syntax=makefile
