#!/bin/bash

# Exit on error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "========================================================"
echo "🚀 Installing Skills Globally to All AI Environments"
echo "   (Anti-Gravity, Claude Code, Codex)"
echo "========================================================"
echo ""

# Run Anti-Gravity Installer
if [ -f "$SCRIPT_DIR/anti_gravity_install_global.sh" ]; then
    bash "$SCRIPT_DIR/anti_gravity_install_global.sh" "$@"
fi

echo ""

# Run Claude Installer
if [ -f "$SCRIPT_DIR/claude_install_global.sh" ]; then
    bash "$SCRIPT_DIR/claude_install_global.sh" "$@"
fi

echo ""

# Run Codex Installer
if [ -f "$SCRIPT_DIR/codex_install_global.sh" ]; then
    bash "$SCRIPT_DIR/codex_install_global.sh" "$@"
fi

echo ""
echo "========================================================"
echo "✨ All global skill installations completed successfully!"
echo "========================================================"
