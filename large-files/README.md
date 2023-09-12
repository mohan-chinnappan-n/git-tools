# kalam-largfiles.sh

- Provides a csv view of large files in your OS for given folder and its sub-folders and load into the datatlable viewer

- [Download tool](./kalam-largfiles.sh)

---

## Usage

```
 Usage: kalam-largefiles.sh [OPTIONS]
  -f, --folder       Path to the folder where you want to search for large files
  -s, --min-size     Minimum file size in bytes (positive integer)
  -o, --output-csv   Output CSV filename
  -h, --help         Display this help message
```
---
```
 Usage: example:
 bash kalam-largefiles.sh -f ~/treeprj -s 1000000 -o /tmp/file-size.csv  
```


