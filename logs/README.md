# kalam-gitlogs.sh

- Provides a csv view of git logs in a git folder and loads that csv to datatlable viewer

[Download tool](./kalam-gitlogs.sh)

## Usage
```
Usage: bash kalam-gitlogs.sh [OPTIONS]

  -g, --gitFolder  Path to the Git repository folder
  -d, --fromDate   Filter commits from the specified date (YYYY-MM-DD)
  -o, --outputCsv  Specify the output CSV file
  --help           Display this help message
```
## Usage: example:

```bash

bash kalam-gitlogs.sh -g <git_folder> -d 2023-01-01 -o /tmp/gitlogs.csv

```
