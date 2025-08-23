#!/bin/bash
# Usage: ./cron-wrapper.sh job-name command [args ...]

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./cron-wrapper.sh job-name command [args ...]" >&2
  exit 1
fi

JOB_NAME="$1"
COMMAND="$2"
LOG_DIR="$HOME/cron-logs"
STDOUT_LOG="$LOG_DIR/${JOB_NAME}_stdout.log"
STDERR_LOG="$LOG_DIR/${JOB_NAME}_stderr.log"
MAX_LINES=1000

mkdir -p "$LOG_DIR"

# Append heading to logs
HEADING="=== Run started at $(date +"%Y-%m-%d %H:%M:%S") ==="
echo "$HEADING" >> "$STDOUT_LOG"
echo "$HEADING" >> "$STDERR_LOG"

# Run provided command, append stdout and stderr separately
{
    shift
    "$@"
} 1>> "$STDOUT_LOG" 2>> "$STDERR_LOG"
EXIT_CODE="$?"

# Append trailing line to logs
TRAILING="=== Run ended at $(date +"%Y-%m-%d %H:%M:%S") (exit code: "$EXIT_CODE") ==="
echo "$TRAILING" >> "$STDOUT_LOG"
echo "$TRAILING" >> "$STDERR_LOG"

# Limit log file size
tail -n "$MAX_LINES" "$STDOUT_LOG" > "$STDOUT_LOG.tmp" && mv "$STDOUT_LOG.tmp" "$STDOUT_LOG"
tail -n "$MAX_LINES" "$STDERR_LOG" > "$STDERR_LOG.tmp" && mv "$STDERR_LOG.tmp" "$STDERR_LOG"

# If inner script failed, show Raycast notification
if [ "$EXIT_CODE" -ne 0 ]; then
    JOB_NAME_ENCODED=$(printf "$JOB_NAME" | jq -sRr @uri)
    open "raycast://extensions/maxnyby/raycast-notification/index?arguments=%7B%22type%22%3A%22failure%22%2C%22message%22%3A%22%22%2C%22title%22%3A%22Con%20Job%20Failed%3A%20${JOB_NAME_ENCODED}%22%7D"
fi

exit 0

