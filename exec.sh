#!/bin/bash
# Modular Dialog Menu
# Szmelc Utils
# V2 with json support

# Default filenames
CONFIG_FILE="config.json"
TMP_FILE="menu"

# Parse flags for config
while getopts "c:t:" opt; do
  case $opt in
    c) CONFIG_FILE="$OPTARG" ;;
    t) TMP_FILE="$OPTARG" ;;   
    *) echo "Usage: $0 [-c config_file] [-t tmp_file_prefix]" >&2; exit 1 ;;
  esac
done

# Temporary filenames
TMP_MENU="${TMP_FILE}.tmp"
TMP_RESULT="${TMP_FILE}.result"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed. Install jq and try again." >&2
  exit 1
fi

# Parse the JSON configuration and create dialog options
jq -r '.menu[] | "\(.name) \(.command)"' "$CONFIG_FILE" > "$TMP_MENU"

# Build an array for dialog menu options
declare -A DIALOG_OPTIONS
while IFS= read -r line; do
    option_name=$(echo "$line" | awk '{print $1}')
    option_command=$(echo "$line" | awk '{$1=""; print $0}')
    DIALOG_OPTIONS["$option_name"]=$option_command
done < "$TMP_MENU"

# Generate dialog command options
DIALOG_CMD="dialog --menu 'Custom Command Menu' 0 0 0"
for option in "${!DIALOG_OPTIONS[@]}"; do
    DIALOG_CMD+=" '$option' ''"
done

# Execute dialog and store the result
eval "$DIALOG_CMD" 2> "$TMP_RESULT"

# Read the selected option
selected_option=$(cat "$TMP_RESULT")

# Execute the selected command
selected_command="${DIALOG_OPTIONS[$selected_option]}"
eval "$selected_command"

# Clean up temporary files
rm -f "$TMP_MENU" "$TMP_RESULT"
