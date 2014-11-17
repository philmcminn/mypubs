require 'bibtex'

pubs = BibTeX.open('../bibtex/mcminn.bib')

fields_in_order = [
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

pubs.each do |pub|

  fields = pub.field_names

  max_len = 0
  fields.each do |field|
  	max_len = field.length if field.length > max_len
  	unless fields_in_order.include?(field.to_s)  		
  		puts "For #{pub.id} -- unknown field '#{field}'" 
  		abort
  	end
  end

  entry = "@#{pub.type}{#{pub.id},"
  
  first_field = true
  break_indent = max_len + 7

  fields_in_order.each do |field| 

  	next unless pub.field?(field)

  	if first_field
  		first_field = false
  	else
  		entry += ","
  	end

  	formatted_field = field.to_s.ljust(max_len, ' ')

  	entry += "\n  #{formatted_field} = \""	

  	entry += format_field_value(pub[field], 60, break_indent)
  	
  	entry += "\""
  end

  entry += "\n}\n\n"
  puts entry
end