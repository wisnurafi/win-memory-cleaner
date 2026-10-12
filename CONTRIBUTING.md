# Contributing to Windows Memory Cleaner

## Building

- Visual Studio 2019 or newer, .NET Framework 4.0+.
- Open `WinMemoryCleaner.sln`, restore NuGet packages, build `Release`.
- CLI: `nuget restore` + `msbuild` (steps in the README).

There is no CI and no test suite — build clean and run it before
opening a PR.

## Translations

The most welcome contribution. Translations live in
`Resources/Localization/*.json` as embedded resources:

1. Copy `English.json` to `<YourLanguage>.json`.
2. Translate the values (keep the keys unchanged).
3. Add an `<EmbeddedResource>` entry for it in
   `WinMemoryCleaner.csproj`.
4. Rebuild and check the UI in that language.

## Code changes

- MVVM: keep logic in ViewModels/Services, XAML stays dumb.
- P/Invoke additions go in `Core/NativeMethods.cs`. Double-check
  privilege requirements — this app already runs as admin, so new
  native calls get extra scrutiny in review.
- Don't add network calls. The app is fully offline and it's
  staying that way.
- Don't add telemetry, analytics, or background services.

## Pull requests

- One change per PR. Small PRs get reviewed fast.
- Commit messages read like a human wrote them: `fix: ...`,
  `feat: ...`.
- Describe what you tested: which Windows version, what you ran,
  what you observed in Task Manager.
