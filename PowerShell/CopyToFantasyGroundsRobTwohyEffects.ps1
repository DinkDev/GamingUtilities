$source = "C:\Users\Dale\documents\DriveThruRPG\Dungeon Masters Guild"

$effectDirsPattern = "Fantasy Grounds 5E *Effects Coding *"

$rob2EModDirs = @(Get-ChildItem -Path $source -Include $effectDirsPattern -Name)

$targetPath = Join-Path -Path $env:APPDATA -ChildPath "Smiteworks\Fantasy Grounds\modules"

ForEach ($modDir in $rob2EModDirs)
{
    $modPath = Join-Path -Path $source -ChildPath $modDir

    $modFiles = Get-ChildItem -Path $modPath -Include "*.mod" -Name

    ForEach ($modFile in $modFiles)
    {
        if ($modFile -NotLike "*LOCKED*")
        {
            $modFilePath = Join-Path -Path $modPath -ChildPath $modFile

            Copy-Item $modFilePath -Destination $targetPath
        }
    }
}

$otherModDirs = Get-ChildItem -Path $source -Name

ForEach ($modDir in $otherModDirs)
{
    if ($rob2EModDirs -contains $modDir) {

    } else {
        
        $modPath = Join-Path -Path $source -ChildPath $modDir

        $modFiles = Get-ChildItem -Path $modPath -Include "*.mod" -Name

        ForEach ($modFile in $modFiles)
        {
            $modFilePath = Join-Path -Path $modPath -ChildPath $modFile

            Copy-Item $modFilePath -Destination $targetPath
        }
    }
}