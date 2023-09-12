#!/bin/bash

# ----------------------------------------------------
# kalam-gitlogs.sh
# author: mchinnappan
# provides a csv view of git logs in a git folder and loads that
#   csv to datatlable viewer
# _______________________
# Usage: bash kalam-gitlogs.sh [OPTIONS]
#  -g, --gitFolder  Path to the Git repository folder
#  -d, --fromDate   Filter commits from the specified date (YYYY-MM-DD)
#  -o, --outputCsv  Specify the output CSV file
#  --help           Display this help message
# _______________________
# Usage: example:
#    bash kalam-gitlogs.sh -g <git_folder> -d 2023-01-01 -o /tmp/gitlogs.csv
# ----------------------------------------------------

# Define function to display help information
display_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "  -g, --gitFolder  Path to the Git repository folder"
  echo "  -d, --fromDate   Filter commits from the specified date (YYYY-MM-DD)"
  echo "  -o, --outputCsv  Specify the output CSV file"
  echo "  --help           Display this help message"
}

# Define function to get Git commit logs and format them
get_git_commit_logs() {
  git_folder="$1"
  from_date="$2"
  git --git-dir="$git_folder/.git" log --pretty=format:"%h,%ad,%an,%s" --date=iso --since="$from_date"
}


# Define function to copy CSV content to clipboard based on OS type
copy_to_clipboard() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    cat "$1" | pbcopy
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    cat "$1" | xclip -selection clipboard
  else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

# Define function to open URL in web browser based on OS type
open_url() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open "$1"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open "$1"
  else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}


# Main function
main() {
  # Parse command-line arguments
  while getopts "g:d:o:-:" opt; do
    case "$opt" in
      g) git_folder="$OPTARG";;
      d) from_date="$OPTARG";;
      o) output_csv="$OPTARG";;
      -)
        case "${OPTARG}" in
          help) display_help; exit 0;;
          *) echo "Invalid option: --${OPTARG}" >&2; exit 1;;
        esac;;
      \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
      :) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
    esac
  done

  # Check if --help option was specified
  if [[ "${OPTARG}" == "help" ]]; then
    display_help
    exit 0
  fi

  # Default values if not provided
  from_date="${from_date:-2023-08-01}"
  output_csv="${output_csv:-/tmp/commit_logs.csv}"

  # Get Git commit logs
  commit_logs=$(get_git_commit_logs "$git_folder" "$from_date")

  # Check if any commits were found
  if [[ -z "$commit_logs" ]]; then
    echo "No commits found."
    exit 1
  fi

  # Create a CSV header row
  echo "Commit ID,Date,Author,Message" > "$output_csv"

  # Format and append commit logs to CSV file
  while IFS= read -r commit; do
#    commit_id=$(echo "$commit" | cut -d',' -f1)
#    commit_date=$(echo "$commit" | cut -d',' -f2)
#    commit_author=$(echo "$commit" | cut -d',' -f3)
#    commit_message=$(echo "$commit" | cut -d',' -f4-)
     echo "$commit" >> "$output_csv"
  done <<< "$commit_logs"
#
  echo "Commit logs saved to $output_csv"

  # Copy CSV content to clipboard based on OS type
  copy_to_clipboard "$output_csv"
    # Open the specified URL with the CSV data using the default web browser
  web_url="https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"
  open_url "$web_url"

}

main "$@"

