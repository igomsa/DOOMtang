# model/ — SystemC TLM golden model  (Phase 2)

The reference oracle. A hand-written **RV32IMC instruction-set simulator** plus a
**TLM-2.0 virtual platform**, used by the UVM scoreboard for lockstep comparison.

```
model/
├── iss/            # rv32imc ISS: regfile, CSRs, decode, execute, traps
├── vp/             # virtual platform: ram, uart, framebuffer (TLM targets) + bus
├── ref_api/        # thin C API the SV/UVM scoreboard calls via DPI
└── tests/          # cross-check harness vs spike
```

Built against nixpkgs `systemc`. Cross-checked with `spike` on the same binaries.
Verilator `--sc` can wrap the RTL here for SystemC co-sim experiments.
