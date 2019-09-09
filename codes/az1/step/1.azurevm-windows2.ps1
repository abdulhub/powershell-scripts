Clear-Host


$VMName = "FIREWALL-VM1"
$computer = "FIREWALL-PVM1"
$VMSize = "Standard_B1ls"
$vnetName = ‘DemoVnet2’ 
$RG = ‘VnetPeering’ 
$subnetName = ‘FIREWALL’ 
$nicName = ‘FIREWALL-VM-NIC1’ 
$location = ‘South India’ 
$ipAddress = ’10.2.3.10’
$dataDiskName = "FIREWALL-VM-DATA-DISK1"


$publisherName = "MicrosoftWindowsServer"
$offer= "WindowsServer"
$sku= "2016-Datacenter"
$version = "latest"







$VNetAddressPrefix="10.2.0.0/16"
$subNet1AddressPrefix="10.2.1.0/24"
$subNet2AddressPrefix="10.2.2.0/24"
$subNet3AddressPrefix="10.2.3.0/24"
$subNet1Name="webend"
$subNet2Name="backend"
$subNet3Name="firewall"





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

$virtualNet = $demoRG | New-AzureRmVirtualNetwork  -Name $vnetName -AddressPrefix $VNetAddressPrefix  }


$subNet1 = $virtualNet | Get-AzureRmVirtualNetworkSubnetConfig -Name $subNet1Name 
$subNet2 = $virtualNet | Get-AzureRmVirtualNetworkSubnetConfig -Name $subNet2Name 
$subNet3 = $virtualNet | Get-AzureRmVirtualNetworkSubnetConfig -Name $subNet3Name 

if (-not $subNet1) { Write-Host 'Creating Sub1 Network '
     $subNet1 = $virtualNet | Set-AzureRmVirtualNetworkSubnetConfig -Name $subNet1Name -AddressPrefix $subNet1AddressPrefix  
                  }
if (-not $subNet2) {   Write-Host 'Creating Sub2 Network '
$subNet2 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet2Name -AddressPrefix $subNet2AddressPrefix      }
if (-not $subNet3) {   Write-Host 'Creating Sub3 Network '
$subNet3 = $virtualNet | Add-AzureRmVirtualNetworkSubnetConfig -Name $subNet3Name -AddressPrefix $subNet3AddressPrefix      }

Set-AzureRmVirtualNetwork -VirtualNetwork $virtualNet



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

