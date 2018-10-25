#############################################################################  
#  Filename: DiskSpaceReport.ps1
#  Created for: Skamania County 
#  Author: Joe Stine 
#  Email: thejoeshow24@gmail.com/joe@co.skamania.wa.us
#  Web: https://github.com/jstine
#  Date: 10/22/18                                                        
##############################################################################  
<#
.SYNOPSIS
Check disk space usage and generate HTML file to be emailed to IT dept.
.DESCRIPTION
Imports csv file containing list of servers. Uses WMI to get free drive space. Formats to HTML. Emails to IT. 
Intended to be run as a scheduled task daily. 
.NOTES
You need to run this as a member of the Domain Admins group.
#>  
 
 
 
$freeSpaceFileName = "E:\users\joe\desktop\FreeSpace.htm" 
 
New-Item -ItemType file $freeSpaceFileName -Force 
# Getting the freespace info using WMI 
# Get-WmiObject win32_logicaldisk  | Where-Object {$_.drivetype -eq 3 -OR $_.drivetype -eq 2 } | format-table DeviceID, VolumeName,status,Size,FreeSpace | Out-File FreeSpace.txt 
# Function to write the HTML Header to the file 
Function writeHtmlHeader 
{ 
param($fileName) 
$date = ( get-date ).ToString('yyyy/MM/dd') 
Add-Content $fileName "<html>" 
Add-Content $fileName "<head>" 
Add-Content $fileName "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>" 
Add-Content $fileName '<title>DiskSpace Report</title>' 
add-content $fileName '<STYLE TYPE="text/css">' 
add-content $fileName  "<!--" 
add-content $fileName  "td {" 
add-content $fileName  "font-family: Tahoma;" 
add-content $fileName  "font-size: 11px;" 
add-content $fileName  "border-top: 1px solid #999999;" 
add-content $fileName  "border-right: 1px solid #999999;" 
add-content $fileName  "border-bottom: 1px solid #999999;" 
add-content $fileName  "border-left: 1px solid #999999;" 
add-content $fileName  "padding-top: 0px;" 
add-content $fileName  "padding-right: 0px;" 
add-content $fileName  "padding-bottom: 0px;" 
add-content $fileName  "padding-left: 0px;" 
add-content $fileName  "}" 
add-content $fileName  "body {" 
add-content $fileName  "margin-left: 5px;" 
add-content $fileName  "margin-top: 5px;" 
add-content $fileName  "margin-right: 0px;" 
add-content $fileName  "margin-bottom: 10px;" 
add-content $fileName  "" 
add-content $fileName  "-->" 
add-content $fileName  "</style>" 
Add-Content $fileName "</head>" 
Add-Content $fileName "<body>" 
add-content $fileName  "<table width='100%'>" 
add-content $fileName  "<tr bgcolor='#5F9EA0'>" 
add-content $fileName  "<td colspan='9' height='25'  width=5% align='left'>" 
add-content $fileName  "<font face='tahoma' color='#000000' size='5'><center><strong>DiskSpace Report - $date</strong></center></font>" 
add-content $fileName  "</td>" 
add-content $fileName  "</tr>" 
 
} 
 
# Function to write the HTML Header to the file 
Function writeTableHeader 
{ 
param($fileName) 
Add-Content $fileName "<tr bgcolor=#5F9EA0>" 
Add-Content $fileName "<td><b>Server</b></td>" 
Add-Content $fileName "<td><b>Drive</b></td>" 
Add-Content $fileName "<td><b>Drive Label</b></td>" 
Add-Content $fileName "<td><b>Total Capacity(GB)</b></td>" 
Add-Content $fileName "<td><b>Used Capacity(GB)</b></td>" 
Add-Content $fileName "<td><b>Free Space(GB)</b></td>" 
Add-Content $fileName "<td><b>FreeSpace % </b></td>" 
Add-Content $fileName "<td><b>Status </b></td>" 
Add-Content $fileName "</tr>" 
} 
 
Function writeHtmlFooter 
{ 
param($fileName) 
 
Add-Content $fileName "</body>" 
Add-Content $fileName "</html>" 
} 
 
