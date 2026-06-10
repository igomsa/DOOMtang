# Roadmap

Five phases. Each ends with something runnable and demonstrable, so the repo is a
credible portfolio piece at every checkpoint — not just at the end.

Legend: ✅ done · 🟡 in progress · ⬜ not started

---

## Phase 0 — Foundations 🟡
**Goal:** reproducible toolchain + the project's story on disk.
- [x] `shell.nix` pinning the OSS toolchain (Verilator, Icarus, SystemC, Yosys/
      nextpnr/apicula, riscv32 gcc, spike, gtkwave, verible).
- [x] README narrative + portfolio pitch.
- [x] `docs/ARCHITECTURE.md`, `docs/isa.md`, `docs/ROADMAP.md`.
- [ ] Repo skeleton dirs (`dut/`, `rtl/`, `model/`, `sim/`, `fpga/`) seeded.
**Done when:** `nix-shell` drops into a working shell and the docs explain the loop.

## Phase 1 — SV-UVM warm-up on MiniAlu ⬜
**Goal:** a complete, reusable SystemVerilog UVM environment against a real DUT.
- [ ] Import the spartan3E `MiniAlu` as `dut/minialu/`.
- [ ] Rebuild `tb/` from templates into working components: interface (+SVA),
      sequence_item, sequences (directed + random), sequencer, driver, monitor,
      agent, scoreboard (with a reference function), coverage, env, tests, top.
- [ ] Fix every scaffold bug (missing `;`, `paremt`, reserved `output`, illegal
      in-class interface instances, null-context `config_db`).
- [ ] `sim/` Makefile + filelist; EDA Playground link; OSS smoke test.
- [ ] Capture a **real** passing transcript + coverage summary into `sim/`.
**Done when:** the env runs, a planted bug is caught, coverage closes on MiniAlu ops.
**Demonstrates:** UVM, SystemVerilog, RTL comprehension.

## Phase 2 — RV32IMC arch + SystemC TLM golden model ⬜
**Goal:** the oracle the CPU will be judged against.
- [ ] RV32IMC_Zicsr microarchitecture notes (`docs/`), decode tables.
- [ ] `model/`: SystemC TLM-2.0 ISS (registers, CSRs, mem, traps) + a virtual
      platform (RAM, UART, framebuffer initiator/target sockets).
- [ ] Boot a tiny RV32 program (UART "hello") on the virtual platform.
- [ ] Cross-check the ISS against **spike** on the same binaries.
**Done when:** ISS + spike agree on a test-program suite; VP runs bare-metal code.
**Demonstrates:** SystemC TLM, computer architecture.

## Phase 3 — RTL core + UVM lockstep ⬜
**Goal:** my own core, verified against the golden model.
- [ ] `rtl/`: RV32IMC core (fetch/decode/exec/mem/wb; M unit; C-expander; CSR/trap).
- [ ] Wrap a **proven core** (PicoRV32/VexRiscv) as a known-good DUT and run the env
      against it first — proves the TB, not just the design.
- [ ] Extend the Phase-1 scoreboard to call the SystemC ISS as the reference and do
      per-retire step-and-compare; instruction-stream sequences (random + riscv-dv-
      style + directed corners from `isa.md`).
- [ ] Run `riscv-arch-test` conformance.
**Done when:** my core passes lockstep + arch-test; coverage model closes.
**Demonstrates:** UVM + SystemC + RTL together — the centerpiece.

## Phase 4 — Tang 20k softcore + DOOM ⬜
**Goal:** the verified core, in silicon-ish, running the game.
- [ ] Synthesize with yosys → nextpnr (gowin) → apicula; `fpga/` constraints for the
      Tang 20k Primer + dock; program via openFPGALoader.
- [ ] SoC bring-up: ROM/RAM, UART, then a framebuffer to HDMI.
- [ ] Bare-metal "hello", then port `doomgeneric`.
- [ ] **Fallback:** if my core misses timing/area, boot DOOM on the proven core to
      prove the SoC + software path, and keep closing my core in parallel.
**Done when:** DOOM renders on the Tang 20k. 🎉
**Demonstrates:** FPGA implementation, full-stack computer architecture.

---

## Tracking
Live status is mirrored in the session task list (Phases 0–4). Each phase's "Done
when" is the acceptance gate before the next begins; Phase 3 depends on **both** 1 and 2.
