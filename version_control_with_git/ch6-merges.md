# Merges 
A merge in git is about combining two or more branches into one. Put differntly, it is about unifying two or more commit histories. A merge always happens within *one* repository. So the two branches must exist in the same repo. If a merge results in a conflict, it means that the the histories are not compatible. Git will not be able to merge the branches automatically and forces the developer to resolve the conflict manually.

## Merging branches
A merge is aware of its context and a merge always happens in the *current* branch. That is, you merge things *into* your current position. The command `git merge <branch>` merges the branch `<branch>` into the current branch. The current branch is the branch that is checked out. Further, the current branch is the branch that is active in the working directory. The command `git branch` shows the current branch. The command `git status` shows the current branch and the status of the working directory.

```bash
# Create a new repo
mkdir /tmp/merge-repo && cd /tmp/merge-repo
git init -b main
git status
# Create a new file
vim script.R
git add script.R && git commit -m "Add script"
# Create a new branch
git branch new-feature
git branch
# Switch to the new branch
git checkout new-feature
# Change the file
vim script.R
git add script.R && git commit -m "Change script"
# Switch back to main
git checkout main
git branch -v
# Execute the script
Rscript script.R
# Merge the new-feature branch into main
git merge new-feature
# Execute the script
Rscript script.R
git log --graph
```
A golden rule for merging it to always use clean working directories. That is, have everything added and committed when you start.

### Conflict
A conflict happens when two histories are in conflict. To resolve conflicts, we manually decide between changes and `git add` them.

You can use `git diff` to see the differences between the two branches. The `git diff` command is a general command that can be used to compare any two commits. The `git diff <branch>` command compares the current branch with the branch `<branch>`. You can also use the command `git show-branch` to see the differences between the branches.

Conflicts are marked with headers and foters around the conflicting lines:
- <<< ===
- === >>>

To identify conflicts, you can use `git status` or `git ls-files`.

Another way to inspect conflicts is to compare the the working directory against both `HEAD` and `MERGE_HEAD` using `git diff`. This is the same thing as running `git diff --ours` and `git diff --theirs`, respectively.

Git keeps track of conflicts by saving messages and pointers.
- `.git/MERGE_HEAD` contains the commit that is being merged into the current branch.
- `git/MERGE_MSG` contains the message that was used when the merge was initiated.

By running `git ls-files -u` we can see all files with conflicts.

## Abort or restart a merge
If you want to abort a merge, you can use `git merge --abort`. This will reset the state of the working directory to the state before the merge was initiated. This is the same thing as running `git reset --merge`. As a third option, you can use `git checkout -m` to abort the merge. The fourth option is to use `git reset --hard ORIG_HEAD` to reset the state of the working directory to the state before the merge was initiated.

These options illuminate why it is important to have a clean working directory before you start a merge. If you have uncommitted changes, they will be lost if you abort the merge.

## Merge strategies
Git have several ways of merging branches. They start with identifying a common point in time, called the merge-base. Use `git merge-base` to identify the commit.

### Degenerate merges
There are two degenerate merges: fast-forward and already-up-to-date. These are called degenerate because they do not result in a new commit. 

- already-up-to-date is implemented when the current branch contains all commits from the to-be-merged-in branch. In set notation, this is the same thing as saying that the current branch is a superset of the to-be-merged-in branch.
- fast-forward is the opposite, that is, when the to-be-merged-branch contains all the commits that the current branch contains. In set notation, this is the same thing as saying that the to-be-merged-in branch is a superset of the current branch.

### Normal merges
The normal merges produces a merge commit. Categories of merges are:
- resolve: operates on two branches and does a three-way merge.
- recursive: operates on two branches and does a three-way merge but can manage with more than one merge-base.
- octopus: operates on more than two branches and does the recursive strategy several times.
- merge-ourt

There are several methods within each category and there are even specialized merges (subtree and ours).

## Apply a merge
Git has an algorithm where it decides which strategy is the better one for your merge. You can use `git merge --no-commit --no-ff` to see which strategy git would use. The `--no-commit` option prevents git from committing the merge. The `--no-ff` option prevents git from doing a fast-forward merge.

You can specify a merge strategy by using the `--strategy [-s]` option followed by the name of the strategy. 

Merging is a complex process: read more if needed.
