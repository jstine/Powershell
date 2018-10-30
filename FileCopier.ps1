$ArchivePath = Read-Host "Archive Path"
$TargetPath = Read-Host "Target Path"
$MovedFiles = Read-Host "Log Path"
$ErrorLog = Read-Host "Error Log Path"

Get-ChildItem $TargetPath | ForEach-Object {
$FilePath = $_.fullname
Try
{
Move-Item $FilePath $ArchivePath
$FilePath | Add-Content $MovedFiles
}
Catch
{
"ERROR moving $filename: $_" | Add-Content $ErrorLog
}
}