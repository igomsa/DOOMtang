# dut/ — Designs Under Test

DUTs the UVM environment verifies, each self-contained.

- `minialu/` — the spartan3E `MiniAlu` ALU subset (Step 1 seed DUT). _to be imported_
- `vexriscv/` — VexRiscv RV32IMC core: the Step 3 DUT, verified against Spike via
  per-retire lockstep. Monitor taps the VexRiscv trace port.

The env retargets between these via the UVM factory + config DB — same components,
different DUT and reference.
