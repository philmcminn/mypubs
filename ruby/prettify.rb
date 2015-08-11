require './my_bibtex'

IN_FILE = '../bibtex/mcminn.bib'
OUT_FILE = '../bibtex/mcminn.pretty.bib'

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
  doi
  gsid
  gscites
  url
  jv
  abstract
  comment
)

prettify(IN_FILE, OUT_FILE, fields)


