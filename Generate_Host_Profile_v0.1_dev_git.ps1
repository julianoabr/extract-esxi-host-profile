$hostListName = @()

$hostListName = (Get-Content -Path "V:\BOX\INPUT\VSPHERE\Host\HostList.txt")

[System.String]$prefix = 'hostProfile'

foreach ($hostName in $HostListName)
{
    
    $refHost = VMware.VimAutomation.Core\Get-VMHost -Name $hostName -Verbose

    $shortHostName = $hostName.Split('.')[0]

    [System.String]$prfName = $shortHostName + '_' + $prefix

    [System.String]$prfDescription = "This is the extracted profile for ESXi Host called: $hostname"

    $cimSlpRole = Get-VMHostFirewallException -VMHost $refHost | Where-Object -FilterScript {$PSItem.Name.StartsWith('CIM SLP')}

    [System.Boolean]$cimClpRoleStatus = $cimSlpRole.Enabled

    if ($cimClpRoleStatus){
    
         New-VMHostProfile -Name $prfName -Description $prfDescription -ReferenceHost $refHost -Confirm:$false -Verbose
    
    }#end of IF
    else{
    
        $cimSlpRole | Set-VMHostFirewallException -Enabled $true -Confirm:$false -Verbose

        Start-Sleep -Seconds 2 -Verbose

        New-VMHostProfile -Name $prfName -Description $prfDescription -ReferenceHost $refHost -Confirm:$false -Verbose

        Start-Sleep -Seconds 5 -Verbose

        $cimSlpRole | Set-VMHostFirewallException -Enabled $false -Confirm:$false -Verbose
        
    }#end of Else
   

    Start-Sleep -Seconds 4 -Verbose
}


