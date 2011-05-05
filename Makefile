XMLFILES=fhs.xml intro.xml filesystem.xml root-filesystem.xml usr.xml var.xml os.xml appendix.xml

all: fhs.html fhs/book.html fhs.txt fhs.pdf #fhs.ps 

fhs.ps: $(XMLFILES)
	xmlto ps fhs.xml

fhs.pdf: $(XMLFILES)
	xmlto pdf fhs.xml

fhs.txt: $(XMLFILES)
	xmlto txt fhs.xml

fhs/book.html: $(XMLFILES)
	xmlto -o fhs html fhs.xml

fhs.html: $(XMLFILES)
	xmlto html-nochunks fhs.xml

clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html

distclean: clean
