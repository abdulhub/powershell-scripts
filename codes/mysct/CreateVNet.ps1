$NetRG = Get-AzureRmResourceGroup -Location "south india" -Name "NetRG"
$NetRG
if (-not $NetRG) {
    $NetRG = New-AzureRmResourceGroup   -Location "south india" -Name "NetRG" 
    }
# Create a Virtual network called "demoNet"
$vNet = $NetRG |  New-AzureRmVirtualNetwork -Name "demoNet" -AddressPrefix "10.100.0.0/16"

# How to modify a resource, add tags
$vNet
$vNet.Tag = @{Purpose = "demo"}
$vNet

# Till, we have modified the object alone locally in $vNet
# Ensure to set this changes in Azure 

# Check whethere these changes are updated in azure? Ans "NO" Tag value is Blank

$vNetInAzure = $NetRG | Get-AzureRmVirtualNetwork
$vNetInAzure

# Commit the changes in Azure from locally done in $vNet

$vNet | Set-AzureRmVirtualNetwork


# Create SubNets

$vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "frontend" -AddressPrefix "10.100.0.0/24"
$vNet | Add-AzureRmVirtualNetworkSubnetConfig -Name "backend" -AddressPrefix "10.100.2.0/24"


# Till now, the subnets are added to locally in the $vNet Object
# For demonstration, see what is inside $vNetInAzure
# subnets would be blank

$vNetInAzure

# Commit the changes in Azure from locally done in $vNet

$vNet | Set-AzureRmVirtualNetwork 

# View all Subnets iterating the LIST

$vNetInAzure = $NetRG | Get-AzureRmVirtualNetwork

$vNetInAzure.Subnets | Select-Object  Name, AddressPrefix






##### How to modify Virtual Networks  


$vNet | Set-AzureRmVirtualNetworkSubnetConfig -Name "backend" -AddressPrefix "10.100.100.0/24"
$Sub1 = Get-AzureRmVirtualNetworkSubnetConfig -Name "sub1" -VirtualNetwork $vNet

# How to remove a subnet
$vNet | Remove-AzureRmVirtualNetworkSubnetConfig -Name "sub1" 