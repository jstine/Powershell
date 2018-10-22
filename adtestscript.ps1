# Get Name
$FirstName = Read-Host 'First Name'
$LastName = Read-Host 'Last Name'
$FullName = $FirstName + " " + $LastName

# Create User Name
$First5 = $LastName[0..5] -join ''
$UserName = $First5 + $FirstName.Substring(0,3)

# Get Password
$Pass = Read-Host "Password" # dumb, but I do this twice and use it in two ways

# Create Email name (Does not create an account)
$EmailDomain = "@company.com" # looks redundant, using it later
$Email = $FirstName + "_" + $LastName + $EmailDomain

# Get Department
[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 9 ){
Write-Host "1. Accounting"
Write-Host "2. Admin"
Write-Host "3. Benefits"
Write-Host "4. HR"
Write-Host "5. IT"
Write-Host "6. Payroll"
Write-Host "7. Risk Management"
Write-Host "8. Sales"
Write-Host "9. Staffing"

[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 9..." }
Switch( $xMenuChoiceA ){
  1{$Department = "Accounting"}
  2{$Department = "Admin"}
  3{$Department = "Benefits"}
  4{$Department = "HR"}
  5{$Department = "IT"}
  6{$Department = "Payroll"}
  7{$Department = "Risk Management"}
  8{$Department = "Sales"}
  9{$Department = "Staffing"} }

# Get employee AD info

$Title = Read-Host -Prompt 'Employee Title'
$Mobile = Read-Host -Prompt 'Company Cell Phone (blank for none)'
if($Mobile = $Null){$Mobile = "555-555-5555"}
$Extension = Read-Host -Prompt 'Phone Extension'

# Prompt for password and place user in Active Directory

  New-ADUser -SamAccountName $UserName -AccountPassword (Read-Host -AsSecureString "AccountPassword") -CannotChangePassword 0 -ChangePasswordAtLogon 1 -Department $Department -EmailAddress $Email -Enabled 1 -ScriptPath $UserName -Name ($FirstName, $LastName -Join " ") -GivenName $FirstName -Surname $LastName -DisplayName ($FirstName, $LastName -Join " ") -UserPrincipalName $UserName@unit.company.com -Title $Title -MobilePhone $Mobile -Fax "555-555-5555" -OfficePhone "555-555-5555 x$Extension"
    
  # Add user to appropriate group membership
    
  Add-ADGroupMember -Identity $Department -Members $UserName
    
  # Move user to appropriate OU
    
  Get-ADUser $UserName | Move-ADObject -TargetPath "OU=$Department,DC=UNIT,DC=COMPANY,DC=COM"