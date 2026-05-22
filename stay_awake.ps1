# stay_awake.ps1
# Keeps PC awake + Teams green. No Python, no installs needed.
# Run: Right-click → "Run with PowerShell"  OR  powershell -ExecutionPolicy Bypass -File stay_awake.ps1

param(
    [int]$IntervalSeconds = 60   # Change this to adjust how often the ghost key is sent
)

# ── Prevent OS sleep via Windows API ──────────────────────────────────────────
$code = @"
using System;
using System.Runtime.InteropServices;
public class SleepGuard {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
    public const uint ES_CONTINUOUS       = 0x80000000;
    public const uint ES_SYSTEM_REQUIRED  = 0x00000001;
    public const uint ES_DISPLAY_REQUIRED = 0x00000002;
    public static void Prevent() {
        SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
    }
    public static void Restore() {
        SetThreadExecutionState(ES_CONTINUOUS);
    }
}
"@
Add-Type -TypeDefinition $code

[SleepGuard]::Prevent()
Write-Host "[$(Get-Date -f 'HH:mm:ss')] OS sleep prevention: ACTIVE" -ForegroundColor Green

# ── Simulate F13 key press (ghost key — invisible to apps, counts as activity) ─
Add-Type -AssemblyName System.Windows.Forms

function Send-GhostKey {
    [System.Windows.Forms.SendKeys]::SendWait("{F13}")
}

# ── Main loop ──────────────────────────────────────────────────────────────────
$pressCount = 0
$startTime  = Get-Date

Write-Host "[$(Get-Date -f 'HH:mm:ss')] Stay-awake started. Interval: ${IntervalSeconds}s | Key: F13" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop.`n" -ForegroundColor Yellow

try {
    while ($true) {
        Send-GhostKey
        $pressCount++
        $uptime = (Get-Date) - $startTime
        $h = [math]::Floor($uptime.TotalHours)
        $m = $uptime.Minutes
        $s = $uptime.Seconds
        Write-Host "[$(Get-Date -f 'HH:mm:ss')] F13 sent — press #$pressCount | uptime ${h}h ${m}m ${s}s" -ForegroundColor DarkGray
        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    # Always restore on Ctrl+C or window close
    [SleepGuard]::Restore()
    Write-Host "`n[$(Get-Date -f 'HH:mm:ss')] Stopped. OS sleep restored." -ForegroundColor Yellow
}
