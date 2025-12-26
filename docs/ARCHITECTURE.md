# PlutoFi Architecture

- Actors: farmers, lenders, data providers (MAG, satellite, REACH), protocol.
- Flow:
  1. Farm + parcel onboarded (MAG/registry + REACH check).
  2. LandOracle stores collateral value per hectare.
  3. GreenOracle flags REACH-compliant farms as eligible.
  4. DualLending issues USDC/EURC loan within 24h.
  5. Insurance contract covers climate / yield events.

- Phase 1:
  - Paraguay: 10 farms, beef/soy, MAG parcel API.
  - EU/Piedmont: 5 farms, mixed crops, REACH + NDVI.

