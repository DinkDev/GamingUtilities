param (
  [string]$pdfFile = 'D:\temp\test.pdf'
)

$pdfInfoExe = 'pdfinfo.exe'
$pdfImagesExe = 'pdfimages.exe'
$pdfToTextExe = 'pdftotext.exe'
$nConvertExe = 'nconvert.exe'

$haveAllExes = $true

if ($null -eq (Get-Command $pdfInfoExe -ErrorAction SilentlyContinue))
{
  $haveAllExes = $false
  Write-Host "Unable to find $pdfInfoExe in your PATH"
}

if ($null -eq (Get-Command $pdfImagesExe -ErrorAction SilentlyContinue))
{
  $haveAllExes = $false
  Write-Host "Unable to find $pdfImagesExe in your PATH"
}

if ($null -eq (Get-Command $pdfToTextExe -ErrorAction SilentlyContinue))
{
  $haveAllExes = $false
  Write-Host "Unable to find $pdfToTextExe in your PATH"
}

if ($null -eq (Get-Command $nConvertExe -ErrorAction SilentlyContinue))
{
  $haveAllExes = $false
  Write-Host "Unable to find $nConvertExe in your PATH"
}

if ($haveAllExes)
{
  $pdfInfo = & $pdfInfoExe $pdfFile

  $pdfPagesResult = $pdfInfo | Where-Object {$_ -match 'Pages:'} |
    Foreach-Object { $_ -replace 'Pages:\s*', ''} |
    Select-Object -First 1

  [int]$pages = [convert]::ToInt32($pdfPagesResult, 10)

  # Write-Output "The file $pdfFile has $pages pages."
  Write-Output "The file $pdfFile has $pages pages."

  $baseDir = [io.path]::GetFileNameWithoutExtension($pdfFile)

  $pageDigits = [math]::Truncate([math]::Log10($pages)) + 1;

  Write-Output "log10 of pages = $pageDigits"

  For ($page = 1; $page -le $pages; $page++) {
    $targetDir = $baseDir + '.page' + $page.ToString().Padleft($pageDigits, '0')
    $targetOutput = $targetDir + '\image'

    Write-Output "Creating folder $targetDir"

    New-Item -ItemType directory -Path $targetDir

    & $pdfImagesExe -f $page -l $page $pdfFile $targetOutput

    $targetTextFile = $targetOutput + ".txt"

    Write-Output "Creating text file $targetTextFile"

    & $pdfToTextExe -f $page -l $page -table $pdffile $targetTextFile

    Write-Output "Converting images in $targetDir to png"

    Push-Location $targetDir

    & $nConvertExe -out png -D image-*.*

    Pop-Location
  }
}