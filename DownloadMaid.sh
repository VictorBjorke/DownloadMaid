#!/bin/bash

# Define the path to your Downloads folder
downloads_folder="$HOME/Downloads"

# Create subdirectories if they don't exist
mkdir -p "$downloads_folder/Documents"
mkdir -p "$downloads_folder/Images"
mkdir -p "$downloads_folder/Archives"
mkdir -p "$downloads_folder/Music"
mkdir -p "$downloads_folder/Videos"
mkdir -p "$downloads_folder/Applications"
mkdir -p "$downloads_folder/DMG"
mkdir -p "$downloads_folder/Other"

# Move files to their respective subdirectories
for file in "$downloads_folder"/*; do
    if [ -f "$file" ]; then
        file_type=$(file -b --mime-type "$file" | cut -d/ -f1)
        file_extension=${file##*.}

        case "$file_type" in
            "text")
                mv "$file" "$downloads_folder/Documents"
                ;;
            "image")
                mv "$file" "$downloads_folder/Images"
                ;;
            "application")
                case "$file_extension" in
                    "app")
                        mv "$file" "$downloads_folder/Applications"
                        ;;
                    "dmg")
                        mv "$file" "$downloads_folder/DMG"
                        ;;
                    *)
                        mv "$file" "$downloads_folder/Archives"
                        ;;
                esac
                ;;
            "audio")
                mv "$file" "$downloads_folder/Music"
                ;;
            "video")
                mv "$file" "$downloads_folder/Videos"
                ;;
            *)
                mv "$file" "$downloads_folder/Other"
                ;;
        esac
    fi
done

echo "Done"
