#!/bin/bash
SCRIPT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$SCRIPT_DIR/../"

# Copy git hooks
HOOKS_SOURCE_DIR="scripts/hooks"
HOOKS_TARGET_DIR=".git/hooks"

cp "$HOOKS_SOURCE_DIR/pre-commit" "$HOOKS_TARGET_DIR/"
cp "$HOOKS_SOURCE_DIR/post-checkout" "$HOOKS_TARGET_DIR/"