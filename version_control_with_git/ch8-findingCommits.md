# Finding Commits
This section discuss how to identify certain commits and their associated meta data. 

## Bisect
The `git bisect` command is used to find the commit that we deem introduced something unwanted (good vs. bad). It runs a binary search to find the commit that introduced a problem.

To start, we simply need to give a good commit and a bad commit. Also, make sure to start from a clean working directory or stash changes.

To experiment, go to a repository and run the following command:

```bash
# Initiate
git bisect start
# Where is bad?
git bisect bad
# Where is good?
git bisect good HEAD~4
# Read the log messages
# Tell git if next commit is bad or good
git bisect good

# Git log
git bisect log
# Git visualize
git bisect visualize --pretty=oneline

# Use git bisect replay to "redo" the search
git bisect replay

# The bisect happens on a "detached head" so that there is no branch associated with the bisecting. Do,
git branch

# When done, reset to the original state of branch
git bisect reset
git branch
```

## Blame
The `git blame` command is used to find the commit that last modified a line of a file. It is useful to find out who introduced a bug or who to ask about a certain line of code.

To try it:
```bash
# List all latest commit for lines 20+ in a script
git blame -L 20, cmdstanr/install_cmdstanr.R
# list all commits 
git blame cmdstanr/install_cmdstanr.R
# list all commits with line number
git blame -n cmdstanr/install_cmdstanr.R

# all changes since some time
git blame --since=100.weeks -- cmdstanr/install_cmdstanr.R
```
## Pickaxe
The `git log -S` command is used to find commits that added or removed a string. It is useful to find out when a certain string was added or removed. Do note that this option-command needs to identify a diff, so that if a revision removed and added the same amount of changes, it will not be identified.

```bash
# Find commits that added or removed the string "cmdstanr"
git log -S stan cmdstanr/install_cmdstanr.R
git log -S --pretty=oneline --abbrev-commit cmdstanr/install_cmdstanr.R

# git log -G uses a regular expression instead of a string
git log -G mdsta cmdstanr/install_cmdstanr.R

```




```






