# DOOMtang

**Designing, verifying, and running a RISC-V softcore — end to end.**
A hand-written RV32IMC instruction-set model in **SystemC TLM** serves as the golden
reference inside a **SystemVerilog UVM** environment that verifies a **custom RTL
RISC-V core** by lockstep comparison. The verified core is then synthesized to a
**Sipeed Tang 20k Primer (Gowin)** FPGA — to run the original *DOOM*.

> One project, four production skills: **logic/RTL design · SystemVerilog · UVM · SystemC TLM** — plus computer-architecture design and FPGA implementation.

---

## Why this project

CPUs aren't verified by eyeballing waveforms — they're verified by **step-and-compare
against a golden model** (cf. Google's `riscv-dv` + Spike co-simulation). DOOMtang is
my own version of that loop, built from scratch so every layer is mine to explain:

```
   ┌──────────────────────── SystemVerilog UVM ─────────────────────────┐
   │   sequences ─▶ driver ─▶ [ RTL RISC-V core  (DUT) ] ─▶ monitor      │
   │                                       │                              │
   │                                  scoreboard ◀──────────── compare    │
   │                                       ▲                              │
   └───────────────────────────────────────┼─────────────────────────────┘
                                            │ TLM-2.0
                            ┌───────────────┴────────────────┐
                            │   SystemC TLM golden model      │
                            │   RV32IMC ISS + mem / UART / FB │
                            └─────────────────────────────────┘
```

See **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** for the full methodology.

## Roadmap & status

| Phase | Deliverable | Skills | Status |
|------:|-------------|--------|--------|
| 0 | Repo + reproducible toolchain (`shell.nix`) + docs | tooling | 🟡 in progress |
| 1 | Reusable **SV-UVM** env verifying the `MiniAlu` DUT | UVM, SV, RTL | ⬜ next |
| 2 | RV32IMC arch spec + **SystemC TLM** golden ISS | SystemC TLM, arch | ⬜ |
| 3 | Custom **RTL RV32IMC core** + UVM **lockstep** co-sim | UVM+SystemC+RTL | ⬜ |
| 4 | Synthesize to **Tang 20k**, bring-up, **run DOOM** | FPGA, arch | ⬜ |

Full detail and design decisions: **[docs/ROADMAP.md](docs/ROADMAP.md)**.

## Design choices

- **ISA: RV32IMC + Zicsr/traps** — enough to run DOOM at usable speed. ([docs/isa.md](docs/isa.md))
- **Hybrid core strategy** — I design my own RTL core; a proven core (PicoRV32 /
  VexRiscv) rides along as (a) a *known-good DUT to validate the UVM env first* and
  (b) the *fallback* to actually boot DOOM if my core falls short on timing/area.
- **Reuse:** the Phase-1 UVM env (built on `MiniAlu`) is extended — not rewritten —
  into the Phase-3 CPU lockstep env. Same components, new DUT + reference.

## Repository layout

```
DOOMtang/
├── shell.nix            # reproducible OSS toolchain (nix-shell)
├── docs/                # ARCHITECTURE, ROADMAP, isa
├── tb/                  # SystemVerilog UVM environment  (Phase 1 → 3)
├── dut/                 # DUTs under verification (MiniAlu, then RISC-V cores)
├── rtl/                 # my synthesizable RTL (RV32IMC core)            [Phase 3]
├── model/               # SystemC TLM golden ISS + virtual platform     [Phase 2]
├── sim/                 # Makefiles, filelists, run scripts, transcripts
└── fpga/                # Tang 20k constraints + bitstream flow          [Phase 4]
```

## Getting started

```bash
nix-shell            # Verilator, Icarus, SystemC, Yosys/nextpnr/apicula,
                     # riscv32 gcc, spike, gtkwave — all pinned
cd sim && make       # (Phase 1) open-source smoke test
```

The full SystemVerilog UVM environment in `tb/` needs a commercial-grade simulator;
run it free on **EDA Playground** (Questa/VCS) or **Questa Intel FPGA Starter
Edition**. The open-source `shell.nix` flow covers the RTL, the SystemC model, and
the FPGA bitstream.

---

*Author: Isaac Gómez Sánchez · Target board: Sipeed Tang 20k Primer (Gowin GW2A-18).*
