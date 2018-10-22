function Hotfixreport {
$computers = Get-Content $env:USERPROFILE\Desktop\Computers.txt
$ErrorActionPreference = 'Stop'
ForEach ($computer in $computers) {
    try{
        Get-HotFix -ComputerName $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn -Last 20 | ConvertTo-html
    }

    catch{
        Add-Content $computer -Path "$env:USERPROFILE\Desktop\NotReachable_Servers.txt"
    }
}
}

Hotfixreport > "E:\users\joe\Desktop\HotFixReport.htm"



