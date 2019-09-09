Clear-Host
Set-Location D:\azure-repos\azure-quickstart-templates
New-AzureRmResourceGroup -Name "ARMTemplateDemoRG" -Location "South India"
New-AzureRmResourceGroupDeployment -Name "VMFromTemplate" -ResourceGroupName ARMTemplateDemoRG `
-TemplateParameterFile .\6.2-azuredeploy.parameters.json -TemplateFile .\6.2-azuredeploy.json -Verbose
Get-AzureRmVM -ResourceGroupName ARMTemplateDemoRG -Status