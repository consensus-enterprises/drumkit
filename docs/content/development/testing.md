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

These are the tests most likely to break and fail when you push a change, so they should be run locally before pushing to the repo. The CI process (when you push changes to the [drumkit project](https://gitlab.com/consensus.enterprises/drumkit) on gitlab) runs the complete `behat` suite on any branch, not just master. Running the tests locally before pushing changes is a relatively easy way to prevent pipeline failures.

This is not to say that you won't have pipeline failures; it will just catch the ones that break any tests associated with the code you just wrote.

## Testing the output from Drumkit

The ultimate test of Drumkit is that it pushes working code to the (surrounding/containing) project you are working on with it.

Process:
If you are developing Drumkit, per se, you should test and push the project as well as the drumkit code. This ensures that any modifications we make to (for example) `.gitlab-ci.yml` templates produces the correct files in the end.

