#!/bin/bash

## Description: Run Behat inside the web container.
## Usage: behat [flags] [args]
## Example: "ddev behat --tags=wip"

bin/behat --colors --strict --stop-on-failure $@