Function writeDiskInfo 
{ 
param($fileName,$server,$DeviceID,$VolumeName,$TotalSizeGB,$UsedSpaceGB,$FreeSpaceGB,$FreePer,$status) 
if ($status -eq 'warning') 
{ 
Add-Content $fileName "<tr>" 
Add-Content $fileName "<td >$server</td>" 
Add-Content $fileName "<td >$DeviceID</td>" 
Add-Content $fileName "<td >$VolumeName</td>" 
Add-Content $fileName "<td >$TotalSizeGB</td>" 
Add-Content $fileName "<td >$UsedSpaceGB</td>" 
Add-Content $fileName "<td >$FreeSpaceGB</td>" 
Add-Content $fileName "<td  bgcolor='#B8860B' >$FreePer</td>" 
Add-Content $fileName "<td >$status</td>" 
Add-Content $fileName "</tr>" 
} 
elseif ($status -eq 'critical') 
{ 
Add-Content $fileName "<tr>" 
Add-Content $fileName "<td >$server</td>" 
Add-Content $fileName "<td >$DeviceID</td>" 
Add-Content $fileName "<td >$VolumeName</td>" 
Add-Content $fileName "<td >$TotalSizeGB</td>" 
Add-Content $fileName "<td >$UsedSpaceGB</td>" 
Add-Content $fileName "<td >$FreeSpaceGB</td>" 
Add-Content $fileName "<td bgcolor='#FF0000' >$FreePer</td>" 
Add-Content $fileName "<td >$status</td>" 
Add-Content $fileName "</tr>" 
 
} 
elseif ($status -eq 'low') 
{ 
Add-Content $fileName "<tr>" 
Add-Content $fileName "<td >$server</td>" 
Add-Content $fileName "<td >$DeviceID</td>" 
Add-Content $fileName "<td >$VolumeName</td>" 
Add-Content $fileName "<td >$TotalSizeGB</td>" 
Add-Content $fileName "<td >$UsedSpaceGB</td>" 
Add-Content $fileName "<td >$FreeSpaceGB</td>" 
Add-Content $fileName "<td bgcolor='#7FFFD4' >$FreePer</td>" 
Add-Content $fileName "<td >$status</td>" 
Add-Content $fileName "</tr>" 
} 
elseif ($status -eq 'good') 
{ 
Add-Content $fileName "<tr>" 
Add-Content $fileName "<td >$server</td>" 
Add-Content $fileName "<td >$DeviceID</td>" 
Add-Content $fileName "<td >$VolumeName</td>" 
Add-Content $fileName "<td >$TotalSizeGB</td>" 
Add-Content $fileName "<td >$UsedSpaceGB</td>" 
Add-Content $fileName "<td >$FreeSpaceGB</td>" 
Add-Content $fileName "<td bgcolor='#006400' >$FreePer</td>" 
Add-Content $fileName "<td >$status</td>" 
Add-Content $fileName "</tr>" 
} 
} 
 
writeHtmlHeader $freeSpaceFileName 
 
writeTableHeader $freeSpaceFileName 
Import-Csv E:\users\joe\desktop\servers.csv|%{  
$cserver = $_.Server  
$cdrivelt = $_.Drive  
$clowth = $_.LowTh  
$cwarnth = $_.WarnTh  
$ccritth = $_.CritTh  
$status='' 
if(Test-Connection -ComputerName $cserver -Count 1 -ea 0) { 
$diskinfo= Get-WmiObject -Class Win32_LogicalDisk -ComputerName $cserver  -Filter "DeviceID='$cdrivelt'"  
ForEach ($disk in $diskinfo)  
{  
If ($diskinfo.Size -gt 0) {$percentFree = [Math]::round((($diskinfo.freespace/$diskinfo.size) * 100))}  
Else {$percentFree = 0}  
#Process each disk in the collection and write to spreadsheet  
    $server=$disk.__Server 
     $deviceID=$disk.DeviceID  
     $Volume=$disk.VolumeName  
     $TotalSizeGB=[math]::Round(($disk.Size /1GB),2)  
     $UsedSpaceGB=[math]::Round((($disk.Size - $disk.FreeSpace)/1GB),2)  
     $FreeSpaceGB=[math]::Round(($disk.FreeSpace / 1GB),2)  
     $FreePer=("{0:P}" -f ($disk.FreeSpace / $disk.Size))  
        
    #Determine if disk needs to be flagged for warning or critical alert  
    If ($percentFree -le  $ccritth) {  
        $status = "Critical"  
             } ElseIf ($percentFree -gt $ccritth -AND $percentFree -le $cwarnth) {  
        $status = "Warning"  
              }  
     ElseIf ($percentFree -ge $cwarnth -AND $percentFree -lt $clowth) {  
        $status = "Low"  
                       
    } Else {  
        $status = "Good"  
           }  
  } 
write-host  $server $DeviceID  $Volume $TotalSizeGB  $UsedSpaceGB $FreeSpaceGB $FreePer $status 
writeDiskInfo $freeSpaceFileName $server $DeviceID  $Volume $TotalSizeGB  $UsedSpaceGB $FreeSpaceGB $FreePer $status 
} 
} 
Add-Content $freeSpaceFileName "</table>"  
writeHtmlFooter $freeSpaceFileName 


$EmailSplat = @{
To = 'cts@co.skamania.wa.us'
From = 'support@co.skamania.wa.us'
SmtpServer = 'co-skamania-wa-us.mail.protection.outlook.com'
Attachments = 'E:\users\joe\desktop\freespace.htm'
Subject = 'Disk Space Report'

}
Send-MailMessage @EmailSplat

$TicketSplat = @{
To = 'support@co.skamania.wa.us'
From = 'support@co.skamania.wa.us'
SmtpServer = 'co-skamania-wa-us.mail.protection.outlook.com'
#Attachments = 'E:\users\joe\desktop\freespace.htm'
Subject = 'Low Disk Space on' + $server

}
Send-MailMessage @TicketSplat