Clear-Host
Set-Location D:\
New-Item -Name azure-repos -ItemType Directory
Set-Location D:\azure-repos
git clone https://github.com/Azure/azure-quickstart-templates
Set-Location D:\azure-repos\azure-quickstart-templates
Get-Childitem
