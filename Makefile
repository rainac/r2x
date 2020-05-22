
all: package

inst-files:
	rm -rf inst
	mkdir -p inst/doc
	$(MAKE) inst/doc/r2x-introduction.pdf
	mkdir -p inst/tests/testthat
	mkdir -p inst/xsl
	cp -v xsl/* inst/xsl
	cp -v tests/testthat.R inst/tests/
	cp -rv tests/testthat/r2x inst/tests/testthat/

doc:
	Rscript -e "devtools::document(roclets = c('rd', 'collate'))"

package:
	R CMD build .

install: package
	R CMD INSTALL r2x_*.tar.gz

check: install
	R CMD check r2x_*.tar.gz

clean:
	rm -rf r2x_*.tar.gz r2x.Rcheck*

pdf: inst/doc inst/doc/r2x-introduction.pdf

inst/doc:
	mkdir $@

inst/doc/r2x-introduction.pdf: README.org
	emacs --batch -q -l export-init.el --file $< -f org-latex-export-to-latex
	pdflatex README.tex
	pdflatex README.tex
	mv README.pdf $@
#	rm README.tex
