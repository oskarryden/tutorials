# Commits
A commit is a status of the repository: a 'snapshot' of its current state. Each commit is linked to its predecessor forming a link over time.

Think about commits and gits method for introducing a change to a single repository. Basically, nothing can change without an explicit commit. Hence, commits should be introduced at "breaking points" for a project/workflow.

A commit is refered to as an "atomic changeset": this means that relative to the previous commit, all changes that have been staged are committed as a whole (all or nothing!).

## Identifying commits
A commit can be identified by:
1. absolute name: the SHA-1 hash of the commit.
2. relative name: the name of the branch or tag that points to the commit or the HEAD pointer.

### Absolute names
- The most precise method
- globally unique

### Refs and symrefs
- A ref is a pointer to a commit.
- A symref is a pointer to a ref.

Refs are stored in:
- `.git/refs/heads/ref`
- `.git/refs/remotes/ref`
- `.git/refs/tags/ref`

where `ref` is the name of the ref (main, etc.).

Inside `.git`, the file `HEAD` is a symref to the current branch. There are various other symrefs in `.git/refs` that point to refs. For example:
- HEAD points to the most recent commit on the current branch
- ORIG_HEAD points to the commit that was before the last change.
- FETCH_HEAD points to the most recent commit that was fetched from a remote repository.
- MERGE_HEAD points to the commit that is being merged into HEAD.

### Special characters
- `^` indicates the parent of a commit
    - `HEAD^1` is the first parent of HEAD
    - `HEAD^2` is the second parent of HEAD
- `~` is used to go further back in generations.
    - `HEAD~1` is the parent of HEAD
    - `HEAD~2` is the grandparent of HEAD
    - `HEAD~3` is the great-grandparent of HEAD

The command `git rev-parse` is used to turn any reference into its SHA-1 hash, aka the absolute identifier for a commit.
- for exameple: `git rev-parse HEAD^2` returns the SHA-1 hash of the second parent of HEAD.

## Commit history
The commit history is the sequence of commits that have been made to a repository. The commit history is a directed acyclic graph (DAG) where each commit is a node and each edge is a parent-child relationship.

The primary command to view the history is to use `git log`. This command has many options to customize the output. For example:
- `git log --oneline` shows the history in a compact format.
- `git log --graph` shows the history as an ASCII graph.
- `git log --stat` shows the history with statistics about the changes in each commit.
- `git log -2` shows the last two commits.
- `git log --since=2.weeks` shows the commits since two weeks ago.
- `git log --pretty=format:"%h %s"` shows the history in a custom format.

To produce a compact graph, use: `git log --graph --oneline --all --decorate`.

To view commits within a range, you can use `start..end` where you exchange start and end for commits. For example: `git log HEAD~4..HEAD~2` shows the commits between the fourth and second last commit.
- note that the start should be the one further back in time.



