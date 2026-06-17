#!/bin/bash

# Exit on error
set -e

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SKILLS_SRC_DIR="$SCRIPT_DIR/skills"
GLOBAL_SKILLS_DIR="$HOME/.gemini/antigravity-cli/skills"

# Function to display help
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -s, --symlink   Create symbolic links to the repository skills (default)"
    echo "                  (Recommended for active development so changes sync automatically)"
    echo "  -c, --copy      Copy skill folders to the global directory instead of linking"
    echo "  -h, --help      Show this help message"
}

# Parse options
MODE="symlink"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--symlink) MODE="symlink"; shift ;;
        -c|--copy) MODE="copy"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
done

echo "========================================================"
echo "⚙️  Installing Harness Antigravity Skills Globally"
echo "========================================================"
echo "Source directory:        $SKILLS_SRC_DIR"
echo "Global skills directory: $GLOBAL_SKILLS_DIR"
echo "Installation mode:       $MODE"
echo ""

# Check if skills source directory exists
if [ ! -d "$SKILLS_SRC_DIR" ]; then
    echo "❌ Error: 'skills' directory not found in $SCRIPT_DIR"
    exit 1
fi

# Ensure global skills directory exists
mkdir -p "$GLOBAL_SKILLS_DIR"

# Loop through each skill in the skills directory
for skill_path in "$SKILLS_SRC_DIR"/*; do
    if [ -d "$skill_path" ]; then
        skill_name=$(basename "$skill_path")
        dest_path="$GLOBAL_SKILLS_DIR/$skill_name"
        
        echo "Processing skill: $skill_name"
        
        # Remove existing symlink or folder at destination
        if [ -L "$dest_path" ]; then
            echo "  - Removing existing symbolic link at $dest_path"
            rm "$dest_path"
        elif [ -d "$dest_path" ]; then
            echo "  - Removing existing directory at $dest_path"
            rm -rf "$dest_path"
        fi
        
        if [ "$MODE" = "symlink" ]; then
            # Create symbolic link pointing to the source directory
            echo "  - Creating symbolic link: $dest_path -> $skill_path"
            ln -s "$skill_path" "$dest_path"
        else
            # Copy the directory
            echo "  - Copying directory: $skill_path -> $dest_path"
            cp -r "$skill_path" "$dest_path"
        fi
        echo "  ✅ Successfully installed $skill_name"
    fi
done

echo ""
echo "🎉 Global skills installation completed successfully!"
echo "The skills are now available globally in Antigravity CLI."
echo "========================================================"
