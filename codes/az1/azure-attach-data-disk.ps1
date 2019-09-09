$RG = ‘DemoRG’ 
$dataDiskName = "app-datadisk2"

$demoRG =  Get-AzureRmResourceGroup -Name $RG -Location $location

$vmConfig = $demoRG | Get-AzureRmVM -Name "app-VM1"

$dataDiskConfig = $demoRG | New-AzureRmDiskConfig -SkuName Standard_LRS -OsType Linux `
-DiskSizeGB 10 -CreateOption "Empty"
$dataDisk   = $demoRG | New-AzureRmDisk -DiskName $dataDiskName -Disk  $dataDiskConfig
Add-AzureRmVMDataDisk -VM $vmConfig -ManagedDiskId $dataDisk.Id -Name $dataDiskName `
  -Lun 1 -CreateOption "Attach"

 

$demoRG | Update-AzureRmVM -VM $vmConfig

