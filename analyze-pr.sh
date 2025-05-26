#!/bin/bash
# analyze-pr.sh: Simulate PR analysis using pr-review-instructions.md
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

echo "Loaded PR Review Instructions:" > pr-comment.txt
cat AutomatedPRReview/pr-review-instructions.md >> pr-comment.txt

echo -e "\n--- Simulated PR Analysis ---" >> pr-comment.txt
if grep -q 'TODO' pr-diff.txt; then
  echo "[WARNING] Found TODO comments in the changes." >> pr-comment.txt
else
  echo "No TODO comments found in the changes." >> pr-comment.txt
fi

echo -e "\n(Extend this script to parse pr-review-instructions.md and automate more checks.)" >> pr-comment.txt
