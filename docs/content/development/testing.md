---
title: Drumkit Testing
weight: 40
---

Drumkit is developed using a BDD approach with behat as the testing (suite?)

The tests are located in the `.mk/features` directory.

Any time you make changes to your local instance of `drumkit` you should run the tests at the drumkit level:
`make test-drumkit`.

To run the tests specific to the component you are developing, navigate to `.mk` and run `behat {filename}` for the component. For example, to run the tests for the hugo project, run `behat features/projects/hugo-docs.feature`

These are the tests most likely to break and fail when you push a change, so they should be run locally before pushing to the repo. 

## Gitlab Runner

The CI process (when you push changes to the [drumkit project](https://gitlab.com/consensus.enterprises/drumkit) on gitlab) runs the complete `behat` suite on any branch, not just master. Running the tests locally before pushing changes is a relatively easy way to prevent pipeline failures.

This is not to say that you won't have pipeline failures; it will just catch the ones that break any tests associated with the code you just wrote.

**Important Note on Local Testing**

Drumkit includes the ability to install `gitlab-runner` locally, which will run through the entire build in the `.gitlab-ci.yml` file. 

To run the pipeline on a *project* that you are developing: 
- Install gitlab-runner using `make gitlab-runner`
- Run the section of the `.gitlab-ci.yml` using `gitlab-runner exec docker <test-section>`

Some of the projects have a `ci-local` target (or a `<project>-ci-local` target), but this feature is still in development. This will be updated as the solution is standardized. 

However, there is a limitation in `gitlab-runner`: You cannot navigate into the `.mk` directory and run the pipeline at that level, because it cannot parse the relative paths to the subdirectory, which must be used as the repo for the pipeline. [More info on the gitlab ticket - not ours to fix](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/2054)


## Testing the output from Drumkit

The ultimate test of Drumkit is that it pushes working code to the (surrounding/containing) project you are working on with it.

Process:
If you are developing Drumkit, per se, you should test and push the project as well as the drumkit code. This ensures that any modifications we make to (for example) `.gitlab-ci.yml` templates produces the correct files in the end.

