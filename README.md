# Git Delta

## Install latest plugin

```bash

echo 'y' | sfdx plugins:install sfdx-mohanc-plugins@0.0.355

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

## Git Merge


```

sfdx kalam:git:merge -s 'develop' -d main

```

## Doc
```
Merge git branches

USAGE
  $ sfdx kalam git merge [-s <string>] [-d <string>] [--json] [--loglevel
    trace|debug|info|warn|error|fatal|TRACE|DEBUG|INFO|WARN|ERROR|FATAL]

FLAGS
  -d, --destinationbranch=<value>                                                   Destination Branch
  -s, --sourcebranch=<value>                                                        Source Branch
  --json                                                                            format output as json
  --loglevel=(trace|debug|info|warn|error|fatal|TRACE|DEBUG|INFO|WARN|ERROR|FATAL)  [default: warn] logging level for this command invocation

DESCRIPTION
  Merge git branches

EXAMPLES
      sfdx kalam:git:merge -s <sourceBranch> -d <destinationBranch> 


```
## Sample Session
```
~/git-merge-tool  (git)-[main]- >git branch develop
~/git-merge-tool  (git)-[main]- >git checkout develop
Switched to branch 'develop'
~/git-merge-tool  (git)-[develop]- >ls
merge.js		node_modules		notes.txt		package-lock.json	package.json

~/git-merge-tool  (git)-[develop]- >vi notes.txt 
~/git-merge-tool  (git)-[develop]- >git add -A
~/git-merge-tool  (git)-[develop]- >git commit -m 'notes updated'
[develop 97d4666] notes updated
 1 file changed, 1 insertion(+)


~/git-merge-tool  (git)-[develop]- >git checkout main
Switched to branch 'main'
~/git-merge-tool  (git)-[main]- >cat notes.txt 
This is the time for all good men to go for the aid of the country
All truely great things are simple
~/git-merge-tool  (git)-[main]- >sfdx kalam:git:merge -s 'develop' -d main
===== Command to run: git merge develop -m "Merge develop into main" =====
Merge successful: develop into main
~/git-merge-tool  (git)-[main]- >cat notes.txt

This is the time for all good men to go for the aid of the country
All truely great things are simple
Keep the world green!

```
