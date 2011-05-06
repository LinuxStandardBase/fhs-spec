XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml

all: fhs.html fhs/book.html fhs.txt fhs.pdf #fhs.ps

fhs.ps: $(XMLFILES)
	xmlto ps fhs.xml

# makes useless pdf
#fhs.pdf: $(XMLFILES)
#	xmlto pdf fhs.xml

# also makes useless pdf
#fhs.pdf: $(XMLFILES)
#	USE_BACKEND=fop xmlto pdf fhs.xml

# this works, but isn't perfect - funny page breaks, since html doesn't have
#fhs.pdf: fhs.html
#	htmldoc --continuous -f fhs.pdf fhs.html

# alternative try, but this has a hardcoded path (and lots of error output)
XSL_PREFIX = /usr/share/sgml/docbook/xsl-stylesheets-1.76.1
FO_XSL = $(XSL_PREFIX)/fo/docbook.xsl   

fhs.fo:
	xsltproc $(FO_ARGS) $(FO_XSL) fhs.xml > fhs.fo

fhs.pdf: fhs.fo
	fop fhs.fo -pdf fhs.pdf
	rm -f fhs.fo
# end alternative

fhs.txt: $(XMLFILES)
	xmlto txt fhs.xml

fhs/book.html: $(XMLFILES)
	xmlto -o fhs html fhs.xml

fhs.html: $(XMLFILES)
	xmlto html-nochunks fhs.xml

valid:
	xmllint --valid --noout fhs.xml

clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html

distclean: clean
