$GitPromptSettings.BeforeText = "["
$GitPromptSettings.DefaultPromptEnableTiming = $false
$GitPromptSettings.EnableWindowTitle = " "
$GitPromptSettings.EnableFileStatus = $false

$GitPromptScriptBlock = {
    if ($GitPromptSettings.DefaultPromptEnableTiming) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
    }
    $origLastExitCode = $global:LASTEXITCODE

    # Display default prompt prefix if not empty.
    $defaultPromptPrefix = [string]$GitPromptSettings.DefaultPromptPrefix
    if ($defaultPromptPrefix) {
        $expandedDefaultPromptPrefix = $ExecutionContext.SessionState.InvokeCommand.ExpandString($defaultPromptPrefix)
        Write-Prompt $expandedDefaultPromptPrefix
    }

    # Write the abbreviated current path
    $currentPath = $ExecutionContext.SessionState.InvokeCommand.ExpandString($GitPromptSettings.DefaultPromptPath)
    #Write-Prompt $currentPath

    # Write the Git status summary information
    Write-VcsStatus 
	
	Write-Prompt "`n$currentPath"

    # If stopped in the debugger, the prompt needs to indicate that in some fashion
    $hasInBreakpoint = [runspace]::DefaultRunspace.Debugger | Get-Member -Name InBreakpoint -MemberType property
    $debugMode = (Test-Path Variable:/PSDebugContext) -or ($hasInBreakpoint -and [runspace]::DefaultRunspace.Debugger.InBreakpoint)
    $promptSuffix = if ($debugMode) { $GitPromptSettings.DefaultPromptDebugSuffix } else { $GitPromptSettings.DefaultPromptSuffix }

    # If user specifies $null or empty string, set to ' ' to avoid "PS>" unexpectedly being displayed
    if (!$promptSuffix) {
        $promptSuffix = ' '
    }

    $expandedPromptSuffix = $ExecutionContext.SessionState.InvokeCommand.ExpandString($promptSuffix)

    # If prompt timing enabled, display elapsed milliseconds
    if ($GitPromptSettings.DefaultPromptEnableTiming) {
        $sw.Stop()
        $elapsed = $sw.ElapsedMilliseconds
        Write-Prompt " ${elapsed}ms"
    }

    $global:LASTEXITCODE = $origLastExitCode
    $expandedPromptSuffix
}

Set-Item Function:\prompt -Value $GitPromptScriptBlock
