# Hooks

Hooks are actions that are launched on different git events. They are basically
signals for different scripts. A hook is repository specific and is usually thought
to be local; hooks are not copied when a repository is cloned. If you need to carry hooks, you will need a copy process of your own.

## Types of hooks
Hooks are typically thought to be *local/client* or *remote/server*, where the former are located on a local machine while the latter are located on a remote server.

There are two categories of hooks:
1. Pre-action hooks: These are launched before an action is performed and is typically used to approve, reject or alter changes.
2. Post-action hooks: These are launched after an action is performed and is typically used to notify or log changes.

Note: Pre-action hooks can be used to abort changes if the hook script has a non-zero exit code.

## Cautious use of hooks
1. Hooks change the default behavior of Git.
2. Hooks can be slow.
3. Hooks with bugs can interfer majorly with your flow.
4. Hooks are not copied when a repository is cloned: which can be a problem if you are using hooks to enforce policies.

## Installing a hook
Hooks are scripts that typically are located in `.git/hooks` directory. They are often named after their place in the process: `pre-commit`, `post-commit`, `pre-rebase`, etc. The hooks are not activated by default, but you can activate them by removing the `.sample` extension from the file name. The scripts must follow Unix standards (executable, header, etc.).

The templated for Hooks are stored in `/usr/share/git-core/templates/hooks`. You can copy the hooks from there to your `.git/hooks` directory.

## Example of hooks
The default hooks are often not very useful. They are not active beacuse of the `.sample` extension in the file name. To activate hooks, remove the extension. Do note that this can be somewhat different between OS. You can remove the example hooks.

### A pre-commit hook
The following hook will check if a file contains the word 'broken' and abort the commit if it does. The hook is located in `.git/hooks/pre-commit`. Create a file called `pre-commit` in the `.git/hooks` directory and add the following code:
```bash
#!/bin/bash
echo "Pre-commit hook activated:" >&2
if git diff --cached | grep '^\+' | grep -q 'broken'; then
        echo "ERROR: Commit introduce violation constraint" >&2
        exit 1
fi;
exit 0
```
Try to commit a file with the word 'broken' in it. The commit will be aborted.
To undo the changes after the have been commited, use `git restore <file>`.

Note that a hook always runs if it exists. If you want to disable a hook, you can rename it to something else or pass the ``--no-verify` flag to the git command.

## Available hooks
A hook can be related to 
1. Commits: `pre-commit`, `prepare-commit-msg`, `commit-msg`, `post-commit` are all available hooks for `git commit`.
    - `pre-commit` is a pre-action hook that is launched before the commit message is edited.
    - `prepare-commit-msg` is a pre-action hook that is launched after the commit message is edited.
    - `commit-msg` is a pre-action hook that is launched after the commit message is edited.
    - `post-commit` is a post-action hook that is launched after the commit message is edited.
2. Merges: `pre-merge-commit`, `prepare-commit-msg`, `commit-msg`, `post-merge` are available hooks for `git merge`.
    - `pre-merge-commit` is a pre-action hook that is launched before the merge commit message is edited.
    - `prepare-commit-msg` is a pre-action hook that is launched after the merge commit message is edited.
    - `commit-msg` is a pre-action hook that is launched after the merge commit message is edited.
    - `post-merge` is a post-action hook that is launched after the merge commit message is edited.
3. Pathches: `pre-applypatch`, `post-applypatch` are available hooks for `git am`.
    - `pre-applypatch` is a pre-action hook that is launched before the patch is applied.
    - `post-applypatch` is a post-action hook that is launched after the patch is applied.
    - `applypatch-msg` is a pre-action hook that is launched after the patch is applied and examines the commit message.
3. Pushes: `pre-push`, `post-push` are available hooks for `git push` to work on the branches or tags. It should be located in the remote repository because it is triggered by a push.
    - `pre-receive` is a pre-action hook that is launched before the push is received.
    - `update` is a pre-action hook that is launched before the push is received, once per reference to be updated. 
    - `post-receive` is a post-action hook that is launched after the push is received. It receives all the references that have been updated.
    - `post-update` is a post-action hook that is launched after the push is received, once per reference to be updated.
4. Other: `pre-rebase`, `post-checkout`, `post-merge`, `pre-auto-gc`.

## Tricks for hooks

### Hooks and variables
Inspect the environment variables to get information about the current state of the repository by including the following in a hook:
```bash
for line in $(printenv); do
    echo -e $[line} '\n'
done
```


