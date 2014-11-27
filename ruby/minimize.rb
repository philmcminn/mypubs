#!/usr/bin/ruby

require './my_bibtex'

IN_FILE = '../bibtex/mcminn.bib'
OUT_FILE = '../bibtex/mcminn.min.bib'

fields = %w(
  author
  title
  booktitle
  editor
  journal
  series
  volume
  number
  pages
  month
  year
  location
  publisher
  institution
)

pretify(IN_FILE, OUT_FILE, fields)