require 'bibtex'

pubs = BibTeX.open('../bibtex/mcminn.bib')

fields = [
  'author', 
  'title',
  'booktitle',
  'editor',
  'journal',
  'series',
  'volume',
  'number',
  'pages',
  'month',
  'year',
  'location',
  'publisher',  
  'institution',
  'doi',
  'gsid',
  'url',
  'journalversion',
  'abstract',
  'comment'
]

def word_wrap(text, line_width)
  text.split("\n").collect do |line|
    line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
  end * "\n"
end

def format_field_value(value, wrap_at, indent_width) 
  value = value.strip.gsub(/\s+/, " ")
  value = word_wrap(value, wrap_at)

  value.gsub(/\n/, "\n".ljust(indent_width))
end

max_field_len = 0
fields.each do |field|
  max_field_len = field.length if field.length > max_field_len
end

num_entries = 0
pubs.each do |pub|
  entry = "@#{pub.type}{#{pub.id},"
  
  first_field = true
  break_indent = max_field_len + 7

  fields.each do |field| 
  	next unless pub.field?(field)

  	if first_field
  		first_field = false
  	else
  		entry += ","
  	end

  	formatted_field = field.to_s.ljust(max_field_len, ' ')
  	entry += "\n  #{formatted_field} = \""	
  	entry += format_field_value(pub[field], 60, break_indent)  	
  	entry += "\""
  end

  entry += "\n}\n\n"
  num_entries += 1
  puts entry
end

puts "Wrote #{num_entries} entries."
