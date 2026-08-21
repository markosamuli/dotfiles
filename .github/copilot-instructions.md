# Copilot instructions

The working rules for this repository live in [`AGENTS.md`](../AGENTS.md) —
the commands, the shell module-loading architecture, which of the two ignore
files a rule belongs in, commit and disclosure conventions, and how changes
land. [`README.md`](../README.md) describes what the repository is and how to
install it. Read those; this file deliberately holds no rules of its own.

Keeping a second copy here would mean maintaining two sets of instructions that
drift apart, and this repository has already paid for that once: the
`new:`/`chg:`/`fix:` commit convention documented here had stopped matching
practice, and nothing flagged it because the two records were never compared.

This file exists only because
[`AGENTS.md` isn't read on every Copilot surface](https://docs.github.com/en/copilot/reference/custom-instructions-support):
code review on github.com and the cloud agent pick it up, Copilot Chat in VS
Code does not. So point at `AGENTS.md`; don't restate it.
