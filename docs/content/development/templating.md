---
title: Templating
weight: 30
---

We use `envsubst` for templating config or other files with a set of values
that aren't known until `make` execution, e.g. initializing config files for
new project codebases, etc.

To use templating in a Makefile, call `envsubst` like so:

```makefile
config.yml:
	@echo "Initializing config file from environment variables."
	@envsubst < $(FILES_DIR)/my-project-type/config.yml.tmpl > $@
```

In a template reference variables in typical shell fashion (eg. `${FOO}`).
Note that we highly recommend using braces, as they are safer and more
reliable. For the example above, the template file (`files/config.yml.tmpl`)
might look like:
```yaml
---
settings:
  foo: ${FOO}
```

For further information on how to use `envsubst` itself, see:

* [`envsubst`](https://linux.die.net/man/1/envsubst)
* Run `man envsubst` locally

