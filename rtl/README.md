# rtl/ — Home-grown synthesizable RTL  (Phase 3)

My own **RV32IMC_Zicsr** core. Planned structure:

```
rtl/
├── rv32imc_core.sv     # top
├── fetch.sv  decode.sv  execute.sv  mem.sv  writeback.sv
├── regfile.sv  alu.sv  muldiv.sv     # M extension
├── cexpand.sv                        # C: 16-bit -> 32-bit expander
├── csr.sv  trap.sv                   # Zicsr + exceptions
└── soc/                              # bus, RAM, UART, framebuffer (Phase 4)
```

Must be synthesizable for yosys → nextpnr (Gowin). Verified in `../tb/` against the
SystemC golden model in `../model/`.
