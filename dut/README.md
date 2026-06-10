# dut/ — Designs Under Test

DUTs the UVM environment verifies, each self-contained.

- `minialu/` — the spartan3E `MiniAlu` (Phase 1 seed DUT). _to be imported_
- `picorv32/` — proven RV32 core: known-good DUT to validate the TB + DOOM fallback (Phase 3). _to be added_
- `rv32imc/` — pointer to the home-grown core in `../rtl/` (Phase 3).

The env retargets between these via the UVM factory + config DB — same components, different DUT.
