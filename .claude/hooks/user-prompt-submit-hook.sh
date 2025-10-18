#!/bin/bash
# This hook runs when you submit a prompt to Claude
# You can use it to validate or transform your requests

# Example: Check if git repo is clean before major operations
# if [[ "$1" == *"commit"* ]] || [[ "$1" == *"push"* ]]; then
#   if ! git diff-index --quiet HEAD --; then
#     echo "Warning: You have uncommitted changes"
#   fi
# fi

# Pass through - don't block
exit 0
