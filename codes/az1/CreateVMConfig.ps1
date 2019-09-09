Clear-Host

Get-AzureRMVMImageSku -Location "South India" -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer"


# Choose a size for the VM

Get-AzureRMVMSize -Location 'East US'
Get-AzureRMVMSize -Location 'East US' | Where-Object {$_.MemoryInMB -eq 8GB/1MB -and $_.NumberOfCores -eq 2}
$VMSize = Get-AzureRMVMSize -Location "southindia" | Out-GridView -Title "Choose a VM Size" -PassThru 
$VMSize

# Choose other options
# - Username / password for admin account
$AdminLogin = Get-Credential "LocalAdmin" 

# - Network settings
$NetRG = Get-AzureRMResourceGroup "NetRG"
$DemoNet = $NetRG | Get-AzureRMVirtualNetwork  -Name "DemoNet"
$Sub0 = $DemoNet.Subnets[0]
$WebGroup = $NetRG | Get-AzureRMApplicationSecurityGroup -Name "WebRole"
$WebGroup.Id

$NIC = $NetRG | New-AzureRmNetworkInterface -ApplicationSecurityGroupId $WebGroup.Id -Name "WEBVM-Nic" -SubnetId $Sub0.Id
$NIC


# Building a VM with the fewest possible inputs
# New-AzureRmVM -Name "SimpleVM" -Credential $AdminLogin



# Building a VM with a full selection of options
# Start with a VM Configuration
$VMSet = New-AzureRmVMConfig -VMName "web2017" -VMSize $VMSize.Name

# Configure the operating system
Set-AzureRmVMOperatingSystem -VM $VMSet -Windows -ComputerName "WEB2017" -Credential $AdminLogin


# Configure the network 
Add-AzureRmVMNetworkInterface -VM $VMSet -Id $NIC.Id

# Choose the image
Set-AzureRmVMSourceImage -VM $VMSet    -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"

# 
$diskSet = New-AzureRmDiskConfig -Location "southindia" -DiskSizeGB 1024 -CreateOption Empty 
$webDisk = $NetRG | New-AzureRMDisk -DiskName "WebDataDisk" -Disk $diskSet


Add-AzureRmVMDataDisk -VM $VMSet -Name "webDataDisk" -CreateOption Attach -ManagedDiskId $webDisk.Id -Lun 1

#Use the resource group variable to set the resource group and location... VM Configuration holds the rest
$NetRG | New-AzureRMVM -VM $VMSet 


New-AzureRMVM -ResourceGroupName "VMRG" -Location "eastus" -Name "JumpBox" `
 -VirtualNetworkName "demoNet" -SubnetName "sub1" -AllocationMethod Static -DomainNameLabel "demojumpbox2018" `
 -OpenPorts 3389 -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest" `
 -Credential $AdminLogin -Size $VMSize.Name -DataDiskSizeInGb 200 `
 -AsJob


$VMRG | Remove-AzureRMResourceGroup -Whatif




Get-Help Get-AzureRmVMImagePublisher -Online
Get-Help New-AzureRmVMConfig
Get-Help New-AzureRMVM -Online 
Get-Help Get-AzureRMVMSize -Online

