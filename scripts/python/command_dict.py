
commands = {
    'git': {
        'undo': [
            {
                'description': 'Undo Last Commit Before Being Pushed',
                'command': 'git reset --soft HEAD~1',
            },
            {
                'description': 'Undo a Specific Commit Before Being Pushed',
                'command': 'git reset --soft <commit-hash>',
            },
            {
                'description': 'Undo Pushed Commit',
                'extra': 'This only reverts the specific commit',
                'command': 'git revert <commit-hash>',
            },
            {
                'description': 'Undo Range of Pushed Commits',
                'extra': 'This reverts all commits from oldest to newest',
                'command': 'git revert <oldest-commit-hash>..<newest-commit-hash>',
            },
            {
                'description': 'Undo Add',
                'command': 'git restore --staged path/to/file',
            },

        ],
        'checkout': [
            {
                'description': 'Checkout Only One or More Files on a Branch',
                'extra': '',
                'command': 'git checkout <BRANCH> -- path/to/file',
            },
            {
                'description': 'Checkout the Last Branch Used',
                'extra': '',
                'command': 'git checkout -',
            },
            {
                'description': 'Fix Detached Head',
                'extra': '',
                'command': 'git checkout <branch>',
            },
        ],
        'branch': [
            {
                'description': 'Show all Branches that have been Merged',
                'command': 'git branch --merged',
            },
            {
                'description': 'Show all Branches that have Not been Merged',
                'command': 'git branch --no-merged',
            },
            {
                'description': 'Delete all Merged Branches',
                'extra': 'Add --remote to Delete Remote Branches',
                'command': 'git branch --merged | xargs git branch -d',
            },
            {
                'description': '',
                'command': '',
            },
        ],
        'diff': [
            {
                'description': 'Diff Files Added With "git add"',
                'command': 'git diff --cached',
            },
            {
                'description': 'Diff Files With Stash Number <number>',
                'command': 'git diff stage@{<number>}',
            },
        ],
        'stash': [
            {
                'description': 'List All Stashes',
                'command': 'git stash last',
            },
            {
                'description': 'Stash Current Changes',
                'command': 'git stash',
            },
        ],
    },
    'dummy': {
        'category': [
            {
                'description': '',
                'command': '',
            },
            {
                'description': '',
                'command': '',
            },
        ],
    },
    
}
