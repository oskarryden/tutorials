# Branches
A git branch allows for a separate path of repository. You can see it as a fork of a repo at a given point in the history.

## Branch names
When a git repo is created, the default for branch name is 'master' or 'main'. It is possible to control this via:

```bash
git init --initial-branch=name
# Or
git init -b name
```

It is also possible to rename a branch via
```bash
git branch -m old-branch-name new-branch-name
```
Branch names cannot contain:
- `\`
- no word can begin with `.` or `..`
- cannot start with `-`
- cannot contain a blankspace
- no git special character or ASCII control characters

## Managing branches
You only work in one branch at a time. To see the current branch, use `git branch`. The current branch is marked with a `*`.
```bash
git branch
```
The current branch decides what your working directory is looking like. If you switch branch, the working directory will change to the state of the branch you switched to.

## Working in branches
All commits apply to a branch and only that branch. A given branch name is always pointing to the latest commit in that branch, which is called the `HEAD` of the branch or its `tip`. 

When you create a new branch, it will point to the same commit as the branch you created it from. This means that the new branch will have the same history as the branch you created it from. 

When you create a new branch, you can also specify a commit to start from. This is done via:
```bash
git branch new-branch-name commit-hash
```

The difference between a `tag` and a `branch` is that a tag is a pointer to a specific commit, while a branch is a pointer to the latest commit in the branch. Hence, `tags` are static, while `branches` are dynamic.

## Creating branches
A branch is created from the current branch and the the latest or specified commit. This is done via:
```bash
git branch new-branch-name
```
The command above creates a new branch, but does not switch to it. To switch to the new branch, use:
```bash
git checkout new-branch-name
```
The two commands above can be combined into one:
```bash
git checkout -b new-branch-name
```
There is nothing that says that a branch must exists forever, or that it must be removed within a short time. It is up to you to decide when to remove a branch. 

To list all branches, use:
```bash
git branch
```
The `*` indicates the current branch. To remove a branch, use:
```bash
git branch -d new-branch-name
```
To remove a branch that has not been merged, use:
```bash
git branch -D branch-name
```
## Viewing branches
To get a informative view of the current branches, you can use:
```bash
# Show all branches
git show-branch -a
# Show all branches and their 5 latest commits
git show-branch -a --more=5
# Show remote branches
git show-branch -r
# Only show from the new-brach-name
git show-branch new-branch-name
```
Create a branch and switch to it:
```bash
git checkout -b new-branch-name
```
Edit a file and commit it:
```bash
echo "\nThis is a new line added from a branch" >> hello.txt
cat hello.txt
git add hello.txt && git commit -m "Added a new line from a branch"
```
Switch back to the main branch:
```bash
git checkout main
cat hello.txt
```
Merge in the changes from the other branch:
```bash
git merge new-branch-name
cat hello.txt
```
Delete the branch:
```bash
git branch -d new-branch-name
```
## Checking out branches
To checkout/swtitch to branch, use:
```bash
git checkout branch-name
```
To go back to the previous branch, use:
```bash
git checkout main
```
Git will not allow you to switch branches if you have uncommitted changes to a file that exists in another branch. You should either commit the changes or stash them.
Try with branch ´bug-fix´:
```bash
git checkout -b bug-fix
echo "This file fixes a bug" >> bug-fix.txt
git add bug-fix.txt
```
Checkout main:
```bash
git checkout main
# No problem, now go back
git checkout bug-fix
# Edit hello.txt
echo "\nThis creates a connection to the bug file" >> hello.txt
# Should not work!
git checkout main
# Diff hello.txt
git diff hello.txt
```
We can now either commit the changes or stash the newly added change. Committing it will make it part of the main branch, while stashing it will make it part of the bug-fix branch.
To stash the changes, use:
```bash
git stash save "Stashing changes"
git checkout main
git checkout bug-fix
git stash apply
git add hello.txt
git commit -m "Added a new line to hello.txt"
cat hello.txt
git checkout main
cat hello.txt
git branch -D bug-fix
```
## Merging changes
Create a new branch and switch to it:
```bash
git checkout -b dev
nano hello.txt
git add hello.txt && git commit -m "Added a new line from dev"
cat hello.txt
# Switch to main
git checkout main
# Missing the new line
cat hello.txt 
# Merge in the changes from dev
git checkout main
git merge dev
cat hello.txt
git branch -D dev
```
## Detached HEAD
When branching, you typically depart from the latest commit. That is, the branch is attached to the HEAD of the index. However, it is possible to checkout a commit directly. This is called a `detached HEAD`. This is done via:
```bash
# Show commits on main
git log --oneline
# Show the 2 commit
git log --oneline -2
# Create a the branch 'detached-HEAD-branch' from the ~2 commit
git checkout -b detached-HEAD-branch af0fb8f
git status
cat hello.txt
```
The `detached-HEAD-branch` is now detached from the main branch. This means that any changes made to the `detached-HEAD-branch` will not be reflected in the main branch. 
```bash
echo "\nThis is a new line added from a detached HEAD" >> hello.txt
cat hello.txt
git add hello.txt && git commit -m "Added a new line from a detached HEAD"
git log --oneline
git checkout main
cat hello.txt
git branch -D detached-HEAD-branch
```


