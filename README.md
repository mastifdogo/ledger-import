# ledger-import

A [Claude](https://claude.ai) skill that turns QuickBooks exports into a
database dump for [Ledger](https://github.com/mastifdogo/Bookeeping), the
self-hosted bookkeeping app. Upload the exports to a chat, get back
`ledger.dump`, and restore it in Ledger under **Settings → Backups → Restore
from a backup → upload a dump file**.

```
quickbooks-to-ledger/
  SKILL.md                 what Claude follows
  scripts/qb_convert.py    QuickBooks exports → books.json (to review)
  scripts/build_dump.py    books.json → ledger.dump (with PostgreSQL)
  assets/ledger-db/        Ledger's schema and migrations the dump is built on
  assets/modules/          the Sales and Auto sort modules' tables
quickbooks-to-ledger-skill.zip   the same folder, ready to upload
```

## What it converts

- **The books**: the chart of accounts (QuickBooks `Parent:Child` accounts
  become sub-accounts) and every journal entry, from a **Journal** report
  (CSV or Excel) plus the **Account List**, or from a QuickBooks Desktop
  **.IIF** file.
- **Sales module**: customers and invoices (Customer Contact List, Invoice
  List, or IIF).
- **Auto sort module**: bills, open or paid (Unpaid Bills, Transaction List
  by Vendor, or IIF).

Payroll details, attachments, bank feeds, reconciliations, items, vendors as
a list, estimates and credit memos as documents stay in QuickBooks; their
accounting effect is in the journal entries.

## Requirements

- **Ledger 0.15.0 or later** to restore the dump. A module whose data is in
  the dump (Sales, Auto sort) must be installed in Ledger first.
- **PostgreSQL 15** where Claude runs its code, because Ledger's server runs
  PostgreSQL 15 and can only read dumps written by that version or older.
  The skill looks for it and otherwise fetches it from PyPI
  (`postgresql-binaries`). Where neither works it stops and says so.
- Ledger keeps books in CAD and USD.

## Install

**Claude (claude.ai, desktop and mobile apps):** Settings → Capabilities:
turn on code execution, then under **Skills** upload
[`quickbooks-to-ledger-skill.zip`](quickbooks-to-ledger-skill.zip).

**Claude Code:**

```sh
git clone https://github.com/mastifdogo/ledger-import
mkdir -p ~/.claude/skills && cp -R ledger-import/quickbooks-to-ledger ~/.claude/skills/
```

## Updating

`assets/ledger-db` is a copy of Ledger's `db/schema.sql` and
`db/migrations` (`LEDGER_VERSION` says from which release), and
`assets/modules/<id>/migrations` of each module's. When Ledger or a module
adds a migration, copy it in, bump the version file, and run `sh make-zip.sh`.
