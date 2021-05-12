Param
(   
    [Parameter(Mandatory=$false)]
    [String]
    $AzureResourceGroup,
    [Parameter(Mandatory=$true)][ValidateSet("Start","Stop")]
    [String]
    $Action
)

if($AzureResourceGroup -eq $null -Or $AzureResourceGroup -eq "")
{
    $AzureResourceGroup = Get-AutomationVariable -Name 'Internal_ResourceGroupName'
}

$credential = Get-AutomationPSCredential -Name 'SelfCredential'
Connect-AzAccount -Credential $credential
$selectedsubscription = Get-AutomationVariable -Name 'Internal_AzureSubscriptionId'

if($Action -eq "Stop")
{
    Write-Output "Stopping VMSS in '$($AzureResourceGroup)' resource group";
    foreach ($name in (Get-AzVmss -ResourceGroupName $AzureResourceGroup).Name)
    {
        Write-Output "$($name)"
        Stop-AzVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $name -Force
    }
}
else
{
    Write-Output "Starting VMSS in '$($AzureResourceGroup)' resource group";
    foreach ($name in (Get-AzVmss -ResourceGroupName $AzureResourceGroup).Name)
    {
        Start-AzVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $name
    }
}
