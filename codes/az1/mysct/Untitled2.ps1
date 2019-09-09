#Get-AzureRMVMImageSku -Location "South India" -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer"


$vnetName = ‘DemoVnet2’ 
$RG = ‘VnetPeering’ 
$subnetName = ‘firewall’ 
$nicName = ‘FIREWALL-VM-NIC1’ 
$ipAddress = ’10.2.3.10'
$IpConfigName1 = "IPConfig1"

$demoRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $RG}
$Ip1 = $demoRG | New-AzureRmPublicIpAddress -Name "pip-firewallvm"   -AllocationMethod Dynamic  
$Ip1


$virtualNet = $demoRG | Get-AzureRMVirtualNetwork  -Name $vnetName 
$subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNet).Id
$nic = $demoRG | Get-AzureRmNetworkInterface -Name $nicName
 


 Set-AzureRmNetworkInterfaceIpConfig -Name $IpConfigName1 `
 -NetworkInterface $nic -PrivateIpAddress $ipAddress -SubnetId $subnetID  `
 -PublicIpAddressId $Ip1.Id




 #Add-AzureRMNetworkInterfaceIpConfig -Name $IpConfigName1 `
 # -NetworkInterface $nic  `
  #-SubnetId $subnetID  -PrivateIpAddress $ipAddress `
  #-PublicIpAddressId  $Ip1.Id  
  

 
 


  Set-AzureRmNetworkInterface -NetworkInterface $nic 

 


