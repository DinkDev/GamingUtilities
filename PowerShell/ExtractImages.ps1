param (
  [string]$pdfFile = 'D:\temp\test.pdf'
)

$pdfInfoExe = 'C:\ProgramData\chocolatey\bin\pdfinfo.exe'
$pdfImagesExe = 'C:\ProgramData\chocolatey\bin\pdfimages.exe'
$pdfToTextExe = 'C:\ProgramData\chocolatey\bin\pdftotext.exe'

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
}