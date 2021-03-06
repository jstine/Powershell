 Function Get-NicInfo {

 <#
  .SYNOPSIS
  Gather Network Information from all connected NIC's on a computer
  .DESCRIPTION
  Uses WMI Classes to gather relevant NIC information
  .EXAMPLE
  Get-NicInfo -ComputerName Server1
  .EXAMPLE
  $Servers = Get-Content List.txt
  $servers|Get-NicInfo
  .EXAMPLE
  Get-ADComputer -Properties 'Name' -Filter 'enabled -eq $true'| select -First 10 Name| Get-NicInfo|FT Hostname,Name,"Link Speed","IP Address"
  Gets First 10 enabled active directory computer names, and pipes them to Get-NicInfo
  .PARAMETER computername
  The computer name to query. One or multiple.

  #>
#By Vince Vardaro




[CmdletBinding()]
param(
[Parameter(
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What computer name would you like to target?')]
    [Alias('Name','Computer','host')]
    [ValidateLength(3,30)]
    [string[]]$ComputerName=$env:COMPUTERNAME

)

process {
$NicArray = @()
foreach ($computer in $ComputerName){
Write-Verbose "$computer Foreach"
        
        foreach ($Adapter in (gwmi Win32_NetworkAdapter -ComputerName $computer -Filter "NetEnabled='True'")) 
        {
            Write-Verbose "$computer $adapter foreach"
            $Config = gwmi Win32_NetworkAdapterConfiguration -ComputerName $computer -Filter "Index = '$($Adapter.Index)'"
            $Obj= New-Object -Type PSObject -Property @{
                Hostname              = $Adapter.SystemName
                Name                  = $Adapter.name
                "Network"             = $Adapter.NetConnectionID
                "MAC Address"         = $Config.MACAddress
                "IP Address"          = $Config.IPAddress -join "; "
                "DHCP Server"         = if ($Config.DHCPServer -eq $null){"DHCP Disabled"}
                                        else {$Config.DHCPServer}
                "DHCP Enabled"        = $Config.DHCPEnabled
                "DHCP Lease Obtained" = if ($Config.DHCPLeaseObtained -eq $null){"DHCP Disabled"}
                                        else {[management.managementDateTimeConverter]::ToDateTime($Config.DHCPLeaseObtained)}
                "DHCP Lease Expires"  = if ($Config.DHCPLeaseExpires -eq $null){"DHCP Disabled"}
                                        else {[management.managementDateTimeConverter]::ToDateTime($Config.DHCPLeaseExpires)}
                "Subnet Mask"         = $Config.IPSubnet -join "; "
                "Default Gateway"     = $Config.DefaultIPGateway -join "; "
                "DNS Suffix"          = $Config.DNSDomain
                "DNS Servers"         = $Config.DNSServerSearchOrder -join "; "
                "Up Time"             = [management.managementDateTimeConverter]::ToDateTime($Adapter.TimeOfLastReset)
                "Link Speed"          = if ($Adapter.Speed -gt 999999999) 
                                        {-join (($Adapter.Speed/1000000000)," ","Gb/s")}
                                        else {-join (($Adapter.Speed/1000000)," ","Mb/s")}
         
                        }
            Write-Verbose "$($Obj.hostname) Nic: $($Obj.Name) collected!"
            $NicArray += $Obj
            }
        
        } 

        Write-Output $NicArray
        }


}