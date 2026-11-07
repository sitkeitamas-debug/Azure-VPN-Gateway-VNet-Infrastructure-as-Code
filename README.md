# Azure VPN Gateway és VNet Infrastruktúra mint Kód (Terraform)

Ez a projekt egy Terraform konfigurációt tartalmaz, amely egy biztonságos, éles környezetre kész hub hálózati architektúrát hoz létre a Microsoft Azure-ban, a felhőbeli hálózati best practice-ek alapján.

## 🏗️ Architektúra Összetevői
- **Resource Group (Erőforráscsoport)**: `rg-vpn-lab-northeurope` (Észak-Európa régiónak megfelelően telepítve)
- **Virtual Network (VNet)**: `vnet-hub-corp` (`10.100.0.0/16`)
- **Gateway Subnet**: `GatewaySubnet` (`10.100.255.0/27` – szigorúan az Azure átjáró telepítési követelményei szerint elnevezve)
- **Public IP (Nyilvános IP)**: Statikus Standard SKU IP-cím (`pip-vpngw-hub`)
- **Virtual Network Gateway**: Útvonalalapú (Route-based) VPN-átjáró (`VpnGw1AZ` zónaredundáns SKU), biztonságos telephelyek közötti (site-to-site) kapcsolathoz kialakítva.

## 🛠️ Előfeltételek
- Telepített [Terraform](https://www.terraform.io/) (>= 1.0.0)
- Telepített és hitelesített [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) (`az login`)

## 🚀 Telepítési Lépések

1. Klónozd a repository-t:
   ```bash
   git clone (https://github.com/sitkeitamas-debug/Azure-VPN-Gateway-VNet-Infrastructure-as-Code.git)
   cd Azure-VPN-Gateway-VNet-Infrastructure-as-Code
