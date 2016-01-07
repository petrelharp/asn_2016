SHELL := /bin/bash
# use bash for <( ) syntax

.PHONY : all publish

all : using-rmarkdown.slides.html using-rmarkdown.html Readme.html technical-notes.html

# change this to the location of your local MathJax.js library
LOCAL_MATHJAX = /usr/share/javascript/mathjax/MathJax.js
ifeq ($(wildcard $(LOCAL_MATHJAX)),)
	MATHJAX = https://cdn.mathjax.org/mathjax/latest/MathJax.js
else
	MATHJAX = $(LOCAL_MATHJAX)
endif

PANDOC_OPTS = --mathjax=$(MATHJAX)?config=TeX-AMS-MML_HTMLorMML --standalone
# optionally add in a latex file with macros
MACROS_FILE = macros.tex
ifeq ($(wildcard $(MACROS_FILE)),)
	# macros file isn't there
else
	PANDOC_OPTS += -H <(echo '\['; cat $(MACROS_FILE); echo '\]')
endif

%.html : %.Rmd
	# cd $$(dirname $<); Rscript -e 'knitr::knit2html(basename("$<"),output=basename("$@"))'
	cd $$(dirname $<); Rscript -e 'rmarkdown::render(basename("$<"),output_file=basename("$@"))'

%.html : %.md
	pandoc -o $@ $(PANDOC_OPTS) $<

%.md : %.Rmd
	cd $$(dirname $<); Rscript -e 'knitr::knit(basename("$<"),output=basename("$@"))'

## VARIOUS SLIDE METHODS
REVEALJS_OPTS = -t revealjs -V theme=simple -V slideNumber=true -V transition=none -H resources/adjust-revealjs.style
SLIDY_OPTS = -t slidy
S5_OPTS = -t s5
SLIDES_OPTS = $(REVEALJS_OPTS)

%.slides.html : %.md
	pandoc -o $@ $(SLIDES_OPTS) $(PANDOC_OPTS) $<

%.revealjs.html : %.md
	pandoc -o $@ $(REVEALJS_OPTS) $(PANDOC_OPTS) $<

%.slidy.html : %.md
	pandoc -o $@ $(SLIDY_OPTS) $(PANDOC_OPTS) $<

%.s5.html : %.md
	pandoc -o $@ $(S5_OPTS) $(PANDOC_OPTS) $<


### VARIOUS METHODS USING R

%.rmarkdown.html : %.md
	### rmarkdown::render()
	cd $$(dirname $<); Rscript -e 'rmarkdown::render(basename("$<"),output_file=basename("$@"))'

%.markdown.html : %.md
	### markdown::markdownToHTML()
	cd $$(dirname $<); Rscript -e 'markdown::markdownToHTML(basename("$<"),output=basename("$@"))'

%.knitr.html : %.md
	### knitr::knit2html()
	cd $$(dirname $<); Rscript -e 'knitr::knit2html(basename("$<"),output=basename("$@"))'

%.pander.html : %.md
	### pander::Pandoc.convert()
	# note that pander silently modifies input markdown file
	# AND doesn't provide a way to set the output file
	# so this WON'T work with files with images in
	cd $$(dirname $<) && \
		TEMPFILE="$(addprefix _pander_,$(<F))" && \
		cp $(<F) $$TEMPFILE && \
	   	Rscript -e 'f.out <- pander::Pandoc.convert(f="'$${TEMPFILE}'",open=FALSE); file.copy(f.out,basename("$@")); unlink(f.out); cat("$@","\n")' && \
		rm $$TEMPFILE

