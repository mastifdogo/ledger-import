#!/bin/sh
# Rebuilds quickbooks-to-ledger-skill.zip (the skill folder at the zip's top
# level, as Claude's skill upload expects). Run after changing the folder.
set -eu
cd "$(dirname "$0")"
rm -f quickbooks-to-ledger-skill.zip
if command -v zip >/dev/null 2>&1; then
	zip -qrX quickbooks-to-ledger-skill.zip quickbooks-to-ledger -x '*/__pycache__/*' '*.pyc'
else
	python3 -c "import shutil; shutil.make_archive('quickbooks-to-ledger-skill', 'zip', '.', 'quickbooks-to-ledger')"
fi
echo "wrote quickbooks-to-ledger-skill.zip"
