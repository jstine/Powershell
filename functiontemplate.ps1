# Function template


# Define function 
function Get-InfoCompSystem {
    [CmdletBinding()] # This gives cmdlet like actions
    
    # Assign params for function
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName #can add multiple, separated, by, a, comma
    )

    # var that does the work
    $cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName

    # properties function can return
    $props = @{'Model'=$cs.model;
               'Manufacturer'=$cs.manufacturer;
               'RAM (GB)'="{0:N2}" -f ($cs.totalphysicalmemory / 1GB);
               'Sockets'=$cs.numberoflogicalprocessors}
    
    # creates an instance of an object
    New-Object -TypeName PSObject -Property $props
}


#Get-InfoCompSystem -ComputerName 'localhost'