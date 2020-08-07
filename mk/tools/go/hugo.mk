hugo_NAME         ?= Hugo
hugo_RELEASE      ?= 0.73.0

ifeq ($(OS),Darwin)
        hugo_OS   ?= macOS
else
        hugo_OS   ?= $(OS)
endif

hugo_DOWNLOAD_URL ?= https://github.com/gohugoio/hugo/releases/download/v$(hugo_RELEASE)/hugo_extended_$(hugo_RELEASE)_$(hugo_OS)-64bit.tar.gz

# vi:syntax=makefile
