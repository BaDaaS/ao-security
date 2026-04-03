#!/usr/bin/env bash
# Run all .sage files in the sage/ directory and report failures.
#
# Usage: run-sage-tests.sh <sage-dir>
set -euo pipefail

sage_dir="${1:?Usage: run-sage-tests.sh <sage-dir>}"

if ! command -v sage &> /dev/null; then
    echo "::error::SageMath is not installed"
    exit 1
fi

files=$(find "$sage_dir" -name '*.sage' | sort)
total=$(echo "$files" | wc -l | tr -d ' ')
passed=0
failed=0
errors=""

for f in $files; do
    name="${f#"$sage_dir"/}"
    echo "--- Running: $name ---"
    if sage "$f"; then
        passed=$((passed + 1))
        echo "--- PASS: $name ---"
    else
        failed=$((failed + 1))
        errors="${errors}  - ${name}\n"
        echo "::error::$name failed"
        echo "--- FAIL: $name ---"
    fi
    echo
done

echo "=============================="
echo "Results: $passed/$total passed"
if [ "$failed" -gt 0 ]; then
    printf "Failed:\n%b" "$errors"
    exit 1
fi
echo "All sage files passed."
