# Server List
#$ServerList = Get-Content -Path #my/path/to/server/list.txt

# CIM Session 
#$Session = New-CimSession -computername $ServerList -Credential (Get-Credential)

# OR, create multiple cimsessions using a comma separated list
$allSessions = New-CimSession -ComputerName “machine1”, “machine2”, “machine3” –Credential $credentials

#Get eventlog
$getlog = Get-EventLog -LogName System -EntryType Error -Newest 20 -ComputerName "adconnect", "scmgmt1", "localhost" | format-table
$getlog | format-table -Property

$s = "adconnect", "localhost", "scmgmt2"
Foreach ($Server in $S) {$Server; Get-WinEvent -ListLog "Windows PowerShell" -Computername $Server}