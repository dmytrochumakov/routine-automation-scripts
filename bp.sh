#!/bin/bash

# Get the directory path of the script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Construct the full path to the desired folder
FOLDER_PATH="$SCRIPT_DIR/personal/web/blog/content/posts"

# Prompt user for the title
read -p "Enter the title of the post: " title

# Convert title to lowercase and replace spaces with dashes
file_name=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
# Create .md file
touch "$FOLDER_PATH/$file_name.md"
    
# Prompt user if they want to use the current date or enter another date
read -p "Do you want to use today's date? (Y/N): " use_current_date

if [[ $use_current_date == "Y" || $use_current_date == "y" ]]; then
    # Generate current date in the required format
    current_date=$(date +'%Y-%m-%dT%H:%M:%S+03:00')
else
    # Prompt user for the date
    read -p "Enter the date (e.g., Mar 22, 2024): " user_date

    converted_date=`date -jf "%B %d, %Y" "${user_date}" +"%Y-%m-%d"`

    # Concatenate with the desired time format
    final_date="${converted_date}T08:29:30+03:00"

    # Convert the date to the required format
    current_date="$final_date"
fi


# Prompt user for tags
read -p "Enter tags for the post (separated by commas): " tags_input

# Prompt user for content
read -p "Enter the content of the post (press Enter to finish):\n" content

# Convert tags to array
IFS=',' read -ra tags <<< "$tags_input"

# Format tags for metadata
formatted_tags=""
for tag in "${tags[@]}"; do
    formatted_tags+="\"$tag\", "
done

# Remove trailing comma and space
formatted_tags="${formatted_tags%,*}"

# Add metadata to .md
cat << EOF > "$FOLDER_PATH/$file_name.md"
+++
title = '$title'
date = $current_date
tags = [$formatted_tags]
draft = false
+++

### Introduction

$content

Thank you for reading!
EOF
