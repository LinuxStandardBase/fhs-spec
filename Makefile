XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml

all: fhs.html fhs/book.html fhs.txt fhs.pdf

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

# alternative try
# to override the default stylesheet, save its full path to stylesheet_path

stylesheet_path:
	echo "/usr/share/xml/docbook/stylesheet/docbook-xsl/fo/docbook.xsl" > $@

fhs.fo: stylesheet_path $(XMLFILES)
	xsltproc $(FO_ARGS) -o $@ $(shell cat stylesheet_path) fhs.xml

fhs.pdf: fhs.fo
	fop fhs.fo -pdf fhs.pdf

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
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html fhs.fo stylesheet_path
	rm -rf fhs

distclean: clean
