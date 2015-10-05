# vim: ft=make
.PHONY: text._graphics
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/generic/babel/babel.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/base/article.cls)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/base/inputenc.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/graphics/keyval.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/listings/listings.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/listings/lstlang1.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/listings/lstmisc.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,/usr/share/texlive/texmf-dist/tex/latex/preprint/fullpage.sty)
text.aux text.aux.make text.d text.pdf: $(call path-norm,text.tex)
.SECONDEXPANSION:
