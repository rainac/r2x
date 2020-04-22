
all: package

package:
	R CMD build .

install: package
	R CMD INSTALL r2x_*.tar.gz

check: install
	R CMD check r2x_*.tar.gz

clean:
	rm -rf r2x_*.tar.gz r2x.Rcheck*
