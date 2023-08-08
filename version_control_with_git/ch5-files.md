# File management and the index
All version control systems have to solve the same basic problem: how do you record changes to your files over time in such a way that you can recreate not only a file's current state, but any previous state as well. Git uses an intermediary area called the *index* to solve this problem. The index is also called the *staging directory*. Think about this place a cache.

The index contains prospective changes/modifications of files. Whenever you are using `gid add` you are adding files to the index; this is also called *staging* a modification.

Create a new git repo:
```bash
mkdir index-repo && cd index-repo
git init
# Create a readme
echo "This is a readme" > README.md
# Print the git status of file: returns nothing
git ls-files
# File do exists
ls
git add README.md
# Now we see it:
git ls-files
git commit -m "Add readme"
```

The commands `git diff --staged` and `git diff --cached` show the difference between the index and the last commit. See:

```bash
echo "This is a new file" > newfile.txt
git add newfile.txt
git diff --staged
git commit -m "Add newfile"
echo "This is a modified file" > newfile.txt
git add newfile.txt
git diff --staged
git commit -m "newfile"
```
## Classifying files
Git classifies files into three categories: tracked, ignored and untracked.
- a tracked file exists in the index
- an untracked file does not exist in the index
- an ignored file is a file that is ignored by git through the `.gitignore` file.

```bash
echo "brandnew file" > brandnew.txt
git status
rm brandnew.txt
git status
```

## git add
The `git add` command is what allow you to add files to the staging area. To incorporate the changes you need to commit them. Between creating a file and adding it, the file remains untracked by git.

To view the contents of the index, use `git ls-files --stage`.

It might be hard to understand, but the "add" as in `git add` is about adding a change to the staging directory. That is why, for example, you can add a removal. The removal is a change that you add to the staging directory and latter on commit.

## git commit
All commits need to have a message appended to them. Like: `git commit -m "message"`. 

You can supply the `-a` flag to the `git commit` command to automatically add all tracked files to the staging area. This is a shortcut for `git add -u` followed by `git commit`. That is, `git commit -a`.

## git rm
The `git rm`command is the opposite of `git add`: it removes files from the directory. However, using the git version of `rm` will remove it from the index but no destroy if physically. To do that, you will need to use the classic command `rm`.

```bash
# remove from index and from disk
git rm newfile.txt
if [[ $(git ls-files) == $(ls) ]]; then
    echo "Indentical output"; fi
# Add new file
echo "This is a new file" > newfile.txt
git add newfile.txt && git commit -m "Add newfile"
# Remove from index but not from disk
git rm --cached newfile.txt
if [[ $(git ls-files) == $(ls) ]]; then
    echo "Indentical output"; else
    echo "Different output";
fi;
```

## git mv
The `git mv` command is a shortcut for `git rm` followed by `git add`. It is used to rename files.

```bash
git mv newfile.txt newfile2.txt
git status
git commit -m "Rename newfile.txt to newfile2.txt"
git status
```

If you want to track the newly named file you can use `git log --follow newfile2.txt`.

## .gitignore
The `.gitignore` file is used to tell git which files to ignore. It is a plain text file. You can use wildcards to ignore files. For example, to ignore all files with the extension `.log` you can use `*.log`. To ignore all files in a directory, you can use `dirname/*`. To ignore all files in a directory and its subdirectories, you can use `dirname/**`.

The file is read in order: so that if you first include and then exlude, the file is excluded. You can also use the `!` to negate a pattern. For example, to ignore all files in a directory except for those with the extension `.log` you can use `dirname/*` and then `!*.log`.

A classic example if to start of by excluding everything by putting `*` in the first line and then including the files you want to track.

The `.gitignore` file cascades into subfolders. But you can have multiple ignore files, which then takes precedence over the parent ignore file.
