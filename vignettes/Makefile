all: r2x-introduction.pdf copy-pdf

copy-pdf:
	cp r2x-introduction.pdf ../inst/doc

#%.tex: %.org
#	emacs --batch -q --file $< -f org-latex-export-to-latex

#%.pdf: %.tex
#	pdflatex $<
#	pdflatex $<

clean:
	rm -rf *.aux *.log *.toc *.out
