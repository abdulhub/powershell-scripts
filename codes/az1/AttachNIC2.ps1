$NetRG = Get-AzureRmResourceGroup  -Name NetRG
$NetRG

$SimpleVM = $NetRG | Get-AzureRMVM  -Name web2017
$SimpleVM.Name

$SimpleVM.HardwareProfile.VmSize
$NewSize = "Standard_DS2_v2"
$SimpleVM.HardwareProfile.VmSize = $NewSize
$SimpleVM.HardwareProfile.VmSize


$NetRG = Get-AzureRMResourceGroup "NetRG"
$DemoNet = $NetRG | Get-AzureRMVirtualNetwork  -Name "demoNet"
$Sub1 = $DemoNet.Subnets[0]
$NIC2 = $NetRG | New-AzureRmNetworkInterface -Name "Nic2" -SubnetId $Sub1.Id
$NIC2

$SimpleVM = $NetRG | Get-AzureRMVM  -Name web2017
$SimpleVM.Name

Add-AzureRmVMNetworkInterface -VM $SimpleVM -NetworkInterface $NIC2 

$SimpleVM.NetworkProfile.NetworkInterfaces[0].Primary = $true
$SimpleVM.NetworkProfile.NetworkInterfaces[1].Primary = $false

$SimpleVM.NetworkProfile.NetworkInterfaces[0]
$SimpleVM.NetworkProfile.NetworkInterfaces[1]

 





$SimpleVM | Update-AzureRmVM -AsJob