# Diffs
A diff will show a dense summary of differences between two items/files.

## git diff
- `git diff`: difference between the working directory and the index; it shows what the next commit will bring. 
- `git diff --cached <commit>`: difference between the staged/added changes and a commit 
- `git diff <commit>`: difference between the working directory and the commit.
- `git diff <c1> <c2>`: difference between the two commits. 

## Options to git diff
Some helpful options include:
- `-M`: simplifies diffs for renamed files
- `-w` or `--ignore-all-space`: disregards whitespaces
- `--stat`: adds information
- `--color`: colorizes the output
- `--name-only`: only show file names where there are changes
- `--name-status`: show each file with (A)dded, (C)opied, (D)eleted tags.
- `--output=file`: redirect diff to file, instead of stdout.