 ### Show path between X and its ancestor

  `git log --ancestry-path ^4332211 x-branch -p`


### Find & replace in history

  `git filter-branch --tree-filter "find . -name '*.go' -exec sed -i -e \
    's/222222222/111111111/g' {} \;"`
