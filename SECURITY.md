# Security Policy

This tool runs with administrator privileges and adjusts system memory
using native Windows APIs. That combination deserves a clear way to
report security issues.

## Reporting a vulnerability

Open a **private security advisory** on GitHub. Don't open a public
issue for security reports.

What helps: the app version, Windows version, and steps to reproduce.
This is a local desktop tool, so most issues will be about privilege
handling or unsafe native calls rather than remote exploitation —
describe what you found plainly.

## What counts

In scope:

- Privilege handling: anything that lets a non-admin context abuse
  the app's elevated operations.
- Unsafe P/Invoke usage: memory corruption, unchecked native return
  values, or privilege adjustments (`SeDebugPrivilege` and friends)
  applied more broadly than needed.
- The global hotkey and tray interactions, if they can be abused by
  other local processes.

Not security issues:

- "Trimming memory doesn't speed up my PC" — that's a design debate,
  not a vulnerability.
- Anything in third-party NuGet packages — report upstream.
- Social engineering or anything targeting me personally.

## Scope

In scope: this repo's own code.

Out of scope: third-party libraries, the .NET Framework / Windows
itself, the GitHub release infrastructure.

## What to expect

Indie project, no bug bounty, no SLA. I'll acknowledge your report,
fix confirmed issues, and credit you unless you'd rather stay
anonymous.
