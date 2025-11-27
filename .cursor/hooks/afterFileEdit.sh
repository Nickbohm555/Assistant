#!/bin/bash

# ===============================
#  AFTER FILE EDIT – PYTHON FORMATTER HOOK
#  Hardened version with:
#  - JSON validation
#  - Graceful jq failure fallback
#  - File existence checks
#  - Python-only filtering
#  - Safe Black invocation
# ===============================

# Read raw JSON safely
raw_input="$(cat)"

# Log start (sent to Cursor internal logs)
echo "🔥 Hook Fired – afterFileEdit" >&2

# Try parsing file_path with jq (check both 'file_path' and 'path' fields)
file_path="$(echo "$raw_input" | jq -r 'try (.file_path // .path) catch ""' 2>/dev/null)"

# If jq parsing failed or file_path is null/empty
if [[ -z "$file_path" || "$file_path" == "null" ]]; then
    echo "⚠️  Skipping: file_path/path not found in hook input." >&2
    echo "Raw input:" >&2
    echo "$raw_input" >&2
    exit 0
fi

# Expand ~ or relative path if needed
file_path=$(realpath "$file_path" 2>/dev/null)

# Check file exists
if [[ ! -f "$file_path" ]]; then
    echo "⚠️  Skipping: File does not exist – $file_path" >&2
    exit 0
fi

# Only format Python files
if [[ "$file_path" != *.py ]]; then
    echo "ℹ️  Skipping: Not a Python file – $file_path" >&2
    exit 0
fi

# Absolute path to Black (Anaconda env)
BLACK="/Users/nickbohm/opt/anaconda3/bin/black"

# Check Black existence
if [[ ! -x "$BLACK" ]]; then
    echo "❌ ERROR: Black not found at $BLACK" >&2
    exit 0
fi

echo "✨ Running Black: $file_path" >&2

# Run Black safely
"$BLACK" --quiet "$file_path" 2>&1 | sed 's/^/[Black] /' >&2

echo "✅ Formatting complete." >&2

exit 0
