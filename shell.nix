# shell.nix — reproducible toolchain for the DOOMtang verification project.
#
#   nix-shell        # drop into a shell with every tool below on PATH
#
# One project, four skill tracks (see docs/ARCHITECTURE.md):
#   1. SystemVerilog / RTL design   -> verilator, iverilog, verible
#   2. UVM verification             -> real SV-UVM runs on EDA Playground / Questa
#                                       Intel Starter; pyuvm/cocotb path is local+OSS
#   3. SystemC TLM golden model     -> systemc, verilator --sc, spike (cross-check)
#   4. FPGA softcore (Tang 20k)     -> yosys, nextpnr-gowin, apicula, openFPGALoader
#
# NOTE: the full SystemVerilog UVM class library does NOT run on Icarus/Verilator.
# tb/ (real SV-UVM) targets a commercial sim — run free on EDA Playground or Questa
# Intel FPGA Starter Edition. The open-source flow here covers synthesizable RTL,
# lightweight SV testbenches, the SystemC model, and the FPGA bitstream.

{ pkgs ? import <nixpkgs> { } }:

let
  # RV32 bare-metal cross toolchain for test programs, bring-up code, and DOOM.
  # riscv32-none-elf-gcc, -march=rv32imc supported.
  riscvGcc = pkgs.pkgsCross.riscv32-embedded.buildPackages.gcc;
  riscvBinutils = pkgs.pkgsCross.riscv32-embedded.buildPackages.binutils;
in
pkgs.mkShell {
  name = "doomtang";

  buildInputs = with pkgs; [
    # --- Track 1: RTL simulation & lint ---
    verilator        # fast 2-state SV sim, lint, and --sc SystemC backend
    iverilog         # Icarus event sim for the Verilog/SV-subset smoke tests
    verible          # SystemVerilog linter + formatter (repo style gate)
    gtkwave          # waveform viewer (.vcd/.fst)

    # --- Track 3: SystemC TLM golden model ---
    systemc          # IEEE-1666 kernel + TLM-2.0 (Phase 2 ISS / virtual platform)
    spike            # riscv-isa-sim: independent ISS to cross-check our SystemC model

    # --- Track 4: FPGA synthesis & programming (Gowin GW2A on Tang 20k) ---
    yosys            # synthesis (synth_gowin)
    nextpnr          # place & route (gowin target)
    apicula          # open Gowin bitstream tools (gowin_pack)
    openfpgaloader   # program the Tang 20k over USB

    # --- RISC-V software toolchain (test programs, bring-up, doomgeneric) ---
    riscvGcc
    riscvBinutils
    dtc              # device tree compiler (SoC bring-up)

    # --- Build / misc ---
    gnumake
    git

    # --- Optional OSS "UVM-style" local flow (pyuvm on cocotb) ---
    # Uncomment to exercise UVM architecture locally without a commercial sim.
    # cocotb must come from nixpkgs (its VPI shim is compiled against the Nix
    # toolchain); pyuvm/pyvsc are pip-only -> install into a venv from shellHook.
    # (python3.withPackages (ps: with ps; [ cocotb cocotb-bus pip ]))
  ];

  shellHook = ''
    echo "── DOOMtang toolchain ──────────────────────────────"
    echo "  verilator : $(verilator --version 2>/dev/null | head -n1)"
    echo "  iverilog  : $(iverilog -V 2>/dev/null | head -n1)"
    echo "  systemc   : $(pkg-config --modversion systemc 2>/dev/null || echo 'in $SYSTEMC')"
    echo "  spike     : $(spike --help 2>&1 | head -n1)"
    echo "  yosys     : $(yosys --version 2>/dev/null | head -n1)"
    echo "  riscv-gcc : $(riscv32-none-elf-gcc --version 2>/dev/null | head -n1)"
    echo "────────────────────────────────────────────────────"
    echo "Phase 1 smoke test:  cd sim && make"
    echo "Full SV-UVM (tb/):   run on EDA Playground / Questa Intel Starter"
    export SYSTEMC_HOME=${pkgs.systemc}
  '';
}
