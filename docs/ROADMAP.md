# Roadmap

Three steps. Each ends with something demonstrable — a real sim transcript, real
hardware, or real gameplay — so the repo is a credible portfolio piece at every
checkpoint.

Legend: ✅ done · 🟡 in progress · ⬜ not started

---

## Step 1 — SV-UVM on MiniAlu 🟡

**Goal:** complete UVM environment verifying MiniAlu ALU operations (ADD/SUB/MUL/SHL),
physical LED demo on Tang 20k, two 5-min video segments for LinkedIn/Upwork.

UVM build order:
- [ ] `dut/minialu/minialu_alu.sv` — combinational ALU faithful to the LCD MiniAlu
- [ ] Interface + SVA
- [ ] `seq_item`
- [ ] Reference model
- [ ] Driver → Monitor → Agent → Sequencer
- [ ] Sequences (directed + constrained-random)
- [ ] Scoreboard + Coverage
- [ ] Env + Tests + `tb_top`
- [ ] `sim/` Makefile + filelist; EDA Playground link
- [ ] Real passing transcript + coverage summary captured in `sim/transcripts/`
- [ ] Beamer slides (`docs/minialu_uvm_intro.tex`) updated with real snippets + EDA screenshot

**Done when:** a planted bug fires a `UVM_ERROR`; coverage closes on all four ops;
LED demo runs on Tang 20k.

**Demonstrates:** UVM, SystemVerilog, RTL comprehension.

---

## Step 2 — Memory-mapped MiniAlu + peripherals ⬜

**Goal:** extend MiniAlu with LOAD/STORE opcodes and a 16-bit external address/data
bus; wire SD (raw sector reads), HyperRAM, HDMI framebuffer, and CH559 USB keyboard
into a decoded address map; demonstrate the full memory hierarchy on Tang 20k hardware.

- [ ] Extend ISA: LOAD/STORE opcodes + address bus in `dut/minialu/`
- [ ] Address decoder in FPGA fabric (combinational mux)
- [ ] HyperRAM controller (HyperBus, 8 MB on-board)
- [ ] SD SPI controller (raw sector reads, no FatFS yet)
- [ ] HDMI framebuffer
- [ ] CH559T USB host bridge (UART/SPI → keyboard input)
- [ ] Hardware demo + video content (computer-architecture angle)

**Done when:** a program runs on the extended MiniAlu reading from SD, writing to
HyperRAM and HDMI, with USB keyboard input registered.

**Demonstrates:** RTL design, memory-mapped I/O, full peripheral integration.

---

## Step 3 — VexRiscv UVM lockstep + DOOM on Tang 20k ⬜

**Goal:** graduate the Step-1 UVM env to target VexRiscv; use Spike as the per-retire
scoreboard oracle; pass `riscv-arch-tests`; synthesize a LiteX SoC to Tang 20k and run DOOM.

- [ ] Retarget UVM env to VexRiscv DUT (trace port as monitor tap)
- [ ] Scoreboard calls Spike step-and-compare per retired instruction
- [ ] Instruction-stream sequences (random + directed corners from `isa.md`)
- [ ] `riscv-arch-test` conformance run
- [ ] LiteX SoC synthesis → Tang 20k (LiteSDCard, LiteVideo HDMI, HyperRAM controller)
- [ ] `doomgeneric` port: implement `DG_DrawFrame`, `DG_GetKey` against LiteX hardware
- [ ] WAD + binary from SD via FatFS
- [ ] **DOOM renders on Tang 20k** 🎉

**Done when:** VexRiscv passes lockstep + arch-test; DOOM is playable on hardware.

**Demonstrates:** UVM + RISC-V + FPGA + full-stack computer architecture.

---

## Dependencies

Step 3 depends on Step 1 for its UVM infrastructure. Step 2 is independent —
hardware-only RTL, no UVM involvement.
