[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$processNames = @("SGuard64.exe", "SGuardSvc64.exe")
$cpuCount = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors
$lastCoreMask = [int64]([math]::Pow(2, $cpuCount - 1))

foreach ($name in $processNames) {
    Write-Host "等待进程 $name 启动..."
    do {
        Start-Sleep -Seconds 2
        $proc = Get-Process -Name ($name -replace ".exe","") -ErrorAction SilentlyContinue
    } until ($proc)

    Write-Host "设置进程 $name 优先级为低，绑定到最后一个CPU核心..."
    try {
        $proc.PriorityClass = "Idle"
        $proc.ProcessorAffinity = $lastCoreMask
        Write-Host "✅ 已设置: $name -> 优先级 低, CPU核心 $($cpuCount - 1)"
    } catch {
        Write-Host "⚠️ 设置失败: 可能需要管理员权限"
    }
}
