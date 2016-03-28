require_relative 'lib/my_bibtex'

BIB_FILE = 'mcminn.bib'
MOD_BIB_FILE = 'mcminn.mod.bib'
WRAP_AT = 80

task :prettify do
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
    sponsor
  )
  prettify(BIB_FILE, MOD_BIB_FILE, WRAP_AT, fields)
end

task :accept_mods do
  `mv #{MOD_BIB_FILE} #{BIB_FILE}`
end

task :output_venues do
  get_venues(BIB_FILE).each do |venue|
    puts venue
  end
end