---
title: Mustache
weight: 30
draft: true
---

**DEPRECATED**: Consider using [`envsubst`](../templating) instead.

We use `mustache` for templating config or other files with a set of values
that aren't known until make execution, e.g. initializing config files for new
project codebases, etc.

We are using the GoLang implementation of mustache because it is available as a
self-contained binary for easy download.  To use it in a project, you need to have installed
mustache by running `make mustache` first. 

If you are using for templating in a Makefile, list it as a dependency so it gets installed before you try to use it, e.g.:

```
config.yml: mustache
	@echo "Initializing config file from environment variables."
	@$(BIN_DIR)/mustache ENV $(FILES_DIR)/my-project-type/config.yml.tmpl > $@
```

For further information on how to use `mustache` itself, see:

  * The [`mustache` command](http://mustache.github.io/mustache.1.html).
  * [`mustache` templating](http://mustache.github.io/mustache.5.html).

