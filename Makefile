XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml
XMLTOARGS_OLD=--xsltopts '--stringparam section.autolabel 1 --stringparam section.label.includes.component.label 1 --stringparam chunker.output.encoding UTF-8'
XMLTOARGS_NEW=--stringparam  section.autolabel=1 --stringparam  section.label.includes.component.label=1 --stringparam  chunker.output.encoding=UTF-8
XSLTPROCARGS=--stringparam  section.autolabel 1 --stringparam  section.label.includes.component.label 1 --stringparam  chunker.output.encoding UTF-8

# Location of DocBook upstream docbook.xsl for html-nochunks on the system.
HTML_NOCHUNK_XSL=/usr/share/sgml/docbook/xsl-stylesheets/html/docbook.xsl

ifeq ($(shell xmlto --help | grep stringparam | wc -l),0)
XMLTOARGS=$(XMLTOARGS_OLD)
else
XMLTOARGS=$(XMLTOARGS_NEW)
endif

all: fhs.html fhs/index.html fhs.txt fhs.pdf

docbook-utf8.xsl: docbook-utf8.xsl.in
	sed s,@HTML_NOCHUNK_XSL@,$(HTML_NOCHUNK_XSL),g < $< > $@

fhs.ps: $(XMLFILES)
	xmlto $(XMLTOARGS) ps fhs.xml

fhs.fo: $(XMLFILES)
	xsltproc $(XSLTPROCARGS) $(FO_ARGS) -o $@ ./docbook-xsl/fo/docbook.xsl fhs.xml

fhs.pdf: fhs.fo
	fop fhs.fo -pdf fhs.pdf

fhs.txt: $(XMLFILES)
	xmlto $(XMLTOARGS) txt fhs.xml

fhs/index.html: $(XMLFILES)
	xmlto $(XMLTOARGS) -o fhs html fhs.xml

fhs.html: $(XMLFILES) docbook-utf8.xsl
	xmlto $(XMLTOARGS) -x ./docbook-utf8.xsl html-nochunks fhs.xml

valid:
	xmllint --valid --noout fhs.xml

clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html fhs.fo docbook-utf8.xsl
	rm -rf fhs

distclean: clean
