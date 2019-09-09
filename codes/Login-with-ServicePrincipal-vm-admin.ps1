$tenantId = "b4427580-24af-4037-b9c8-261e6b1ccb99"
$pscredential = Get-Credential
Connect-AzureRmAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId
$vm = Get-AzureRmVM  
Start-AzureRmVM -Name $vm.Name  -ResourceGroupName $vm.ResourceGroupName