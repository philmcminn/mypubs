require './my_bibtex'

IN_FILE = '../bibtex/mcminn.bib'
OUT_FILE = IN_FILE

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
  url
  journalversion
  abstract
  comment
)

pretify(IN_FILE, OUT_FILE, fields)


