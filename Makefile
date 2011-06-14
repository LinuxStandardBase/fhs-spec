XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml
XMLARGS=--stringparam  section.autolabel=1 --stringparam  section.label.includes.component.label=1


all: fhs.html fhs/index.html fhs.txt fhs.pdf

fhs.ps: $(XMLFILES)
	xmlto $(XMLARGS) ps fhs.xml

# makes useless pdf
#fhs.pdf: $(XMLFILES)
#	xmlto pdf fhs.xml

# also makes useless pdf
#fhs.pdf: $(XMLFILES)
#	USE_BACKEND=fop xmlto pdf fhs.xml

# this seems to make good pdf
# to override the default stylesheet, save its full path to stylesheet_path

stylesheet_path:
	echo "/usr/share/xml/docbook/stylesheet/docbook-xsl/fo/docbook.xsl" > $@

fhs.fo: stylesheet_path $(XMLFILES)
	xsltproc $(XMLARGS) $(FO_ARGS) -o $@ $(shell cat stylesheet_path) fhs.xml

fhs.pdf: fhs.fo
	fop fhs.fo -pdf fhs.pdf

# end good pdf alternative

fhs.txt: $(XMLFILES)
	xmlto $(XMLARGS) txt fhs.xml

fhs/index.html: $(XMLFILES)
	xmlto $(XMLARGS) -o fhs html fhs.xml

fhs.html: $(XMLFILES)
	xmlto $(XMLARGS) html-nochunks fhs.xml

valid:
	xmllint --valid --noout fhs.xml

clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html fhs.fo stylesheet_path
	rm -rf fhs

distclean: clean
