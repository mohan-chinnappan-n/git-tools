#!/bin/bash

# ----------------------------------------------------
# kalam-largefiles.sh
# author: mchinnappan
# provides a csv view of large files in your OS for given folder and its sub-folders
#   and load into the datatlable viewer
# _______________________
# Usage: kalam-largefiles.sh [OPTIONS]
#  -f, --folder       Path to the folder where you want to search for large files
#  -s, --min-size     Minimum file size in bytes (positive integer)
#  -o, --output-csv   Output CSV filename
#  -h, --help         Display this help message
# _______________________
# Usage: example:
# bash kalam-largefiles.sh -f ~/treeprj -s 1000000 -o /tmp/file-size.csv  
# ----------------------------------------------------
#
# Function to display help information
display_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "  -f, --folder       Path to the folder where you want to search for large files"
  echo "  -s, --min-size     Minimum file size in bytes (positive integer)"
  echo "  -o, --output-csv   Output CSV filename"
  echo "  -h, --help         Display this help message"
}

# Copy CSV content to clipboard based on OS type
copy_to_clipboard() {
  local csv_file="$1"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    cat "$csv_file" | pbcopy
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    cat "$csv_file" | xclip -selection clipboard
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows (Cygwin/MSYS)
    cat "$csv_file" | clip
  else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

# Open the specified URL with the CSV data using the default web browser
open_url() {
  local url="$1"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "$url"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open "$url"
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows (Cygwin/MSYS)
    start "$url"
  else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

# Function to find files larger than a specified size and create a CSV
find_large_files() {
  local folder="$1"
  local min_size="$2"
  local output_csv="$3"

  # Create a header row in the CSV file
  echo "Folder Name,File Name,File Size (bytes)" > "$output_csv"

  # Find files larger than the specified size in the given folder and subfolders
  find "$folder" -type f -size +${min_size}c -print0 | while IFS= read -r -d '' file; do
    folder_name=$(dirname "$file")
    file_name=$(basename "$file")
    
    # Determine the OS type and use the appropriate 'stat' command
    if [[ "$OSTYPE" == "darwin"* ]]; then
      file_size=$(stat -f%z "$file")  # macOS (BSD-based)
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      file_size=$(stat -c%s "$file")  # Linux
    else
      echo "Unsupported operating system: $OSTYPE"
      exit 1
    fi
    echo "$folder_name,$file_name,$file_size"    
    echo "$folder_name,$file_name,$file_size" >> "$output_csv"
  done
}

# Main function
main() {
  folder=""
  min_size=""
  output_csv=""

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--folder) folder="$2"; shift 2;;
      -s|--min-size) min_size="$2"; shift 2;;
      -o|--output-csv) output_csv="$2"; shift 2;;
      -h|--help) display_help; exit 0;;
      *) echo "Invalid option: $1"; display_help; exit 1;;
    esac
  done

  # Check if --help option was specified
  if [[ "${OPTARG}" == "help" ]]; then
    display_help
    exit 0
  fi

  # Check if all required options are provided
  if [ -z "$folder" ] || [ -z "$min_size" ] || [ -z "$output_csv" ]; then
    echo "Error: Missing required options. Use --help for usage information."
    exit 1
  fi

  # Check if the specified folder exists
  if [ ! -d "$folder" ]; then
    echo "Error: Folder '$folder' does not exist."
    exit 1
  fi

  # Check if the specified size is a positive integer
  if ! [[ "$min_size" =~ ^[0-9]+$ ]]; then
    echo "Error: Minimum size must be a positive integer."
    exit 1
  fi

  # Call the function to find and create CSV of large files
  find_large_files "$folder" "$min_size" "$output_csv"

  # Copy CSV content to clipboard based on OS type
  copy_to_clipboard "$output_csv"

  echo "CSV file '$output_csv' created with large files."

  # Open the specified URL with the CSV data
  web_url="https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"
  open_url "$web_url"
}

main "$@"

