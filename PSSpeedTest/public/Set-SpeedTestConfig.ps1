function Set-SpeedTestConfig {
    <#
        .SYNOPSIS
        Set the default server configurations for Internet and Local speed test servers.

        .DESCRIPTION
        Set the default server configurations for Internet and Local speed test servers, enable iperf to run in parallel if desired, and set the number of threads if running in parallel.
        Convert parameter values to appropriate PSCustomObject and write to the JSON configuration file.

        .PARAMETER InternetServer
        The server that will be utilized when running "Invoke-SpeedTest -Internet".

        .PARAMETER InternetPort
        The port that will be utilized when running "Invoke-SpeedTest -Internet".

        .PARAMETER LocalServer
        The server that will be utilized when running "Invoke-SpeedTest -Local".

        .PARAMETER LocalPort
        The port that will be utilized when running "Invoke-SpeedTest -Local".

        .PARAMETER Parallel
        Determines if iPerf3 is run in parallel (-P) when running "Invoke-SpeedTest".

        .PARAMETER ParallelThreads
        The number of threads used when the "Parallel" switch is enabled. The default is 4.

        .EXAMPLE
        Set-SpeedTestConfig -InternetServer "test.public.com" -InternetPort "5201"
        Sets the default Internet speed test server to "test.public.com" on port "5201".

        .EXAMPLE
        Set-SpeedTestConfig -InternetServer "test.public.com"
        Sets the default Internet speed test server to "test.public.com".
        When running a speed test, the last saved Internet port will be utilized, or the default port "5201".

        .EXAMPLE
        Set-SpeedTestConfig -InternetPort "5201"
        Sets the default Internet speed test port to "5201".
        Requires a previously-saved Internet speed test server.

        .EXAMPLE
        Set-SpeedTestConfig -LocalServer "test.local.com" -LocalPort "5201"
        Sets the default Local speed test server to "test.local.com" on port "5201".

        .EXAMPLE
        Set-SpeedTestConfig -LocalServer "test.local.com"
        Sets the default Local speed test server to "test.local.com".
        When running a speed test, the last saved Local port will be utilized, or the default port "5201".

        .EXAMPLE
        Set-SpeedTestConfig -Local "5201"
        Sets the default Local speed test port to "5201".
        Requires a previously-saved Local speed test server.

        .EXAMPLE
        Set-SpeedTestConfig -Parallel $True -ParallelThreads 8
        Enables the parallel flag for iPerf3, and sets the threads to 8.
        Setting the number of threads requires "Parallel" to be set to True.
    #>

    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]
        $InternetServer,
        [ValidateNotNullOrEmpty()]
        [String]
        $InternetPort,
        [ValidateNotNullOrEmpty()]
        [String]
        $LocalServer,
        [ValidateNotNullOrEmpty()]
        [String]
        $LocalPort,
        [ValidateNotNullOrEmpty()]
        [String]
        $Parallel,
        [ValidateNotNullOrEmpty()]
        [String]
        $ParallelThreads
    )

    try {
        Write-Verbose -Message 'Trying Get-SpeedTestConfig before Set-SpeedTestConfig.'
        $config = Get-Content -Path "$PSScriptRoot\config.json" -ErrorAction 'Stop' |
            ConvertFrom-Json
        Write-Verbose -Message 'Stored config.json found.'
    } catch {
        Write-Verbose -Message 'No configuration found - starting with empty configuration.'
        $jsonString = @'
{   
    "defaultLocalServer" : {
        "defaultServer" : "",
        "defaultPort"   : ""
    },
    "defaultInternetServer" : {
        "defaultServer" : "",
        "defaultPort"   : ""
    },
    "parallelSettings": {
        "runAsParallel": false,
        "parallelThreads": 4
    }
}
'@
        $config = $jsonString |
            ConvertFrom-Json
    }

    # Detailed parameter validation against current configuration
    if ($InternetPort -and (!($InternetServer)) -and (!($config.defaultInternetServer.defaultServer))) {
        throw 'Cannot set an Internet port with an empty InternetServer setting.'
    }
    if ($LocalPort -and (!($LocalServer)) -and (!($config.defaultLocalServer.defaultServer))) {
        throw 'Cannot set a Local port with an empty LocalServer setting.'
    }

    if ($InternetServer) {$config.defaultInternetServer.defaultServer = $InternetServer}
    if ($InternetPort) {$config.defaultInternetServer.defaultPort = $InternetPort}
    if ($LocalServer) {$config.defaultLocalServer.defaultServer = $LocalServer}
    if ($LocalPort) {$config.defaultLocalServer.defaultPort = $LocalPort}
    if ($Parallel) {$config.parallelSettings.runAsParallel = $Parallel}
    if ($ParallelThreads) {$config.parallelSettings.parallelThreads = $ParallelThreads}

    Write-Verbose -Message 'Setting config.json.'
    $config |
        ConvertTo-Json |
            Set-Content -Path "$PSScriptRoot\config.json"
}