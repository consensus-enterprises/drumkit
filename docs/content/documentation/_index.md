---
title: Documentation Contributions
weight: 100
draft: true

---

The documentation site you are currently looking at is generated using a Hugo site embedded in the drumkit project in the `docs` folder.




We maintain the Drumkit documentation site using
[Hugo](http://www.gohugo.org/). To get started contributing to this project,
fork it on Gitlab. Then install Hugo and clone this repo:

```console
$ git clone --recursive https://gitlab.com/consensus.enterprises/drumkit.git
$ cd drumkit
$ git remote add sandbox https://gitlab.com/<username>/drumkit.git
$ make hugo  # this should install Hugo
$ hugo serve
```

Your local Drumkit docs site should now be available for browsing:
[http://127.0.0.1:8000/](http://localhost:1313/). When you find a typo, an
error, unclear or missing explanations or instructions, hit ctrl-c, to stop the
server, and start editing. Find the page you’d like to edit; everything is in
the `docs/content/` directory. Make your changes, commit and push them, and start a pull
request:

```console
$ git checkout -b fix_typo
$ vim docs/content/_index.md            # Add/edit/remove whatever you see fit. Be bold!
$ hugo serve                            # Go check your changes. We’ll wait...
$ git diff                              # Make sure there aren’t any unintended changes.
diff --git a/docs/content/_index.md b/docs/content/_index.md
...
$ git commit -am”Fixed typo.”           # Useful commit message are a good habit.
$ git push sandbox fix_typo
```

Visit your fork on Gitlab and start a Pull Request.
