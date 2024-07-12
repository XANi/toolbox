 ### Show path between X and its ancestor

  `git log --ancestry-path ^4332211 x-branch -p`


### Find & replace in history

  `git filter-branch --tree-filter "find . -name '*.go' -exec sed -i -e \
    's/222222222/111111111/g' {} \;"`

### get commit diff by date
  `git diff 'HEAD..HEAD@{4 days ago}'`

### Debug .gitignore rules

  `git check-ignore -v path/to/some/file`

### remove a file from history

  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA" \
    --prune-empty --tag-name-filter cat -- --all

## conditional include config

    [includeIf "gitdir:~/src/client/"]
        path = ~/src/client/.gitconfig

## blame follow author

    git blame -w -C -C -C

* ignore whitespace
* detect lines moved in commit
* or commit that created fiel
* or any commit at all
