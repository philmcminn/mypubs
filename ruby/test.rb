require 'bibtex'

pubs = BibTeX.open('../bibtex/mcminn.bib')



name = "#{pubs[:Wright2014].author[1].first} #{pubs[:Wright2014].author[1].last}"

puts name

puts pubs[:McMinn2007].title.to_s(:filter => :latex)