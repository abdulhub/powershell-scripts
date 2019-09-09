 Connect-AzAccount

 
 ### Add All permissions to the SP.
 ### port 80 and 443
 
 $KVRGname = 'VMDiskEncryptionDemoRG';

 $VMRGName = 'VMDiskEncryptionDemoRG';

 $vmName = 'xxxxxx';

 $KeyVaultName = 'xxxxxxx';

 $KeyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $KVRGname;

 $diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;

 $KeyVaultResourceId = $KeyVault.ResourceId;


 Set-AzVMDiskEncryptionExtension -ResourceGroupName $VMRGname -VMName $vmName -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId;


 Get-AzVmDiskEncryptionStatus -ResourceGroupName  $VMRGName -VMName  $vmName