Login-AzureRmAccount
Enable-AzureRmContextAutosave
Clear-Host

$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
ssh-keygen -t rsa -b 2048
