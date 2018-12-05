<#
    .SYNOPSIS
    Removes the iPerf3 server scheduled task that was previously configured.

    .DESCRIPTION
    Removes the iPerf3 server scheduled task that was previously configured.
    Stops the task and then unregisters it.

    .EXAMPLE
    Remove-iPerf3Task
#>

function Remove-iPerf3Task {
    [CmdletBinding()]
    Param(

    )

    Write-Verbose -Message "Unregistering iPerf3 scheduled task."

    try {
        Get-ScheduledTask -TaskName 'iPerf3 Server' | Unregister-ScheduledTask
    }
    catch {
        Write-Verbose -Message "Scheduled task not found - no action taken."
    }
}