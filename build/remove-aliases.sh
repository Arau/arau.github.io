#!/bin/bash

# Check input argument supplied
if [ -z "$1" ]; then
  echo "Remove aliases from metadata section of files in previous docs release"
  echo "Usage: $(basename $0) release-dir"
  echo "Example:"
  echo -e "\t $(basename $0) v2.4"
  exit 1
fi

bin_dir="$(dirname "$0")"
previous_release="$bin_dir/../content/$1"

# List all files in the input path containing the pattern: "aliases: "
files_with_aliases=( $(grep -R -l "aliases:" "$previous_release") )

for source_file in ${files_with_aliases[@]}; do

  echo "Applying changes for $source_file"

  #   1. Select the lines in between 2 patterns and apply a command to them
  #        * pattern 1: a line that starts with the word "aliases"
  #        * pattern 2: anything that starts with a letter or starts with "---"
  #        * command: Delete the lines in between the patterns (not including the matching lines themselves)
  #
  #   ...The second command takes the output of the first command as input:
  #
  #   2. Select the lines in between 2 patterns and apply a command to those
  #        * pattern 1: a line that starts with "---"
  #        * pattern 2: a line that starts with "---"
  #        * command: delete the line that starts with the word "aliases"

  # These 2 commands together ensure changes are only made to the metadata section of the markdown files.

  sed -i '/^aliases/,/^[a-zA-Z]\|^---/{//!d}; /^---/,/^---/{ /^aliases:/d };' "$source_file"
done
