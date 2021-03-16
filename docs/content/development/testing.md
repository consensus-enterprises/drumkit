---
title: Drumkit Testing
weight: 40
---

Drumkit is developed using a BDD approach with behat as the testing (suite?)

The tests are located in the `.mk/features` directory.

To run the tests locally, you need to install behat in the project.

Navigate to the root directory of the project (the one above `.mk`) and run `make init-behat`

You can test the installation by running `behat` (it just checks for correct installation of behat).

To run the tests specific to the component you are developing, navigate to `.mk` and run `behat {filename}` for the component. For example, to run the tests for the hugo project, run `behat features/projects/hugo-docs.feature`

These are the tests most likely to break and fail when you push a change, so they should be run locally before pushing to the repo. The CI process runs the complete behat suite on all branches, so this is the quickest way to prevent pipeline failures.
