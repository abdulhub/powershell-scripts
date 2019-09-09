Clear-Host


$demoRG = New-AzureRmResourceGroup -Name "DemoRG" -Location "south india"
## Choose VM size
$VMSize = Get-AzureRMVMSize -Location "southindia" | Out-GridView -Title "Choose a VM Size" -PassThru 
$VMSize
#$publisherName = Get-AzureRmVMImagePublisher -Location 'South India' | Out-GridView -Title "Choose a VM Image publisher" -PassThru
#$publisherName
#$sampleImage = Get-AzureRmVMImage -Location "south india" -PublisherName  | Out-GridView -Title "Choose a VM Image" -PassThru
#$sampleImage

#Get-Help Get-AzureRmVMImage -Online


$vmConfig = $demoRG | New-AzureRmVMConfig -VMName "webapp1VM" -VMSize "Standard_A0" 
## Choose the Image
## Choose the image
#Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04-LTS" -Version "latest"
## Choose OS 
$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("azureuser", $securePassword)
Set-AzureRmVMOperatingSystem -VM $vmConfig -Linux -Credential $cred -ComputerName "webapp1" -DisablePasswordAuthentication 
## Choose Networking Or Create VNet Object
$vNet = $demoRG | New-AzureRmVirtualNetwork  -Name "demoVNet" -AddressPrefix "10.0.0.0/16" 
$subNet1 = $vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "webend" -AddressPrefix "10.0.1.0/24"
$subNet2 = $vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "backend" -AddressPrefix "10.0.2.0/24"
Set-AzureRmVirtualNetwork -VirtualNetwork $vNet
 



$vnetName = ‘demoVNet’ 
$RG = ‘DemoRG’ 
$subnetName = ‘webend’ 
$nicName = ‘DemoVM-NIC1’ 
$location = ‘South India’ 
$ipAddress = ’10.0.1.10’

 

$subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet).Id
$nic = $demoRG | New-AzureRmNetworkInterface -Name $nicName -SubnetId $subnetID -PrivateIpAddress $ipAddress
 
     #  Attach NIC1 to VM
Add-AzureRmVMNetworkInterface -VM $vmConfig -NetworkInterface $nic

## OPtional
## Choose NSG

$nsgRuleConfig1 = New-AzureRmNetworkSecurityRuleConfig -Name "Allow-SSH" -Description "Allow  SSH" `
    -Protocol Tcp    -Access Allow -Direction Inbound  `
    -SourcePortRange * -SourceAddressPrefix * `
    -DestinationPortRange 22 -DestinationAddressPrefix * `
    -Priority 300

$nsg1 = $demoRG | New-AzureRmNetworkSecurityGroup -SecurityRules $nsgRuleConfig1 -Name "nsg-web" 

Set-AzureRmVirtualNetworkSubnetConfig -Name "webend" -NetworkSecurityGroup $nsg1

## Choose storage

$dataDiskConfig = $demoRG | New-AzureRmDiskConfig -SkuName Standard_LRS -OsType Linux `
-DiskSizeGB 10 -CreateOption "Empty"
$dataDisk   = $demoRG | New-AzureRmDisk -DiskName "datadisk1" -Disk  $dataDiskConfig
Add-AzureRmVMDataDisk -VM $vmConfig -ManagedDiskId $dataDisk.Id -Name "datadisk1" `
  -Lun 1 -CreateOption "Attach"

## Create SSH Public Key
# Configure the SSH key
$sshPublicKey = cat ~/.ssh/id_rsa.pub
Add-AzureRmVMSshPublicKey -VM $vmConfig  -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"

### Launch VM

$demoRG | New-AzureRmVM -VM $vmConfig









                  



