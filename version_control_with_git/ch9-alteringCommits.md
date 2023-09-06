# Altering commits

In general, we think about development timelines as either being realistic or clean. The realistic view says that all commits should exist as they are to reflect what has happened on a branch. The clean perspective says that commits can be edited post-fact to make the history look cleaner and linear.

If you have a timeline like this: A -> B -> C -> D. The realistic view says that you should never edit any of the commits. The clean view says that you can edit any of the commits to make the history look like A -> B -> CD.

However, never alter a history that have been shared with others. Only alter histories that are "private". That is, what is published is published.

## Revert commits
Using `git revert` applies the inverse of a commit by introducing a new commit that undoes whatever the original commit did. This is the safest way to undo a commit, as it does not alter the history of the branch. Say that your history looks like: A -> B -> C -> D. Commit B has been found to introduce something unwanted. To introduce the inverse of B, you can do:

```bash
git revert HEAD~2
```
Reverting can introduce a conflict, which we need to resolve. When they are resolved, we can add the changes and commit the revert by doing:

```bash
git add <file(s)>
git revert --continue
git log --pretty --oneline
```

The history will now look like A -> B -> C -> D -> B'. B' is the inverse of B. If you want to revert a merge commit, you need to specify which parent to revert. Say that your history looks like: A -> B -> C -> D -> E. You want to revert the merge commit E. You can do:

```bash
git revert -m 1 HEAD~1
```

## Amend commits
Using `git commit --amend` allows you to alter the last commit. This is useful for minor fixes that should be a part of the last commit. Think like typos, faulty commit messages, forgetting to add a file, etc. Say that your history looks like: A -> B -> C -> D. The D commit introduced a typo in `newfile`. You can fix the typo and amend the commit by doing:

```bash
git show
git show-branch --more=5
# See what is wrong
# Edit the misstake
git diff newfile
# Add and amend newfile
git add newfile
git commit --amend
# See, still only one new commit and an updated commit message
git show-branch --more=6
git log -p HEAD
```

## Reseting commits
Using `git reset` we can change the repository and working directory to any known state specified by a commit. Think about it as rewinding or forwarding history. 

There are three different modes of reset: soft, mixed and hard.
- Soft: Only move the branch pointer to the specified commit. The index and working directory are not changed.
- Mixed: Move the branch pointer and reset the index to the specified commit. The working directory is not changed.
    - This is the default mode.
    - The index reflects the commit we reset to.
    - The working directory reflects their current status.
- Hard: Move the branch pointer, reset the index and reset the working directory to the specified commit.
    - Resets the index and working directory completely.

Say that your history looks like: A -> B -> C -> D. You want to reset the index and files to B. You can do:
    
```bash
git reset --hard HEAD~2
```
The index and working directory is now at B fully.

Say that your history looks like: A -> B -> C -> D. You want to reset the index to B, but keep the changes in C and D in the working directory. You can do:

```bash
git reset --mixed HEAD~2
# Or, due to default mode
git reset HEAD~2
```
The index is now at B, but the working directory is at D.

Say that your history looks like: A -> B -> C -> D. You want to reset the branch pointer to B, but keep the index and working directory at D. You can do:

```bash
git reset --soft HEAD~2
```
The branch pointer is now at B, but the index and working directory is at D.

## Cherry-pick commits
Using `git cherry-pick` we can add to the history of a repository. This is handy when we want to add a commit from one branch to another branch. This is sometimes called "porting" a commit onto a branch. 

Say that there are two branches: main and dev. The history of main looks like: A -> B -> C -> D. The history of dev looks like: A -> B -> C -> D -> E -> F -> G. You want to add the commit E to main. You can do:

```bash
git checkout main
git cherry-pick dev~1
```
The history of main now looks like: A -> B -> C -> D -> E. The commit E is now a part of main.

Note that we are picking a *single commit*. So imagine the above scenario, but we now want to first incorporate G and then F but never E into main. We can do:

```bash
git checkout main
git cherry-pick dev~0
git cherry-pick dev~1
```
The history of main now looks like: A -> B -> C -> D -> G -> F. The commits G and F are now a part of main.

## Reset, revert, and checkout
- If you want to switch to a another branch, use `git checkout` or `git switch`.
- If you want to undo changes in the working directory, use `git checkout`.

If you want to undo changes in general, use `git reset` with `--hard` flag.

If you want to checkout a specific file from the index or another branch, you can use `git checkout` like
    
```bash
# From index
git checkout -- <file> 
# From another branch
git checkout <branch> -- <file>
```

If you want to undo a full commit, use `git revert` as it works on commits and not on files. The benefit of `git revert` is that it does not alter the history of the branch, but build on it.

## Rebasing
Using `git rebase` we can change the sequence of how commits are placed. That is, rebasing a branch using the commits from another branch, we introduce the commits that where not already on it. This is useful when we want to incorporate changes from one branch to another.

Say that you have two branches, main and feature. The commit history of A looks like A -> B -> C -> D. The commit history of feature looks like A -> B -> C -> D -> E -> F -> G. You want to incorporate the changes from feature into main. You can do:

```bash
git checkout main
git rebase feature
```
The history of main now looks like A -> B -> C -> D -> E -> F -> G. The commits E, F and G are now a part of main. This is often called "forward-porting" commits.

When rebasing, there can be conflicts that we need to resolve. When they are resolved by editing the file, we can add the changes and continue the rebase by doing:

```bash
git add <file(s)>
git rebase --continue
```
If we encounter a situation where we want to skip a specific commit, we can do:

```bash
git rebase --skip
```
If we want to abort the rebase, we can do:

```bash
git rebase --abort
```
This will bring the branch back to its original state before the rebasing started.

We can also rebase interactively. Say that you have a history like A -> B -> C -> D -> E -> F -> G. You want to rebase interactively to remove the commit E. You can do:

```bash
git rebase -i HEAD~6
```
This will open an editor with the commits that are to be rebased. Remove the line with the commit E and save the file. The history now looks like A -> B -> C -> D -> F -> G. The commit E is now removed from the history.

Inside the interactive mode, we can pick commits, we can squash commits. Squashing commits is a way to combine commits into one. Say that you have a history like A -> B -> C -> D -> E -> F -> G. You want to rebase interactively to squash the commits E and F into one. You can do:

```bash
git rebase -i HEAD~6
```
This will open an editor with the commits that are to be rebased. Change the line with the commit F to `squash` and save the file. The history now looks like A -> B -> C -> D -> EF -> G. The commits E and F are now squashed into one, because `squash` inside interactive rebase squashes the commit with the one above/preceding it.

## Rebase vs merge
Rebasing and merging are two different ways of incorporating changes from one branch to another. Rebasing is a way to forward-port commits from one branch to another. Merging is a way to combine the histories of two branches.

Rebasing will thus introduce a completely new history. Merging will keep the history of both branches. Rebasing is thus a way to keep the history linear. Merging is a way to keep the history non-linear.

## Multibranch rebasing
When you have branches that branches off themselves, rebasing is not so intuitive. Use it with caution.



