#!/bin/bash
# analyze-pr.sh: Extensive PR analysis using pr-review-instructions.md
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

echo "This review was performed according to the guidelines in pr-review-instructions.md." > pr-comment.txt
echo "--- Automated PR Analysis ---" >> pr-comment.txt

# Get list of changed .cs files, excluding obj/ and bin/
CHANGED_CS_FILES=$(git diff --name-only "$BASE_BRANCH".."$HEAD_BRANCH" | grep '\.cs$' | grep -vE '^(obj|bin)/' || true)

for file in $CHANGED_CS_FILES; do
  echo "" >> pr-comment.txt
  echo "Reviewing **$file**:" >> pr-comment.txt

  # 1. Code Quality: Naming conventions, modularity, indentation, braces
  # Improved class name extraction: only match valid C# class declarations
  CLASS_NAMES=$(grep -E '^\s*(public|internal|private|protected)?\s*class\s+[A-Za-z_][A-Za-z0-9_]*' "$file" | sed -E 's/^.*class\s+([A-Za-z_][A-Za-z0-9_]*).*/\1/' | grep -P '^[a-z]' || true)
  for cname in $CLASS_NAMES; do
    echo "[WARNING] Class name not in PascalCase: $cname" >> pr-comment.txt
  done
  METHOD_NAMES=$(grep -Po 'void \K[^\s(]+' "$file" | grep -P '^[a-z]' || true)
  for mname in $METHOD_NAMES; do
    echo "[WARNING] Method name not in PascalCase: $mname" >> pr-comment.txt
  done
  VAR_NAMES=$(grep -Po 'string \K[^\s=;]+' "$file" | grep -P '^[A-Z]' || true)
  for vname in $VAR_NAMES; do
    echo "[WARNING] Local variable name not in camelCase: $vname" >> pr-comment.txt
  done
  if grep -qP '\t' "$file"; then
    echo "[WARNING] Tab indentation found. Use spaces only." >> pr-comment.txt
  fi
  if grep -qP '^[^\S\n]+$' "$file"; then
    echo "[WARNING] Inconsistent indentation detected." >> pr-comment.txt
  fi
  if grep -qP 'if\s*\([^)]*\)\s*[^\{]' "$file"; then
    echo "[WARNING] Missing curly braces in if statement." >> pr-comment.txt
  fi
  if grep -qP 'for\s*\([^)]*\)\s*[^\{]' "$file"; then
    echo "[WARNING] Missing curly braces in for statement." >> pr-comment.txt
  fi

  # 2. Error Handling
  if ! grep -q 'try' "$file"; then
    echo "[WARNING] No try-catch error handling found." >> pr-comment.txt
  fi
  if grep -q 'catch (Exception)' "$file" && ! grep -q 'throw' "$file"; then
    echo "[WARNING] Exception caught but not logged or rethrown." >> pr-comment.txt
  fi

  # 3. Security
  if grep -q -i 'select .* from' "$file"; then
    echo "[WARNING] Possible SQL query detected. Check for SQL injection risks." >> pr-comment.txt
  fi
  if grep -q -i 'password\s*=\s*' "$file"; then
    echo "[WARNING] Possible hardcoded password detected." >> pr-comment.txt
  fi
  if grep -q 'Console.WriteLine' "$file"; then
    echo "[INFO] Review Console.WriteLine usage for sensitive data exposure." >> pr-comment.txt
  fi

  # 4. Test Coverage
  TEST_FILE=$(echo "$file" | sed 's/\.cs$/Tests.cs/I')
  if [ ! -f "$TEST_FILE" ]; then
    echo "[WARNING] No corresponding test file ($TEST_FILE) found for $file." >> pr-comment.txt
  fi
  if ! grep -q 'Assert\.' "$file" && echo "$file" | grep -qi 'test'; then
    echo "[WARNING] Test file does not contain any Assert statements." >> pr-comment.txt
  fi

  # 5. Performance
  if grep -qP 'for\s*\(' "$file"; then
    echo "[INFO] Review for-loop usage for performance." >> pr-comment.txt
  fi
  if grep -qP 'while\s*\(' "$file"; then
    echo "[INFO] Review while-loop usage for performance." >> pr-comment.txt
  fi
  if grep -qP 'Task\.Run|async|await' "$file" && ! grep -qP 'await' "$file"; then
    echo "[WARNING] Async method without await detected." >> pr-comment.txt
  fi

  # 6. Documentation
  if grep -q 'public class' "$file" && ! grep -q '///' "$file"; then
    echo "[WARNING] No XML documentation for public class." >> pr-comment.txt
  fi
  if grep -q 'public void' "$file" && ! grep -q '///' "$file"; then
    echo "[WARNING] No XML documentation for public method." >> pr-comment.txt
  fi
  if ! grep -qP '\/\/|\/\*|\*\/' "$file"; then
    echo "[WARNING] No code comments found in $file." >> pr-comment.txt
  fi

  # 7. Code Style & Formatting
  if grep -qE '//.*;' "$file"; then
    echo "[WARNING] Commented-out code detected." >> pr-comment.txt
  fi
  if grep -E '\bunusedVariable\b' "$file" > /dev/null 2>&1; then
    echo "[WARNING] Found unused variable named 'unusedVariable'." >> pr-comment.txt
  fi
  if grep -q 'TODO' "$file"; then
    echo "[WARNING] Found TODO comments in $file." >> pr-comment.txt
  fi
  if grep -E 'null.*\.ToString\(\)' "$file" > /dev/null 2>&1; then
    echo "[WARNING] Possible null dereference with .ToString() detected in $file." >> pr-comment.txt
  fi
  if grep -qP '\n\s*\n' "$file"; then
    echo "[WARNING] Extra blank lines detected." >> pr-comment.txt
  fi

done

echo -e "\n(Extend this script to parse pr-review-instructions.md and automate more checks.)" >> pr-comment.txt
