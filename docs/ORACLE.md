



# PlutoFi Oracles (Phase 1)

This document describes the **land** and **green compliance** oracles used in Phase 1 of the PlutoFi Protocol.

---

## 1. Overview

- **Goal:** bring land value, crop health (NDVI) and REACH compliance on-chain for farms in Paraguay and Piedmont.  
- **Usage:** lending and insurance contracts read these oracles before approving loans or payouts.

---

## 2. Land Oracle – `PlutoFiLandOracle`

### 2.1 Purpose

- Stores parcel‑level land value per hectare.  
- Links on-chain `parcelId` to latest off‑chain appraisal or cadastre value.

### 2.2 External data sources

- **Cadastre / land registry:** parcel ownership, area, official value (Paraguay MAG + EU registries where available).[web:527][web:530]  
- **Satellite / NDVI provider:** used to adjust or validate productive value when relevant.[web:522][web:524][web:538]  

### 2.3 Key functions (Phase 1)

- `setLandValue(parcelId, valuePerHa)` – called by backend/oracle signer.  
- `getLandValue(parcelId) -> uint256` – read by lending contracts to check LTV.  

### 2.4 Security / limits

- Only a whitelisted oracle address can update values.  
- Simple rate‑limit / sanity checks in backend (no >X% change per day for same parcel).

---

## 3. Green Oracle – `PlutoFiGreenOracle`

### 3.1 Purpose

- Tracks REACH and sustainability compliance at farm level.  
- Provides a single on-chain flag and score that lending contracts can use for eligibility.

### 3.2 External data sources

- **REACH Annex XVII restricted substances list** (curated subset for agriculture).[web:531][web:537][web:540]  
- Farm self‑report + agronomist verification (off-chain), encoded as compliance events.

### 3.3 Key functions (Phase 1)

- `setFarmCompliance(farmId, bool isCompliant, uint8 reachScore)` – backend/oracle signer only.  
- `getFarmCompliance(farmId) -> (bool isCompliant, uint8 reachScore)` – read by lending + insurance.  

### 3.4 Scoring model (example)

- `reachScore` 0–100 where:
  - 0–49: not eligible (banned substances detected or missing data).  
  - 50–79: basic compliance.  
  - 80–100: best‑in‑class (eligible for best rates).

---

## 4. Update flow (off‑chain → on‑chain)

1. Backend pulls cadastre + NDVI + REACH data for each farm/parcel.[web:522][web:529][web:538]  
2. Backend computes:
   - `valuePerHa` for each `parcelId`.  
   - `isCompliant` and `reachScore` for each `farmId`.  
3. Backend sends signed transactions:
   - `setLandValue(parcelId, valuePerHa)` on `PlutoFiLandOracle`.  
   - `setFarmCompliance(farmId, isCompliant, reachScore)` on `PlutoFiGreenOracle`.  

---

## 5. Consumption by protocol contracts

- **PlutoFiDualLending**
  - Reads `getLandValue` to enforce max LTV per loan.  
  - Reads `getFarmCompliance` to reject non‑compliant farms.

- **PlutoFiInsurance**
  - Optionally uses `reachScore` and NDVI history
