SPDX-License-Identifier: MIT
pragma import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@api
contract PlutoFiLandOracle is Ownable, ReentrancyGuard {
IAirnodeRrp public immutable airnodeRrp;
uint256 public constant LAND_PRICE = 2950e18;
constructor(address
function getLandValue(uint256 hectares) public view returns (uint256)
{
return hectares * LAND_PRICE; // €2,950/haMAG Paraguay
    }
}
