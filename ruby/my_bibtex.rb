require 'bibtex'
require 'htmlentities'

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

def format_pub(pub, fields=nil, wrap_at=60)
  fields = pub.field_names if fields.nil?

  max_field_len = 0
  fields.each do |field|
    max_field_len = field.length if field.length > max_field_len
  end

  str = "@#{pub.type}{#{pub.id},"
	  
  first_field = true
  break_indent = max_field_len + 7

  fields.each do |field| 
  	next unless pub.field?(field)

  	if first_field then first_field = false else str += "," end

  	key = field.to_s.ljust(max_field_len, ' ')
  	value = format_field_value(pub[field], wrap_at, break_indent)

  	str += "\n  #{key} = \"#{value}\""
  end

  str += "\n}\n\n" 
  return str
end

def pretify(bib_in, bib_out, fields=nil) 
  pubs = BibTeX.open(bib_in)
  
  bib_data = ""
  pubs.each do |pub|
    bib_data += format_pub(pub, fields)
  end
  
  File.open(bib_out, "w") {|f| f.write(bib_data) }
end

def to_html(value)
  HTMLEntities.new.encode(value.convert(:latex))
end

def html_tag_wrap(tag, value)
  "<#{tag}>" + to_html(value) + "</#{tag}>"
end

def format_pub_html(pub) 

  html = 
  	html_tag_wrap("h1", pub.title) + "\n" +
  	html_tag_wrap("h2", pub.authors) + "\n" + 
  	html_tag_wrap("p", pub.abstract)
  
  puts html
end

pubs = BibTeX.open('../bibtex/mcminn.bib')
format_pub_html(pubs[:Fraser2015])