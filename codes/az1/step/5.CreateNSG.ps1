## Create Resource Group
Get-AzureRmResourceGroup
$NetRG = Get-AzureRmResourceGroup |  where-object {$_.ResourceGroupName -EQ "NetRG"}
$NetRG

###  Know the syntax of Application Security groups

Get-Command   New-AzureRmApplicationSecurityGroup -Syntax

## Create Application Security Groups

$WebGroup = $NetRG | New-AzureRmApplicationSecurityGroup -Name "Allow-Internet-To-Web-Role"
$AppGroup = $NetRG | New-AzureRmApplicationSecurityGroup -Name "Allow-Web-To-App-Role"

### Create Network Security config   and check the synatx

Get-Command New-AzureRmNetworkSecurityRuleConfig -Syntax

$webRule =  New-AzureRmNetworkSecurityRuleConfig -Name "Allow-Web"  -Description "Allow tcp traffic from internet" -Direction Inbound -Access Allow -SourceAddressPrefix Internet -SourcePortRange * -DestinationApplicationSecurityGroup $WebGroup -DestinationPortRange 80,443  -Priority 200
$webRule


$sqlRule = New-AzureRmNetworkSecurityRuleConfig -Name "Allow-Sql" -Description "Webs to Sql traffic" `
-Direction Inbound -Access Allow  `
-Protocol Tcp `
-SourceApplicationSecurityGroup $WebGroup -SourcePortRange * `
-DestinationApplicationSecurityGroup $AppGroup -DestinationPortRange 1433 `
-Priority 300

  # Add the Configuration to NSG

  Get-Command New-AzureRmNetworkSecurityGroup -Syntax

  $NetRG | New-AzureRmNetworkSecurityGroup -Name "Environment" -SecurityRules $webSecurityRuleConfig


  $NetRG | New-AzureRmNetworkSecurityGroup -Name "WsssssssebEnvironment"  -SecurityRules $webRule, $sqlRule
  $webRule
  $sqlRule
 




                                                                                             


