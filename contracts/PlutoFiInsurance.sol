// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @custom:dev-run-script ./scripts/deploy.js
contract PlutoFiInsurance is Ownable, ReentrancyGuard {
   IERC20 public immutable stablecoin;
   uint256 public constant PREMIUM_BPS = 200; // 2%
   uint256 public constant COVERAGE_BPS = 9500; // 95%

   struct Policy {
       uint256 premiumPaid;
       uint256 coverageAmount;
       bool active;
       bool paidOut;
   }

   mapping(address => Policy) public policies;

   constructor
(address _stablecoin) {
       stablecoin = IERC20(_stablecoin);
   }

   function buyPolicy(uint256 _coverageAmount) external nonReentrant {
       require(!policies[msg.sender].active, "Policy exists");
       uint256 premium = (_coverageAmount * PREMIUM_BPS) / 10_000;
       stablecoin.transferFrom(msg.sender, address(this), premium);

       policies[msg.sender] = Policy({
           premiumPaid
: premium,
           coverageAmount: _coverageAmount,
           active: true,
           paidOut: false
       });
   }

   function payOut(address _farmer) external onlyOwner nonReentrant {
       Policy storage p = policies[_farmer];
       require(p.active, "No policy");
       require(!p.paidOut, "Already paid");

       p.paidOut


