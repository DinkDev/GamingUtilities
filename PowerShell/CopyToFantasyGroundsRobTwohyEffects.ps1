$source = "$Home\Documents\DriveThruRPG\Dungeon Masters Guild"
$modDirs = @(Get-ChildItem -Path $source -Name)

$targetPath = Join-Path -Path $env:APPDATA -ChildPath "Smiteworks\Fantasy Grounds\modules"
Write-PSFMessage -Message "Copying modules to ${targetPath}"

$moduleCount = 0

ForEach ($modDir in $modDirs)
{
    $modPath = Join-Path -Path $source -ChildPath $modDir

    $modFiles = Get-ChildItem -Path $modPath -Include "*.mod" -Name

    ForEach ($modFile in $modFiles)
    {
        if ($modFile -NotLike "*LOCKED*" -And $modFile -NotLike "*.old-*")
        {
            $modFilePath = Join-Path -Path $modPath -ChildPath $modFile

            Write-PSFMessage -Message "Copying modules ${modFile} to ${targetPath}"
            Copy-Item $modFilePath -Destination $targetPath

            $moduleCount++
        }
    }
}

Write-PSFMessage -Message "Copied ${moduleCount} modules to ${targetPath}"
