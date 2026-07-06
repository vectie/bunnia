# Git Hooks

## Pre-commit Hook

This pre-commit hook runs `scripts/ci.sh` before finalizing your commit. That is
the same generated CI plan used by GitHub Actions, including check, test,
interface generation, formatting, diff gates, active example inspect/build/
snapshot checks, and scaffold smoke validation.

### Usage Instructions

To use this pre-commit hook:

1. Make the hook executable if it isn't already:
   ```bash
   chmod +x .githooks/pre-commit
   ```

2. Configure Git to use the hooks in the .githooks directory:
   ```bash
   git config core.hooksPath .githooks
   ```

3. The hook will automatically run when you execute `git commit`.

If the hook fails after `moon info` or `moon fmt`, review the resulting diff,
stage the intended changes, and commit again.
