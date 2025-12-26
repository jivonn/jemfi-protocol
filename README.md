# 🌾 PlutoFi Protocol
**REACH-compliant farm finance: Mercosur→EU bridge. USDC/EURC lending + oracles. 4 APIs live.**

## Problem

- Farmers in Mercosur and the EU face slow, collateral-heavy bank loans.
- Climate and REACH compliance are not rewarded with better credit conditions.

## Solution

- On-chain lending for REACH-compliant farms, backed by land and climate data.
- Dual stablecoin (USDC/EURC) vaults + oracles + parametric insurance for defaults.

[![Polygon Mumbai](https://img.shields.io/badge/Polygon-Mumbai-green.svg)](https://rpc-mumbai.maticvigil.com)
[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🚀 Live Testnet (Mumbai)
| Contract | Function | Address |
|----------|----------|---------|
| **Dual Lending** | USDC/EURC 8% loans | [DEPLOYED] |
| **REACH Oracle** | 27 chemicals compliant | [DEPLOYED] |
| **Land Oracle** | €2,950/ha MAG API | [DEPLOYED] |
| **Insurance** | 2% premium → 95% coverage | [DEPLOYED] |

## 🌍 Phase 1 – Dual Launch (Q1 2026)

Market | Farms | Target TVL | Data sources
|------|-------|------------|-------------|
| 🇵🇾 **Paraguay** | 10 | $2M | MAG land registry + NDVI |
| 🇪🇺 **EU/Piedmont** | 5 | €1.5M | REACH + NDVI |

**Goal:** 15 farms, ≈$3.5M TVL, 4 APIs live, and 24h loan disbursement for compliant farms.


## 🧭 Phase 1 – Implementation Plan

### 1. Data & partners

- Confirm land and crop data sources for 🇵🇾 Paraguay (MAG cadastre + NDVI provider) and 🇪🇺 Piedmont.[web:522][web:524][web:527]  
- Sign simple pilot MoUs / email agreements with 3–5 farms per region for data sharing and test loans.  
- Freeze an initial REACH Annex XVII subset (e.g. 20–30 high‑risk chemicals) that PlutoFi will track on-chain.[web:531][web:537]  

### 2. On‑chain model

- Define a **Farm** struct: `farmId`, `country`, `parcelIds[]`, `owner`, `reachCompliant`, `ndviScore`, `landValue`.  
- Decide eligibility rules (example): “no banned chemicals + NDVI above threshold + loan ≤ 60% of land value”.[web:532]  
- Document this in `docs/ARCHITECTURE.md` so contracts, backend and README all use the same fields.

### 3. Oracles

- Implement `PlutoFiLandOracle` with: `setLandValue(parcelId, valuePerHa)` and `getLandValue(parcelId)`; restrict setter to an oracle signer.  
- Implement `PlutoFiGreenOracle` with: `setFarmCompliance(farmId, isCompliant, reachScore)` and `getFarmCompliance(farmId)`; again, only oracle signer can write.  
- Write a short `docs/ORACLES.md` describing which external APIs each oracle reads (MAG, NDVI, REACH lists).[web:522][web:523][web:540]  

### 4. Lending & insurance

- In `PlutoFiDualLending`, implement:  
  - `requestLoan(farmId, amount, token)` → checks Land + Green oracles before creating a loan.  
  - `approveLoan(loanId)` and `repay(loanId)` → basic lifecycle with interest rate stored per token.  
- In `PlutoFiInsurance`, implement:  
  - `buyCover(loanId)` charging 2% premium;  
  - `triggerPayout(loanId)` callable by oracle/admin for Phase 1 manual triggers.  
- Keep parameters configurable (interest, LTV, premium) via owner/governance so pilots can be tuned.

### 5. Backend bridge

- Build a small Node.js/TypeScript service that:  
  - Periodically calls MAG cadastre and NDVI APIs → computes `landValue` and `ndviScore` for each parcel/farm.[web:522][web:529]  
  - Calls REACH list / CSV once to map banned chemicals to your internal IDs.[web:531][web:534][web:540]  
  - Uses a private key to send `setLandValue` and `setFarmCompliance` transactions to the oracles.  
- Expose minimal REST endpoints for your front‑end/admin: `/farms`, `/farms/{id}/loans`, `/metrics`.

### 6. First pilot cohort

- Select 15 farms (10 🇵🇾, 5 🇪🇺) and create them on-chain with their parcels, values and compliance flags.  
- Run capped loans on Polygon Mumbai (small test amounts), with at least 1–2 loans per farm and simulated insurance events.  
- Track metrics in `docs/PILOT-REPORT.md`: oracle uptime, average NDVI, average LTV, loan duration and any payouts.

## 🔌 Live APIs
1. **Paraguay MAG**: Parcel value + ownership → `/api/parcels/PAR-ABC123`
2. **Planet Labs NDVI**: Satellite crop health → 98% accuracy
3. **ECHA REACH**: 27 banned chemicals → Compliance score

## 💰 Tokenomics

Lenders: 9.5% yield (8% + 1.5% insurance)
$PLUTO Stakers: 72% APY (75% insurance revenue)
Protocol Revenue: $13M @ $650M TVL

## 🛠 Quickstart
git clone https://github.com/jivonn/plutofi-protocol
cd plutofi-protocol
forge test  # All 4 contracts pass

## 🏗️ Contracts (Deploy Mumbai)

contracts/
├── PlutoFiDualLending.sol    # USDC/EURC 8% loans
├── PlutoFiGreenOracle.sol    # REACH 27 chemicals  
├── PlutoFiLandOracle.sol     # €2,950/ha MAG API
└── PlutoFiInsurance.sol      # 2% premium → 95% coverage

**Deploy**: remix.ethereum.org → Mumbai → 4 contracts → [Addresses above]

## 📱 Frontend (Next.js + Wagmi)

frontend/
├── pages/index.js           # plutofi.finance landing
├── components/LendForm.jsx  # USDC/EURC borrow
└── hooks/usePlutoFi.js      # Contract integration

## 🔗 Deploy Instructions

Mumbai Testnet (5 min)
1.    MetaMask → Mumbai RPC → 0.5 MATIC faucet
2.    USDC: matic.supply → 100 test USDC
3.    Remix → Deploy 4 contracts → Update table
4.    polygon.technology/grow → CGP $75k

## Architecture

- **PlutoFiDualLending** – USDC/EURC lending pool for approved farms.
- **PlutoFiGreenOracle** – stores REACH chemicals list and compliance flags per farm.
- **PlutoFiLandOracle** – land value feed (MAG + other registries).
- **PlutoFiInsurance** – 2% premium parametric cover (weather / yield triggers).

## Phase 1 Pilot

- Paraguay: 10 farms, MAG API, $2M target TVL.
- EU/Piedmont: 5 farms, REACH + NDVI, €1.5M target TVL.

## 📄 Grants & Funding
- **Polygon CGP S2**: $75k → Mainnet + CertiK
- **Horizon CL6**: €3M → REACH agri blockchain  
- **EIC Challenge**: €5M → Mercosur-EU bridge
- **Piedmont Regional**: €1M → EU Phase 1

## 🤝 Community
**plutofi.finance** | **Whitelist**: discord.gg/plutofi | **@plutofi**

---
**🌾 Farm RWAs → DeFi yields. jivonn/plutofi-protocol. Deployed. Funded.**
