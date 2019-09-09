Clear-Host


$VMName = "Spoke2VM1"
$computer = "Spoke2VM1"
$VMSize = "Standard_B1ls"
$vnetName = ‘Spoke2Vnet’ 
$RG = ‘Spoke2RG’ 
$subnetName = ‘WorkloadSubnet’ 
$nicName = ‘Spoke2VM1-nic1’ 
$location = ‘South India’ 
$ipAddress = ’13.0.2.10’
$dataDiskName = "Spoke2VM1-data-disk1"


$publisherName = "MicrosoftWindowsServer"
$offer= "WindowsServer"
$sku= "2016-Datacenter"
$version = "latest"







$VNetAddressPrefix="13.0.0.0/16"
$subNet1AddressPrefix="13.0.1.0/24"
$subNet2AddressPrefix="13.0.2.0/24"
 
$subNet1Name="ManagementSubnet"
$subNet2Name="WorkloadSubnet"
 





$demoRG = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $RG}
if (-not $demoRG) {
   Write-Host  'creating new resource group'

  $demoRG = New-AzureRmResourceGroup -Location 'South India' -Name $RG
}


$vmConfig = $demoRG | New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize 
Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName $publisherName -Offer $offer -Skus $sku -Version $version

#$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = Get-Credential "LocalAdmin" 
#$cred = New-Object System.Management.Automation.PSCredential ("azureuser", $securePassword)
Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -Credential $cred -ComputerName $computer  

 

$virtualNet = $demoRG | Get-AzureRmVirtualNetwork -Name $vnetName


if (-not $virtualNet) {
Write-Host 'Creating Virtual Network '

$virtualNet = $demoRG | New-AzureRmVirtualNetwork  -Name $vnetName -AddressPrefix $VNetAddressPrefix 
$subNet1 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet1Name -AddressPrefix $subNet1AddressPrefix
$subNet2 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet2Name -AddressPrefix $subNet2AddressPrefix
 
Set-AzureRmVirtualNetwork -VirtualNetwork $virtualNet

}

### Choose the subnet where the VM to be deployed 

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
#$sshPublicKey = cat ~/.ssh/id_rsa.pub
#Add-AzureRmVMSshPublicKey -VM $vmConfig  -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"

### Launch VM

$demoRG | New-AzureRmVM -VM $vmConfig

