 $pscredential = Get-Credential
 $tenantId = 'tttttttt';
 Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId
 
  ### Create SP and assign a contributor role to VM. Owner role for KeyVault.
 ### Add All permissions to the SP.
 ### port 80 and 443
 
 $KVRGname = 'VMDiskEncryptionDemoRG';

 $VMRGName = 'VMDiskEncryptionDemoRG';

 $vmName = 'xxxxxxxxxxx';

 $KeyVaultName = 'xxxxxxxxxxx';

 $KeyVault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $KVRGname;

 $diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;

 $KeyVaultResourceId = $KeyVault.ResourceId;


 Set-AzVMDiskEncryptionExtension -ResourceGroupName $VMRGname -VMName $vmName -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId;


 Get-AzVmDiskEncryptionStatus -ResourceGroupName  $VMRGName -VMName  $vmName