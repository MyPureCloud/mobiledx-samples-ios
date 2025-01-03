#!/bin/bash
export LANG=en_US.UTF-8
# Get the directory of the script
SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$SCRIPT_DIR/../"

# Define the target files relative to the script directory
PROD_FILE=".Podfile.prod"
DEV_FILE=".Podfile.dev"
LOCAL_FILE=".Podfile.local"
LINK_NAME="Podfile"

# Function to update the symbolic link
update_symlink() {
    case $1 in
        1)
            ln -sf "$PROD_FILE" "$LINK_NAME"
            echo "The symbolic link $LINK_NAME now points to $PROD_FILE."
            pod update
            ;;
        2)
            ln -sf "$DEV_FILE" "$LINK_NAME"
            echo "The symbolic link $LINK_NAME now points to $DEV_FILE."
            pod update
            ;;
        3)
            ln -sf "$LOCAL_FILE" "$LINK_NAME"
            echo "The symbolic link $LINK_NAME now points to $LOCAL_FILE."
            pod install
            ;;
        *)
            echo "Invalid choice. Please provide 1, 2, or 3, or run the script without arguments for a menu."
            exit 1
            ;;
    esac
}

# Check if an argument is provided
if [ -n "$1" ]; then
    # Use the argument as the choice
    update_symlink "$1"
else
    # Display the menu if no argument is provided
    echo "Select the Podfile to use:"
    echo "1) Production (.Podfile.prod)"
    echo "2) Development (.Podfile.dev)"
    echo "3) Local (.Podfile.local)"
    echo -n "Enter your choice [1-3]: "

    # Read a single character from input
    read -n 1 choice
    echo  # Move to a new line for better output formatting

    # Update the symbolic link based on the user's choice
    update_symlink "$choice"
fi
