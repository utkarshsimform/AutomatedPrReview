#!/bin/bash
# analyze-pr.sh: Enhanced PR analysis using pr-review-instructions.md
# Usage: ./analyze-pr.sh <base-branch> <head-branch>

set -e

BASE_BRANCH="$1"
HEAD_BRANCH="$2"

if [ -z "$BASE_BRANCH" ] || [ -z "$HEAD_BRANCH" ]; then
  echo "Usage: $0 <base-branch> <head-branch>"
  exit 1
fi

echo "Checking out base branch: $BASE_BRANCH"
git fetch origin "$BASE_BRANCH":"$BASE_BRANCH"
git checkout "$BASE_BRANCH"

echo "Checking out head branch: $HEAD_BRANCH"
git fetch origin "$HEAD_BRANCH":"$HEAD_BRANCH"
git checkout "$HEAD_BRANCH"

echo "Generating diff between $BASE_BRANCH and $HEAD_BRANCH..."
git diff "$BASE_BRANCH".."$HEAD_BRANCH" > pr-diff.txt

echo "--- Automated PR Analysis ---" > pr-comment.txt

# Get list of changed .cs files, excluding obj/ and bin/
CHANGED_CS_FILES=$(git diff --name-only "$BASE_BRANCH".."$HEAD_BRANCH" | grep '\.cs$' | grep -vE '^(obj|bin)/' || true)

for file in $CHANGED_CS_FILES; do
  echo "\nReviewing $file:" >> pr-comment.txt

  # 1. Code Quality: Naming conventions (PascalCase for class, method, property; camelCase for local vars)
  # Class name check
  CLASS_NAMES=$(grep -Po 'class \K[^\s{]+' "$file" | grep -P '^[a-z]')
  for cname in $CLASS_NAMES; do
    echo "[WARNING] Class name not in PascalCase: $cname" >> pr-comment.txt
  done
  # Method name check
  METHOD_NAMES=$(grep -Po 'void \K[^\s(]+' "$file" | grep -P '^[a-z]')
  for mname in $METHOD_NAMES; do
    echo "[WARNING] Method name not in PascalCase: $mname" >> pr-comment.txt
  done
  # Local variable name check
  VAR_NAMES=$(grep -Po 'string \K[^\s=;]+' "$file" | grep -P '^[A-Z]')
  for vname in $VAR_NAMES; do
    echo "[WARNING] Local variable name not in camelCase: $vname" >> pr-comment.txt
  done

  # 2. Error Handling: Check for try-catch
  if ! grep -q 'try' "$file"; then
    echo "[WARNING] No try-catch error handling found." >> pr-comment.txt
  fi

  # 3. Security: Check for Console.WriteLine with possible sensitive data
  if grep -q 'Console.WriteLine' "$file"; then
    echo "[INFO] Review Console.WriteLine usage for sensitive data exposure." >> pr-comment.txt
  fi

  # 4. Test Coverage: Check for corresponding test file
  TEST_FILE=$(echo "$file" | sed 's/\.cs$/Tests.cs/I')
  if [ ! -f "$TEST_FILE" ]; then
    echo "[WARNING] No corresponding test file ($TEST_FILE) found for $file." >> pr-comment.txt
  fi

  # 5. Performance: Check for unnecessary loops (simple heuristic)
  if grep -q 'for (' "$file"; then
    echo "[INFO] Review for-loop usage for performance." >> pr-comment.txt
  fi

  # 6. Documentation: Check for missing XML doc comments on public classes/methods
  if grep -q 'public class' "$file" && ! grep -q '///' "$file"; then
    echo "[WARNING] No XML documentation for public class." >> pr-comment.txt
  fi
  if grep -q 'public void' "$file" && ! grep -q '///' "$file"; then
    echo "[WARNING] No XML documentation for public method." >> pr-comment.txt
  fi

  # 7. Code Style & Formatting: Check for commented-out code
  if grep -qE '//.*;' "$file"; then
    echo "[WARNING] Commented-out code detected." >> pr-comment.txt
  fi
  # Check for unused variables
  if grep -E '\bunusedVariable\b' "$file" > /dev/null 2>&1; then
    echo "[WARNING] Found unused variable named 'unusedVariable'." >> pr-comment.txt
  fi
  # Check for TODO comments
  if grep -q 'TODO' "$file"; then
    echo "[WARNING] Found TODO comments in $file." >> pr-comment.txt
  fi
  # Check for possible null dereference
  if grep -E 'null.*\.ToString\(\)' "$file" > /dev/null 2>&1; then
    echo "[WARNING] Possible null dereference with .ToString() detected in $file." >> pr-comment.txt
  fi

done

echo -e "\n(Extend this script to parse pr-review-instructions.md and automate more checks.)" >> pr-comment.txt
