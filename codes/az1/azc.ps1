Clear-Host


$VMName = "app1VM"
$computer = "app1VM"
$VMSize = "Standard_A0"
$vnetName = ‘demoVNet’ 
$RG = ‘DemoRG’ 
$subnetName = ‘backend’ 
$nicName = ‘app-nic1’ 
$location = ‘South India’ 
$ipAddress = ’10.0.3.10’
$dataDisk = "app1vm-datadisk"


$publisherName = "Canonical"
$offer= "UbuntuServer"
$sku= "16.04-LTS"
$version = "latest"


$demoRG = New-AzureRmResourceGroup -Name $RG -Location $location
## Choose VM size
#$VMSize = Get-AzureRMVMSize -Location $location | Out-GridView -Title "Choose a VM Size" -PassThru 
#$VMSize
#$publisherName = Get-AzureRmVMImagePublisher -Location 'South India' | Out-GridView -Title "Choose a VM Image publisher" -PassThru
#$publisherName
#$sampleImage = Get-AzureRmVMImage -Location "south india" -PublisherName  | Out-GridView -Title "Choose a VM Image" -PassThru
#$sampleImage

#Get-Help Get-AzureRmVMImage -Online


$vmConfig = $demoRG | New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize 
## Choose the Image
## Choose the image
#Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName $publisherName -Offer $offer -Skus $sku -Version $version
## Choose OS 
$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("azureuser", $securePassword)
Set-AzureRmVMOperatingSystem -VM $vmConfig -Linux -Credential $cred -ComputerName "webapp1" -DisablePasswordAuthentication 
## Choose Networking Or Create VNet Object


$subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet).Id
$nic = $demoRG | New-AzureRmNetworkInterface -Name $nicName -SubnetId $subnetID -PrivateIpAddress $ipAddress
 
     #  Attach NIC1 to VM
Add-AzureRmVMNetworkInterface -VM $vmConfig -NetworkInterface $nic



## Choose storage

$dataDiskConfig = $demoRG | New-AzureRmDiskConfig -SkuName Standard_LRS -OsType Linux `
-DiskSizeGB 10 -CreateOption "Empty"
$dataDisk   = $demoRG | New-AzureRmDisk -DiskName $dataDisk -Disk  $dataDiskConfig
Add-AzureRmVMDataDisk -VM $vmConfig -ManagedDiskId $dataDisk.Id -Name $dataDisk `
  -Lun 1 -CreateOption "Attach"

## Create SSH Public Key
# Configure the SSH key
$sshPublicKey = cat ~/.ssh/id_rsa.pub
Add-AzureRmVMSshPublicKey -VM $vmConfig  -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"