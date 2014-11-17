require 'bibtex'

required_fields = [
	'author',   
	'title',    
#	'booktitle',
#	'location', 
#	'month',
#	'year',
#	'pages',
#	'publisher',
#	'series',
#	'volume',
#	'doi',
#	'gsid',
	'url',
	'abstract'
]

pubs = BibTeX.open('../bibtex/mcminn.bib')

pubs.each do |pub|

	missing_fields = []
	
	required_fields.each do |field|
		missing_fields.push(field) unless pub.has_field?(field)
	end

	if missing_fields.size > 0
		puts "#{pub.key} (#{pub.title}) is missing the fields #{missing_fields}"
	end

end