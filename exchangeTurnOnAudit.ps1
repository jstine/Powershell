$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session

Connect-MsolService –Credential $LiveCred

Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true