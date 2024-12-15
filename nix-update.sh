#!/run/current-system/sw/bin/bash


# Paths
CONFIG_DIR="/etc/nixos"
GIT_DIR="$HOME/nix"  # Adjust if needed

# Exit on errors
set -e

# Function to rebuild the NixOS system
rebuild_system() {
    echo "Rebuilding NixOS configuration..."
    if sudo nixos-rebuild switch; then
        echo "NixOS rebuild succeeded."
        return 0
    else
        echo "NixOS rebuild failed!"
        return 1
    fi
}

# Function to handle Git operations
git_commit_and_push() {
    echo "Committing and pushing changes to Git..."
    cd "$GIT_DIR"

    # Check for changes
    if git status --porcelain | grep -q '^'; then
        git add .
        COMMIT_MSG="Update configuration - $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MSG"
        echo "Committed changes with message: '$COMMIT_MSG'"

        # Push to remote
        git push
        echo "Changes pushed to remote repository."
    else
        echo "No changes to commit."
    fi
}

# Function to show errors and diff
show_errors_and_diff() {
    echo "Showing Git diff for debugging..."
    cd "$GIT_DIR"
    git diff
    echo "Rebuild errors occurred. Check above for details."
}

# Main execution flow
if rebuild_system; then
    git_commit_and_push
else
    show_errors_and_diff
fi

