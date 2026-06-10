# Architecture & Verification Methodology

DOOMtang is organized around one idea borrowed from real silicon CPU verification:
**a Design-Under-Test is only as trustworthy as the independent golden model you
check it against.** Everything else follows from making that loop concrete.

## The three implementations of one ISA

The same RV32IMC behavior is expressed three times, by three different means, so they
can check each other:

| # | Artifact | Language | Role | Built in |
|---|----------|----------|------|----------|
| A | Golden ISS | SystemC / C++ (TLM-2.0) | reference model | Phase 2 |
| B | RTL core (mine) | SystemVerilog | the DUT | Phase 3 |
| C | Proven core | PicoRV32 / VexRiscv | known-good DUT + DOOM fallback | Phase 3/4 |
| — | Spike | C++ | sanity-check for **A** | Phase 2 |

If A and B disagree on any retired instruction, one of them has a bug — and the UVM
scoreboard tells you *which instruction*, *which register/CSR/memory location*, and
*what each produced*. That is the entire game.

## The verification loop (Phase 3 target)

```
            ┌──────────────────────── uvm_test ────────────────────────┐
            │                                                            │
   instr.   │   sequence ──▶ sequencer ──▶ driver ──▶ ┌─────────────┐    │
   stream   │                                          │  DUT (RTL)  │   │
   (random  │                                          │  RV32IMC    │   │
   + directed)                              ┌── monitor┤  core       │   │
            │                               │          └─────────────┘    │
            │                               ▼                             │
            │                          ┌─────────┐   expected   ┌───────┐ │
            │                          │scoreboard│◀────────────│ ref   │ │
            │                          └─────────┘   (TLM call) │ model │ │
            │                               │                   │SystemC│ │
            │                          pass/fail                │ ISS   │ │
            │                          + coverage               └───────┘ │
            └────────────────────────────────────────────────────────────┘
```

- **sequence_item** = one architectural transaction (instruction + the
  pre-state it needs / the post-state it produces).
- **driver** applies it to the DUT through the **interface** (with SVA assertions on
  the bus protocol).
- **monitor** observes committed results (register writeback, memory writes, traps).
- **scoreboard** asks the **SystemC golden model** what *should* have happened and
  compares. This is the lockstep / step-and-compare check.
- **coverage** tracks which opcodes, operand classes, hazards, and corner cases
  (overflow, branch taken/not, misaligned, CSR access, traps) were actually hit.

## Why each tool is where it is

- **SystemC TLM-2.0 for the golden model.** TLM is the industry-standard way to write
  fast, loosely-timed system models. Writing the ISS + memory + UART + framebuffer as
  TLM modules (a) gives a cycle-approximate **virtual platform** that can boot software
  *before* the RTL exists, and (b) is the exact "SystemC TLM" skill several target job
  reqs ask for. Spike independently cross-checks it.
- **SystemVerilog + UVM for the DUT side.** This is what DV roles actually use, and
  what the verification env must be written in to be credible. UVM's factory + config
  DB make the *same env* retarget from `MiniAlu` (Phase 1) to the CPU (Phase 3).
- **Verilator/Icarus + Yosys/nextpnr for the open-source spine.** Local, reproducible,
  NixOS-native. Verilator's `--sc` mode can even wrap the RTL as a SystemC module for
  co-simulation experiments.

## Phase 1 as the seed (MiniAlu)

The Phase-1 env verifies the `spartan3E_tests` **MiniAlu** — a small ALU/CPU that is
already in this portfolio. It is deliberately chosen because:

1. It exercises **every UVM component** end to end on something small and real.
2. An ALU is the conceptual ancestor of the RISC-V datapath — the sequence_item,
   scoreboard reference function, and coverage model port forward to Phase 3 with the
   structure intact.
3. It validates the **methodology** (golden-reference comparison) on a DUT simple
   enough that any disagreement is obviously a TB bug, not a DUT mystery.

## Open-source vs commercial: the honest split

| Layer | Open-source / NixOS local | Commercial / free-tier |
|-------|---------------------------|------------------------|
| RTL elaboration & smoke sims | Verilator, Icarus | — |
| **Full SV-UVM env** | ✗ (UVM class lib unsupported) | EDA Playground, Questa Intel Starter |
| SystemC TLM model | systemc, Verilator `--sc` | — |
| FPGA bitstream (Gowin) | yosys, nextpnr, apicula | (Gowin EDA optional) |

The UVM library itself is the only piece that can't run on the OSS toolchain; the repo
is structured so a reviewer can run *everything else* with `nix-shell && make`, and run
the UVM env in a browser via EDA Playground.
