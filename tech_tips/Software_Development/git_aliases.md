### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)

----------

### [Git Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/git_tips.md)

## My Git Aliases
### Use shell alias gal to see all aliases with comments
> 	alias = ! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /
### Delete branch (force delete)
> 	brd = branch --delete --force
### Checkout
> 	co = checkout
> 	cob = checkout -b
### Commit
> 	cm = commit -m
### Show diffs of cached/added files with HEAD
> 	dc = diff --cached
### Diff showing all conflicted files
> 	dcon = diff --name-only --diff-filter=U
### Show diff of changes for last commit
>         dlc = dc HEAD^
### Show diff of a commit given commit SHA-1
>         dr  = "!f() { git diff "$1"^.."$1"; }; f"
### List last commit with files changed
> 	dl = ll -1
###  List last commit
> 	last = log -1
### Find file names containing argument
>         f = ! git ls-files | grep 
### Find file names containing argument (case insensitive)
>         fi = ! git ls-files | grep -i
### Search entire code base for a string
>         gr = grep -I
### Grep from root folder
>         gra = "!f() { A=$(pwd) && TOPLEVEL=$(git rev-parse --show-toplevel) && cd $TOPLEVEL && git grep --full-name -In $1 | xargs -I{} echo $TOPLEVEL/{} && cd $A; }; f"
### Search entire code base for a string (case insensitive)
>         gri = gr -i
### List with ll (below) for a commit given SHA-1
>         lc  = "!f() { git ll "$1"^.."$1"; }; f"
### List commits with files changed
> 	ll = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat
### List commits with diffs(patch) of files changed
> 	lp = log -p
### Pull/Push
>         pl = pull
>         ph = push
### Push a local branch to remote (origin)
>         phu = push --set-upstream origin
### Status aliases (-s short form)
> 	st = status
> 	sts = status -s
### Git diff stash
### Use shell function _gsd [stash_no:default=0]
### Show Fetch and Push URLS for Repository
> 	rv = remote -v
### [Git Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/git_tips.md)

----------

### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)


