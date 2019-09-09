Clear-Host


$VMName = "app-VM1"
$computer = "app-VM1"
$VMSize = "Standard_A0"
$vnetName = ‘demoVNet’ 
$RG = ‘DemoRG’ 
$subnetName = ‘backend’ 
$nicName = ‘app-nic1’ 
$location = ‘South India’ 
$ipAddress = ’10.0.2.10’
$dataDiskName = "app-datadisk2"


$publisherName = "Canonical"
$offer= "UbuntuServer"
$sku= "16.04-LTS"
$version = "latest"


          

$demoRG =  Get-AzureRmResourceGroup -Name $RG -Location $location

#$demoRG = New-AzureRmResourceGroup -Name $RG -Location $location
 

$vmConfig = $demoRG | New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize 
Set-AzureRmVMSourceImage -VM $vmConfig    -PublisherName $publisherName -Offer $offer -Skus $sku -Version $version

$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("azureuser", $securePassword)
Set-AzureRmVMOperatingSystem -VM $vmConfig -Linux -Credential $cred -ComputerName $computer -DisablePasswordAuthentication 

$virtualNet = $demoRG | Get-AzureRmVirtualNetwork -Name $vnetName
$subnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNet).Id
$nic = $demoRG | New-AzureRmNetworkInterface -Name $nicName -SubnetId $subnetID -PrivateIpAddress $ipAddress
 
     #  Attach NIC1 to VM
Add-AzureRmVMNetworkInterface -VM $vmConfig -NetworkInterface $nic



## Choose storage
 $sshPublicKey = cat ~/.ssh/id_rsa.pub
Add-AzureRmVMSshPublicKey -VM $vmConfig  -KeyData $sshPublicKey -Path "/home/azureuser/.ssh/authorized_keys"

### Launch VM

$demoRG | New-AzureRmVM -VM $vmConfig





 
# Configure the SSH key
