# sim/ — Build & run

Makefiles, filelists, run scripts, and **captured transcripts** (committed so a
reviewer sees real results without running anything).

- `make`            — Phase 1 open-source smoke test (Verilator/Icarus).
- `make uvm`        — instructions/filelist for the SV-UVM env (EDA Playground / Questa).
- `make waves`      — open the last run in GTKWave.
- `filelists/`      — `.f` files shared between OSS and commercial flows.
- `transcripts/`    — saved passing logs + coverage summaries.

> Honesty rule for this repo: a transcript is only committed if it came from a real
> run. Nothing here is hand-written to look like output.
