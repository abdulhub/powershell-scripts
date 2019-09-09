﻿Clear-Host


$VMName = "BACKEND-VM1"
$computer = "BACKEND-PVM1"
$VMSize = "Standard_A0"
$vnetName = ‘demoVNet’ 
$RG = ‘DemoRG’ 
$subnetName = ‘backend’ 
$nicName = ‘BACKEND-VM1-NIC1’ 
$location = ‘South India’ 
$ipAddress = ’10.0.2.11’
$dataDiskName = "BACKEND-VM1-DATA-DISK1"


$publisherName = "Canonical"
$offer= "UbuntuServer"
$sku= "16.04-LTS"
$version = "latest"







$VNetAddressPrefix="10.0.0.0/16"
$subNet1AddressPrefix="10.0.1.0/24"
$subNet2AddressPrefix="10.0.2.0/24"
$subNet1Name="webend"
$subNet2Name="backend"





$demoRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $RG}
if (-not $demoRG) {
   Write-Host  'creating new resource group'

  $demoRG = New-AzureRmResourceGroup -Location 'South India' -Name $RG
}


$vmConfig = $demoRG | New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize 
Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName $publisherName -Offer $offer -Skus $sku -Version $version

$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("azureuser", $securePassword)
Set-AzureRmVMOperatingSystem -VM $vmConfig -Linux -Credential $cred -ComputerName $computer -DisablePasswordAuthentication 

 

$virtualNet = $demoRG | Get-AzureRmVirtualNetwork -Name $vnetName


if (-not $virtualNet) {
Write-Host 'Creating Virtual Network '

$virtualNet = $demoRG | New-AzureRmVirtualNetwork  -Name $vnetName -AddressPrefix $VNetAddressPrefix 
$subNet1 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet1Name -AddressPrefix $subNet1AddressPrefix
$subNet2 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet2Name -AddressPrefix $subNet2AddressPrefix
Set-AzureRmVirtualNetwork -VirtualNetwork $virtualNet

}


if ($virtualNet) {
  $subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNet).Id

}


$nic = $demoRG | Get-AzureRmNetworkInterface -Name $nicName 
if(-not $nic) {
 $nic = $demoRG | New-AzureRmNetworkInterface -Name $nicName -SubnetId $subnetID -PrivateIpAddress $ipAddress 

}


#  Attach NIC1 to VM
Add-AzureRmVMNetworkInterface -VM $vmConfig -NetworkInterface $nic

## Choose storage

$dataDisk   = $demoRG | Get-AzureRmDisk -DiskName $dataDiskName
 

if(-not $dataDisk) {

$dataDiskConfig = $demoRG | New-AzureRmDiskConfig -SkuName Standard_LRS -OsType Linux `
-DiskSizeGB 10 -CreateOption "Empty"
$dataDisk   = $demoRG | New-AzureRmDisk -DiskName $dataDiskNAme -Disk  $dataDiskConfig
Add-AzureRmVMDataDisk -VM $vmConfig -ManagedDiskId $dataDisk.Id -Name $dataDiskName `
  -Lun 1 -CreateOption "Attach"

}

# Configure the SSH key
$sshPublicKey = cat ~/.ssh/id_rsa.pub
Add-AzureRmVMSshPublicKey -VM $vmConfig  -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"

### Launch VM

$demoRG | New-AzureRmVM -VM $vmConfig

