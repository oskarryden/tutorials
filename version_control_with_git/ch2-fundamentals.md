# Fundamentals

## Create a new repository called my-project and add file
```bash
cd ~/Desktop && mkdir -p my-project && cd my-project
git init -b main
git config --local user.name "oskar"
git config --local user.email "rydenoskar@gmail.com"
git config --list
echo "# My Project" > README.md
git add README.md
git commit -m "Add README.md"
```
## Git Repository
The repository is the core of Git. This is where all of the history of the project is stored. The repository is stored in the same directory as the project itself, in a subdirectory called .git. If you ever need to move a repository to another location, simply copy this directory to the new location. The repository contains all of the project's files and each file's revision history. The repository also contains a number of utility files for Git, such as the index. To inspect:
```bash
cat .git/config
cat .git/HEAD
cat .git/index
git config --list
cd ~/Desktop/my-project/.git && ls -la
ls -R
```

### The objects
The objects are the actual files and directories of the project. The objects are stored in the objects subdirectory of the repository. The objects are stored in a compressed format, and are not accessible except through Git commands. To inspect:
```bash
cd ~/Desktop/my-project/.git/objects && ls -la
```
### The index
The index is a staging area between the working directory and the repository. Files can be added to the index with git add. Files in the index can be committed to the repository with git commit. The index is also sometimes referred to as the staging area. This staging area allow us to, on the one hand, edit files, and on the other hand, commit those changes when we are ready to. To inspect (it is binary):
```bash
cd ~/Desktop/my-project/.git/ && cat index
```
### SHA-1
Git uses SHA-1 hashes to identify each object within the repository. The SHA-1 hash is a 40-character hexadecimal number. The SHA-1 hash is computed based on the contents of the object. This means that if the contents of the object change, the SHA-1 hash will also change. The SHA-1 hash is used to refer to the object in Git commands. To see the SHA-1 hash of a file:
```bash
cd ~/Desktop/my-project/
git hash-object README.md
```

### Git as a content-tracking system
Git's object store is a hashed computation of the content from its objects. It has nothing to do with the name of the file. Internally, Git stores every version of every file.

One interesting fact is that if git sees two identical files with different names in the same repository, it will only use one object to store the contents of the file. This is because the SHA-1 hash of the contents of the file will be the same, and Git will not store the same object twice. To test:

```bash
cd ~/Desktop/my-project/
echo "Hello World" > hello.txt
git add hello.txt && git commit -m "Add hello.txt"
echo "Hello World" > hello2.txt
git add hello2.txt && git commit -m "Add hello2.txt"
git log --oneline
```
To see the SHA-1 hash of the objects:
```bash
if [[ $(git hash-object hello.txt) = $(git hash-object hello2.txt) ]];
    then echo "The same";
    else echo "Not the same";
    fi
```
### the Packfile
Git uses something that is called packfile, to store its objects. The packfile is a compressed version of the objects in the repository. The packfile is stored in the objects/pack subdirectory of the repository. To inspect:
```bash
cd ~/Desktop/my-project/.git/objects/pack
ls -la
```

## Commands
To see commands, do `git help -a` or `git help -g` for a list of guides. To see the manual for a specific command, do `git help <command>`. To see the manual for a specific subcommand, do `git help <command> <subcommand>`. To see the manual for a specific option, do `git help <command> <subcommand> <option>`. To see the manual for a specific concept, do `git help everyday`.

## Inside the .git
```bash
cd ~/Desktop/my-project/
tree .git
```
## Git Objects
```bash
cd ~/Desktop/my-project/
find .git/objects -type f
```
## Blob objects and Hashes
You can view a file based on its hash:
```bash
cd ~/Desktop/my-project/
git cat-file -p $(git hash-object hello.txt) 
```
## tree objects
Git keeps track of file names through a tree object. A tree object contains a list of blobs and other trees. A tree object is similar to a directory in a file system. To see the tree object:
```bash
cd ~/Desktop/my-project/
git ls-files -s
```
Using the command `git write-tree`, you can see that the tree hash always remains the same:
```bash
git write-tree
git write-tree
git write-tree
```

## Commit objects
```bash
cd ~/Desktop/my-project/
git rev-parse HEAD && git write-tree
git write-tree $(git rev-parse HEAD)
echo -n "Commit a file that is a file" | git commit-tree $(git write-tree) -p $(git rev-parse HEAD)
```
Commit objects can vary in its hash. This is because they take into account other tings that the content, such as time, author, and message. To see the commit object:
```bash
cd ~/Desktop/my-project/
git cat-file -p $(echo -n "Commit a file that is a file" | git commit-tree $(git write-tree) -p $(git rev-parse HEAD))
```
A simpler way to show the commit object:
```bash 
cd ~/Desktop/my-project/
git cat-file -p HEAD
```
As commits references tree objects, we can keep them apart despite that the commit hash varies. The hash of the tree object will not vary. To see the tree object:
```bash
cd ~/Desktop/my-project/
git rev-parse HEAD^{tree}
git cat-file -p $(git rev-parse HEAD^{tree})
```
You can also use `git show` to see the commit object:
```bash
cd ~/Desktop/my-project/
git show HEAD
git show HEAD --pretty=raw
git show HEAD --pretty=fuller --no-patch
```
## Tag objects
Git only stores one kind of tag in its object store. This is called the annotated tag, which is an object that contains a message. Lightweight tags are not stored in the object store. They are simply references to a commit. To see the tag object:
```bash
cd ~/Desktop/my-project/
# Create an annotated tag
git tag -a v1.0 -m "Version 1.0"
# Show the tag object using the tag name
git cat-file -p v1.0
# Show the commit object that the tag points to
git rev-parse v1.0
# Show the tag object by using the commit object
git cat-file -p $(git rev-parse v1.0)
```
