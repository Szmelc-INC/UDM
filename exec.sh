#!/bin/bash
# Modular Dialog Menu
# Szmelc Utils

CONFIG_FILE="config.yml"
TMP_FILE="menu.tmp"

# Parse the YAML configuration and create dialog options
awk -F ': ' '/name/ {name=$2} /command/ {command=$2; print name, command}' "$CONFIG_FILE" > "$TMP_FILE"

# Build an array for dialog menu options
declare -A DIALOG_OPTIONS
while IFS= read -r line; do
    option_name=$(echo "$line" | awk '{print $1}')
    option_command=$(echo "$line" | awk '{$1=""; print $0}')
    DIALOG_OPTIONS["$option_name"]=$option_command
done < "$TMP_FILE"

# Generate dialog command options
DIALOG_CMD="dialog --menu 'Custom Command Menu' 0 0 0"
for option in "${!DIALOG_OPTIONS[@]}"; do
    DIALOG_CMD+=" '$option' ''"
done

# Execute dialog and store the result
eval "$DIALOG_CMD" 2> "$TMP_FILE.result"

# Read the selected option
selected_option=$(cat "$TMP_FILE.result")

# Execute the selected command
selected_command="${DIALOG_OPTIONS[$selected_option]}"
eval "$selected_command"

# Clean up temporary files
rm -f "$TMP_FILE" "$TMP_FILE.result"
