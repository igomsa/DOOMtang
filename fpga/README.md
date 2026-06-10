# fpga/ — Tang 20k Primer bitstream flow  (Phase 4)

Synthesis + place & route + programming for the **Sipeed Tang 20k Primer**
(Gowin GW2A-18C), fully open-source.

```
fpga/
├── constraints/    # .cst pin/timing constraints for the board + dock
├── flow/           # yosys (synth_gowin) -> nextpnr-gowin -> apicula (gowin_pack)
├── soc_top.sv      # core + ROM/RAM + UART + HDMI framebuffer
└── sw/             # bare-metal bring-up, then doomgeneric port
```

Program with `openFPGALoader`. Fallback path boots DOOM on the proven core if the
home-grown core misses timing/area.
