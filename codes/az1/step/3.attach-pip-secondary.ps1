$vnetName = ‘demoVNet’ 
$RG = ‘DemoRG’ 
$subnetName = ‘backend’ 
$nicName = ‘BACKEND-VM1-NIC1’ 
$ipAddress = ’10.0.2.12’

$demoRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $RG}
$Ip1 = $demoRG | New-AzureRmPublicIpAddress -Name "pip2"   -AllocationMethod Dynamic  
$Ip1


$virtualNet = $demoRG | Get-AzureRMVirtualNetwork  -Name $vnetName 
$subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNet).Id
$nic = $demoRG | Get-AzureRmNetworkInterface -Name $nicName
 

 $IpConfigName1 = "IPConfig2"
# Set-AzureRmNetworkInterfaceIpConfig -Name $IpConfigName1 `
# -NetworkInterface $nic -PrivateIpAddress $ipAddress -SubnetId $subnetID  `
# -PublicIpAddressId $Ip1.Id




 Add-AzureRMNetworkInterfaceIpConfig -Name $IpConfigName1 `
  -NetworkInterface $nic  `
  -SubnetId $subnetID  -PrivateIpAddress $ipAddress `
  -PublicIpAddressId  $Ip1.Id  
  

 
 


  Set-AzureRmNetworkInterface -NetworkInterface $nic 

 


