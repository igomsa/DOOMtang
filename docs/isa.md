# ISA scope — RV32IMC + Zicsr

Target: **RV32IMC_Zicsr**, machine-mode only. Rationale: the smallest ISA that runs
`doomgeneric` at a usable frame rate on a small softcore without trap-emulating hot
paths.

| Ext | What | Why it's in scope |
|-----|------|-------------------|
| **I** | 32-bit base integer | mandatory baseline |
| **M** | mul / div / rem | DOOM's fixed-point math + rendering would be painfully slow if multiply/divide were software-emulated |
| **C** | 16-bit compressed | ~25–30% smaller code → matters on a RAM-tight FPGA; adds fetch/align complexity worth showing |
| **Zicsr** | CSR read/write | needed for traps, timer, and any real bring-up |
| traps | ecall/ebreak + exceptions | required by the C runtime and for debuggable bring-up |

**Out of scope (for now):** supervisor/user modes, virtual memory, A (atomics), F/D
(hardware float — DOOM is fixed-point), interrupts beyond a basic timer. These can be
added later but aren't on the DOOM critical path.

## Verification implication

The functional-coverage model (Phase 1 → 3) must close on:

- every opcode in I, M, and the C-compressed encodings;
- operand corners: zero, all-ones, sign boundaries, `x0` as src/dst;
- M corners: div-by-zero, signed overflow (`INT_MIN / -1`), `rem` sign rules;
- C corners: every compressed form expands to the right base instruction;
- control: branch taken/not-taken, forward/backward, jump-and-link;
- CSR: read/write/set/clear, illegal-CSR trap;
- traps: misaligned access, illegal instruction, `ecall`/`ebreak`.

The SystemC golden model is the oracle for all of the above; the UVM scoreboard flags
any divergence per-instruction.

## Conformance backstop

Beyond the home-grown checks, the RTL core will be run against the official
**riscv-arch-test** suite and cross-checked with **spike** to catch ISA-compliance
gaps the directed/random UVM stimulus might miss.
