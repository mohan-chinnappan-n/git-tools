# Git Delta

## Install latest plugin

```bash

echo 'y' | sfdx plugins:install sfdx-mohanc-plugins@0.0.354

```

## Finding the delta files for the given:
- git folder
- from commit id
- to commit id


```bash
sfdx kalam:git:diff -p <your-git-folder> -f HEAD~2 -t HEAD > delta.json

```

### Example output
```
Inserted Files: [
  "messages/mdapi.helper.list.json",
  "messages/mdapi.helper.rc.json",
  "messages/mdapi.helper.rc2.json",
  "messages/mdapi.helper.retrieve.json",
]

Modified Files: [
  "package.json"
]

Deleted Files: []
```
