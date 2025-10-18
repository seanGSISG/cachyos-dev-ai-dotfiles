#!/bin/bash
# This hook runs before tool execution
# You can use it to log, validate, or transform tool calls

# Example: Log all file writes
# if [[ "$TOOL_NAME" == "Write" ]]; then
#   echo "Writing to: $FILE_PATH" >> .claude/tool-usage.log
# fi

# Pass through - don't block
exit 0
