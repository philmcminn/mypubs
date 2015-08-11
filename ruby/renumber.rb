require './my_bibtex'

IN_FILE = '../bibtex/mcminn.bib'
OUT_FILE = '../bibtex/mcminn.pretty.bib'
RENAME_SCRIPT_OUT_FILE = '../bibtex/rename.sh'
URL_START_STRING = 'http://philmcminn.staff.shef.ac.uk/publications/pdfs/'
WARNING_OUT_FILE = '../bibtex/warning.txt'

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
  year
  publisher
  institution
  doi
  gsid
  gscites
  jv
  abstract
  comment
)

journals = 0
conferences = 0
incollections = 0
techreports = 0
theses = 0
unknown = 0

bib = BibTeX.open(IN_FILE )

# first do a count
bib.each do |pub|
  case pub.type
    when :article
      journals += 1
    when :incollection
      incollections += 1
    when :inproceedings
      conferences += 1
    when :phdthesis
      theses += 1
    when :techreport
      techreports += 1
    else
      unknown += 1
  end
end

puts "Totals:"
puts "- journals #{journals}"
puts "- conferences #{conferences}"
puts "- incollections #{incollections}"
puts "- techreports #{techreports}"
puts "- theses #{theses}"
puts "- unknown #{unknown}"


# now set the keys
bib_data = ''
rename_script = ''
warning = ''

bib.each do |pub|
  case pub.type
    when :article
      pub.key = 'j' + journals.to_s
      journals -= 1
    when :incollection
      pub.key = 'ic' + incollections.to_s
      incollections -= 1
    when :inproceedings
      pub.key = 'c' + conferences.to_s
      conferences -= 1
    when :phdthesis
      pub.key = 't' + theses.to_s
      theses -= 1
    when :techreport
      pub.key = 'tr' + techreports.to_s
      techreports -= 1
    else
      unknown -= 1
  end

  if pub.field?('url')
    url = pub['url'].to_s
    if url.start_with?(URL_START_STRING)
      url.sub!(URL_START_STRING, '')
      rename_script += "mv #{url} #{pub.key}.pdf \n"
    else
      warning += "No local file for #{pub['title']} \n"
    end
  end

  bib_data += format_pub(pub, fields)
end

File.open(OUT_FILE, "w") {|f| f.write(bib_data) }
File.open(RENAME_SCRIPT_OUT_FILE, "w") {|f| f.write(rename_script) }
File.open(WARNING_OUT_FILE, "w") {|f| f.write(warning) }
