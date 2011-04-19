SGMLFILES=fhs.sgml intro.sgml filesystem.sgml root-filesystem.sgml usr.sgml var.sgml os.sgml appendix.sgml

all: fhs.ps fhs.pdf fhs.txt fhs/book.html fhs.html

fhs.ps: $(SGMLFILES)
	sgmltools -b ps fhs.sgml

fhs.pdf: $(SGMLFILES)
	sgmltools -b pdf fhs.sgml

fhs.txt: $(SGMLFILES)
	sgmltools -b txt fhs.sgml

fhs/book.html: $(SGMLFILES)
	sgmltools -b html fhs.sgml

fhs.html: $(SGMLFILES)
	sgmltools -b onehtml fhs.sgml


clean:
	rm -f fhs.ps fhs.txt fhs.pdf fhs/*.html fhs.html
