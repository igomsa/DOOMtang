# fpga/ — Tang 20k Primer bitstream flow  (Step 3)

LiteX SoC synthesis + place & route + programming for the **Sipeed Tang 20k Primer**
(Gowin GW2A-18C), fully open-source.

```
fpga/
├── constraints/    # .cst pin/timing constraints for the board + dock
├── flow/           # yosys (synth_gowin) -> nextpnr-gowin -> apicula (gowin_pack)
├── litex/          # LiteX SoC config: VexRiscv + LiteSDCard + LiteVideo + HyperRAM
└── sw/             # bare-metal bring-up, then doomgeneric port (DG_DrawFrame / DG_GetKey)
```

Program with `openFPGALoader`.

**LiteX handles:** VexRiscv integration, HyperRAM controller, LiteSDCard (FatFS for
WAD + binary), LiteVideo (HDMI framebuffer + DMA). The `doomgeneric` port implements
the platform callbacks against those LiteX peripherals.
