LATEXMK = pdflatex
FLAGS   = -shell-escape -interaction=nonstopmode
TARGET  = minialu_uvm_intro

.PHONY: all clean

all:
	$(LATEXMK) $(FLAGS) $(TARGET).tex
	$(LATEXMK) $(FLAGS) $(TARGET).tex

clean:
	rm -f $(TARGET).pdf $(TARGET).aux $(TARGET).log $(TARGET).nav \
	       $(TARGET).out $(TARGET).snm $(TARGET).toc $(TARGET).vrb \
	       $(TARGET).fls $(TARGET).fdb_latexmk
	rm -rf _minted _minted-$(TARGET)
