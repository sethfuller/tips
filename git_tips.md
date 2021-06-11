### [Main Tips Page](https://github.com/sethfuller/tips/blob/main/main_tips.md)

----------

<a name="top"></a>

### Git Tips

#### Undo Last Commit

```bash
	git reset --soft HEAD~1
```

#### Undo to a Specific Commit (Using Commit's Partial or Full SHA-1)

```bash
	git reset 9ef9173
```

#### Undo Add

```bash
	git restore --staged /path/to/file
```

[Top](#top)

#### Add Part of Changes Done

```bash
	git add --patch|-p /path/to/file
```

#### Checkout (Undo) Part of Changes Done, e.g. Debug Statements


```bash
	git checkout|co --patch|-p /path/to/file
```

#### Checkout Only One or More Files on a Branch

```bash
	git checkout|co <BRANCH> -- /path/to/file
```

#### Checkout the Last Branch

```bash
	git checkout|co -
```

[Top](#top)

#### Show all Branches that have been Merged (or Not)


```bash
	git branch --merged
```

```bash
	git branch --no-merged
```

### Delete all Merged Branches
```bash
	git branch --merged | xargs git branch -d
```

### Delete all Merged Branches
	Add --remote to get remote branches

```bash
	git branch --merged | xargs git branch -d
```

### Diff Working Copy With Stash

#### If it is the Latest Stash

```bash
	git diff stage@{0}
```

#### Find an Earlier Stash
List all stashes.

```bash
	git stash list
```

#### Submodule Update
When a submodule has changes that have been committed the parent will show the status
for the submodule as changed. This is because the HEAD commit has changed. To update
the submodule HEAD commit for the parent do this:

```bash
	git submodule update
```

In thw above diff command replace '0' with the stash number.

[Top](#top)

### Merge Commit
After merging a pull request, go to the main page of the repository
(e.g. https://github.comcast.com/ottx/thor-xre-platform) and above the
code listing will be the most recent commit.

> ### [My Git Aliases](/Users/sfulle176/Src/Docs/git_aliases.md)

### Git Tips
> ### [Git Tips from the Pros](https://code.tutsplus.com/tutorials/git-tips-from-the-pros--net-29799)
> ### [13 Git Tips](https://opensource.com/article/18/4/git-tips)
> ### [Git Tips](https://github.com/git-tips/tips#show-helpful-guides-that-come-with-git)

> ### [Git Documentation](https://git-scm.com/doc)

> ### [Github Search](https://docs.github.com/en/github/searching-for-information-on-github/about-searching-on-github)
> ### [Github Searching for Commits](https://docs.github.com/en/github/searching-for-information-on-github/searching-commits)
> ### [Push Branch to Remote Diff. Scenarios](https://devconnected.com/how-to-push-git-branch-to-remote/)

> ### [Git Tips Project](https://github.com/git-tips/tips.git)

> ### [Must Have Git Aliases Article](https://www.durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/)

> ### [Nicola Paolucci Gitconfig](https://github.com/durdn/cfg/blob/master/.gitconfig)

----------

### [Main Tips Page](https://github.com/sethfuller/tips/blob/main/main_tips.md)
