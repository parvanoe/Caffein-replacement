# Caffein-replacement
Caffein-replacement via powershell
# stay_awake.ps1

Keeps your PC awake and Microsoft Teams status green — no Python, no installs, no admin rights required.

## How it works

- Calls the Windows `SetThreadExecutionState` API to block OS sleep and screen-off.
- Sends a silent **F13** key press on a regular interval to simulate user activity (Teams and similar apps see this as activity and stay green).
- Restores normal sleep settings automatically when you stop the script.

## Requirements

- Windows PowerShell 5.1 or later (built into Windows — no install needed).

## Usage

### Option 1 — Right-click in File Explorer

Right-click `stay_awake.ps1` → **Run with PowerShell**

### Option 2 — From a terminal

```powershell
powershell -ExecutionPolicy Bypass -File stay_awake.ps1
```

### Option 3 — Custom interval

By default the ghost key is sent every **60 seconds**. Pass `-IntervalSeconds` to change it:

```powershell
powershell -ExecutionPolicy Bypass -File stay_awake.ps1 -IntervalSeconds 30
```

## Stopping

Press **Ctrl+C** in the console window (or close the window). The script will automatically restore the original OS sleep settings before it exits.

## Output example

```
[09:00:00] OS sleep prevention: ACTIVE
[09:00:00] Stay-awake started. Interval: 60s | Key: F13
Press Ctrl+C to stop.

[09:00:00] F13 sent — press #1 | uptime 0h 0m 0s
[09:01:00] F13 sent — press #2 | uptime 0h 1m 0s
...
[09:05:00] Stopped. OS sleep restored.
```
