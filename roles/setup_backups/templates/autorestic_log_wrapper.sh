#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <autorestic_command>"
    exit 1
fi

DEFAULT_LOG_FILE="{{ autorestic_default_log_file }}"
# Define the log directory
LOG_DIR="{{ autorestic_log_dir }}"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

LOCATION_REGEX="^.*location\s\"(\S+)\"\s*\$"
# Run the autorestic command with the provided arguments, capturing both stdout and stderr
"$@" 2>&1 | while IFS= read -r line; do
    # Check if the line indicates a new backup location
    if [[ $line =~ $LOCATION_REGEX ]]; then
        # Extract the location name
        location_name="${BASH_REMATCH[1]}"

        # Define the log file for the current location
        log_file="$LOG_DIR/$location_name.log"

        # Write the current line to the appropriate log file
        echo "$line" >> "$log_file"
    else
        # If we are already in a location, append to the current log file
        if [[ -n "$log_file" ]]; then
            echo "$line" >> "$log_file"
        else
            echo "$line" >> "$DEFAULT_LOG_FILE"
        fi
    fi
    # Also output to stdout
    echo "$line"
done
