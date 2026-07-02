# Architecture & Verification Methodology

DOOMtang is organized around one idea borrowed from real silicon CPU verification:
**a Design-Under-Test is only as trustworthy as the independent golden model you
check it against.** Everything else follows from making that loop concrete.

## The three steps

| Step | DUT | Verification oracle | Deliverable |
|------|-----|---------------------|-------------|
| 1 | MiniAlu (ALU subset: ADD/SUB/MUL/SHL) | inline reference function | UVM env, video content |
| 2 | MiniAlu + memory-mapped I/O bus | hardware-in-the-loop on Tang 20k | full peripheral map demo |
| 3 | VexRiscv RV32IMC core | Spike ISS (per-retire step-and-compare) | DOOM on Tang 20k |

## The verification loop (Step 3)

```
            ┌──────────────────────── uvm_test ────────────────────────┐
            │                                                            │
   instr.   │   sequence ──▶ sequencer ──▶ driver ──▶ ┌─────────────┐  │
   stream   │                                          │  VexRiscv   │  │
   (random  │                                          │  RV32IMC    │  │
   + directed)                                         │  core (DUT) │  │
            │                          trace port ──▶ monitor        │  │
            │                               │          └─────────────┘  │
            │                               ▼                           │
            │                          ┌─────────┐  expected  ┌───────┐ │
            │                          │scoreboard│◀───────────│ Spike │ │
            │                          └─────────┘ per-retire  │  ISS  │ │
            │                               │                  └───────┘ │
            │                          pass/fail + coverage              │
            └────────────────────────────────────────────────────────────┘
```

- **sequence_item** — one architectural transaction (instruction + pre/post-state).
- **driver** applies it through the **interface** (with SVA assertions on the bus protocol).
- **monitor** taps VexRiscv's **trace port** — one event per retired instruction
  (PC, rd, wdata, mem address/data).
- **scoreboard** drives Spike one step, compares architectural state. Any divergence
  is a `uvm_error` with the instruction, expected state, and actual state.
- **coverage** closes on opcodes, operand corners, hazards, and traps per `isa.md`.

## Why Spike, not a hand-written ISS

Spike is the RISC-V Foundation's reference simulator — it *is* the spec executable.
Writing a parallel ISS alongside VexRiscv adds implementation complexity without adding
correctness value: if a hand-written ISS and VexRiscv agreed, you'd still need Spike to
trust the ISS. Spike short-circuits the whole problem.

## Step 2 as the computer-architecture teaching vehicle

Before VexRiscv, Step 2 extends the MiniAlu with **LOAD/STORE opcodes + a 16-bit
external address/data bus**, then maps real peripherals to address ranges decoded in
FPGA fabric:

| Address range | Peripheral |
|---|---|
| 0x0000–0x1FFF | HyperRAM (8 MB on-board, HyperBus) |
| 0x2000–0x2FFF | SD card (SPI controller, raw sectors) |
| 0x3000–0x3FFF | HDMI framebuffer |
| 0x4000–0x4FFF | CH559T USB host (UART/SPI bridge → keyboard) |

MiniAlu stays Harvard for instructions (ROM); the data side becomes Modified Harvard
with the external bus. The address decoder is a combinational mux in FPGA fabric —
every memory transaction is visible in the RTL without a CPU abstraction in the way.

## Step 1 as the seed (MiniAlu)

The Step-1 env verifies the `spartan3E_tests` **MiniAlu** ALU subset (ADD/SUB/MUL/SHL).
It is deliberately chosen because:

1. It exercises **every UVM component** end to end on something small and real.
2. The scoreboard reference function, sequence_item, and coverage model extend directly
   into the Spike-based Step-3 scoreboard — same structure, new DUT and oracle.
3. It validates the **methodology** (golden-reference comparison) on a DUT simple enough
   that any disagreement is obviously a TB bug, not a DUT mystery.

## Open-source vs commercial: the honest split

| Layer | Open-source / NixOS local | Commercial / free-tier |
|-------|---------------------------|------------------------|
| RTL elaboration & smoke sims | Verilator, Icarus | — |
| **Full SV-UVM env** | ✗ (UVM class lib unsupported) | EDA Playground, Questa Intel Starter |
| Spike lockstep oracle | spike (nixpkgs) | — |
| LiteX SoC + FPGA bitstream (Gowin) | yosys, nextpnr, apicula | — |

The UVM library is the only piece that can't run on the OSS toolchain; everything else
runs with `nix-shell && make`, and the UVM env runs in a browser via EDA Playground.
