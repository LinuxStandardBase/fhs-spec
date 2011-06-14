XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml
XMLTOARGS=--stringparam  section.autolabel=1 --stringparam  section.label.includes.component.label=1
XSLTPROCARGS=--stringparam  section.autolabel 1 --stringparam  section.label.includes.component.label 1


all: fhs.html fhs/index.html fhs.txt fhs.pdf

fhs.ps: $(XMLFILES)
	xmlto $(XMLTOARGS) ps fhs.xml

# makes useless pdf
#fhs.pdf: $(XMLFILES)
#	xmlto pdf fhs.xml

# also makes useless pdf
#fhs.pdf: $(XMLFILES)
#	USE_BACKEND=fop xmlto pdf fhs.xml

# this seems to make good pdf
#
# to override the default stylesheet, save its full path to stylesheet_path
# this is not portable, varies by distro.
stylesheet_path:
	echo "/usr/share/xml/docbook/stylesheet/docbook-xsl/fo/docbook.xsl" > $@

fhs.fo: stylesheet_path $(XMLFILES)
	xsltproc $(XSLTPROCARGS) $(FO_ARGS) -o $@ $(shell cat stylesheet_path) fhs.xml

fhs.pdf: fhs.fo
	fop fhs.fo -pdf fhs.pdf

# end good pdf alternative

fhs.txt: $(XMLFILES)
	xmlto $(XMLTOARGS) txt fhs.xml

fhs/index.html: $(XMLFILES)
	xmlto $(XMLTOARGS) -o fhs html fhs.xml

fhs.html: $(XMLFILES)
	xmlto $(XMLTOARGS) html-nochunks fhs.xml

valid:
	xmllint --valid --noout fhs.xml

clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html fhs.fo stylesheet_path
	rm -rf fhs

distclean: clean
