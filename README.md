# Windows Memory Cleaner

A lightweight WPF application for Windows that frees up RAM by triggering native memory cleanup routines exposed by the Windows API. Built with C# on .NET Framework, using the MVVM pattern.

> Forked / personal build based on the original work by Igor Mundstein.

## Features

- One-click memory optimization for multiple memory areas:
  - Combined Page List
  - Modified Page List
  - Processes Working Set
  - Standby List (and Low Priority Standby List)
  - System Working Set
- Automatic optimization based on a configurable interval or RAM usage threshold
- Process exclusion list to skip apps you do not want trimmed
- Global hotkey support for instant optimization
- System tray icon with live memory usage indicator
- Run on Windows startup, with optional priority and start-minimized
- Compact mode and always-on-top window
- Dark UI with rounded corners on Windows 11
- Optimization notifications
- Multi-language support (25+ languages bundled as embedded resources)

## Requirements

- Windows 7 or later (Windows 10 / 11 recommended)
- .NET Framework 4.0 or later
- Administrator privileges (required by the Windows API memory routines)

## Project Structure

```
WinMemoryCleaner/
├── src/
│   ├── Attribute/        # Custom attributes
│   ├── Command/          # RelayCommand (MVVM)
│   ├── Converters/       # WPF value converters
│   ├── Core/             # Constants, DI, Logger, Settings, NativeMethods, etc.
│   ├── Interfaces/       # Service contracts
│   ├── Model/            # Domain models (Computer, Memory, HotKey, ...)
│   ├── Properties/       # AssemblyInfo
│   ├── Resources/
│   │   ├── Images/       # Icon and assets
│   │   └── Localization/ # Per-language JSON files
│   ├── Service/          # Service implementations
│   ├── View/             # XAML views and controls
│   ├── ViewModel/        # ViewModels and locator
│   ├── App.xaml(.cs)     # Application entry
│   ├── app.manifest      # Requires administrator
│   ├── packages.config   # NuGet packages
│   └── WinMemoryCleaner.csproj
├── .gitignore
└── README.md
```

## Building

### Using Visual Studio

1. Open `src/WinMemoryCleaner.sln` in Visual Studio 2019 or newer.
2. Restore NuGet packages (right-click solution > Restore NuGet Packages).
3. Select the `Release` configuration.
4. Build > Build Solution (Ctrl+Shift+B).
5. The output binary will be at `src/bin/Release/WinMemoryCleaner.exe`.

### Using MSBuild from CLI

```powershell
# From the src directory
nuget restore WinMemoryCleaner.sln
msbuild WinMemoryCleaner.sln /p:Configuration=Release /p:Platform="Any CPU"
```

## Running

Run `WinMemoryCleaner.exe` as administrator. The app will request elevation automatically through `app.manifest`.

Settings are persisted to the Windows Registry under `HKEY_CURRENT_USER\SOFTWARE\WinMemoryCleaner`.

## Localization

Translations live in `src/Resources/Localization/*.json` and are embedded as resources. To add a new language:

1. Copy `English.json` to `<YourLanguage>.json`.
2. Translate the values (keep the keys unchanged).
3. Add an `<EmbeddedResource>` entry for it in `WinMemoryCleaner.csproj`.
4. Rebuild.

## Architecture Notes

- MVVM with a lightweight `ObservableObject` base and a `ViewModelLocator`.
- Manual dependency injection via `Core/DependencyInjection.cs`.
- P/Invoke wrappers in `Core/NativeMethods.cs` for the Windows memory APIs:
  - `NtSetSystemInformation` with `SystemMemoryListInformation`, `SystemFileCacheInformation`, `SystemCombinePhysicalMemoryInformation`
  - `EmptyWorkingSet` for per-process trimming
  - Privilege adjustments: `SeDebugPrivilege`, `SeIncreaseQuotaPrivilege`, `SeProfileSingleProcessPrivilege`
- Hotkey registration through `RegisterHotKey` / `WM_HOTKEY`.

## License

Distributed under the GPL-3.0 license.

## Credits

Original project and idea by Igor Mundstein:
https://github.com/IgorMundstein/WinMemoryCleaner
