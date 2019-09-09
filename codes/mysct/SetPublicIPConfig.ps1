Get-Command  -Name *PublicIp* -Module AzureRM*

Get-Command  Set-AzureRmPublicIpAddress -Syntax

$NetRG = Get-AzureRMResourceGroup "NetRG"


$NetRG = Get-AzureRMResourceGroup "NetRG"
$DemoNet = $NetRG | Get-AzureRMVirtualNetwork  -Name "DemoNet"
$Sub0 = $DemoNet.Subnets[0]

$NSG = $NetRG | Get-AzureRmNetworkSecurityGroup -Name "AppEnvironment"
$NSG 


$Ip1 = $NetRG | New-AzureRmPublicIpAddress -Name myVMPublicIP   -AllocationMethod Dynamic  
$Ip1
# Create a public IP address
$PublicIP1 = $NetRG | New-AzureRmPublicIpAddress -Name "Web2017IP1" -AllocationMethod Dynamic
$PublicIP1.IpAddress
#Create an IP configuration 

$IpConfigName1 = "IPConfig-1"

 $IpConfig1     = New-AzureRMNetworkInterfaceIpConfig `
 -Name $IpConfigName1 `
 -Subnet $Subnet `
 -PrivateIpAddress 10.0.0.4 `
 -PublicIpAddress $PublicIP1 `
 -Primary

  $IpConfig1.PublicIpAddress


 $IpConfig1 = New-AzureRmNetworkInterfaceIpConfig -Name $IpConfigName1 -SubnetId  $Sub0.Id -PrivateIpAddress 10.100.0.4 `
                                     -PublicIpAddressId $PublicIP1.Id -Primary

 $IpConfig1.PublicIpAddress
$NICRDP = $NetRG | New-AzNetworkInterface `
-Name MyRDPNIC `
-NetworkSecurityGroupId $NSG.Id `
-IpConfiguration $IpConfig1


$VmConfig = $NetRG | Get-AzureRmVM -Name "web2017"
 $VmConfig

  Set-AzureRmNetworkInterface -NetworkInterface  $NICRDP  -
 
   

 