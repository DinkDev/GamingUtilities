param($scriptName)

$path = Get-Location
# $baseScriptName = "$($MyInvocation.MyCommand.Name)".Split(".") | Select-Object -first 1

$global:logPath = Join-Path -path $path -ChildPath "logs"
$deleteLogFilesOlderThenDays = '7d' # Format example for 30 days: "30d"

$paramSetPSFLoggingProvider = @{

    # For all parameters of the "Logfile" provider read here: https://psframework.org/documentation/documents/psframework/logging/providers/logfile.html
    Name             = 'logfile'
    Enabled          = $true

    InstanceName     = 'MyTask'
    FilePath         = Join-Path $logPath -ChildPath "$scriptName-%Date%.txt"
    LogRotatePath    = Join-Path $logPath -ChildPath "$scriptName-*.txt"

    # XML, CSV, Json, Html, CMTrace
    # For CMTrace - Download Microsoft CM Viewer: https://www.microsoft.com/en-us/download/confirmation.aspx?id=50012
    FileType         = 'Json'
    JsonCompress     = $false
    JsonString       = $true
    JsonNoComma      = $false

    #Headers         = 'ComputerName', 'File', 'FunctionName', 'Level', 'Line', 'Message', 'ModuleName', 'Runspace', 'Tags', 'TargetObject', 'Timestamp', 'Type', 'Username', 'Data'
    Headers          = 'Timestamp', 'Level', 'Message', 'Data', 'FunctionName', 'Line', 'Username', 'ComputerName', 'File'
    TimeFormat       = 'yyyy-MM-dd HH:mm:ss.fff'

    LogRetentionTime = $deleteLogFilesOlderThenDays
    LogRotateRecurse = $true
}

Set-PSFLoggingProvider @paramSetPSFLoggingProvider
#be sure to account for an extra 35 lines in the logging output