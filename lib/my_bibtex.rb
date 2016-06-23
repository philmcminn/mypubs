require 'bibtex'
require 'net/http'
require 'uri'

def scrape_google_scholar_cites(user, page_size=1000) 
  url = "https://scholar.google.co.uk/citations?user=#{user}&pagesize=#{page_size}"
  page_content = Net::HTTP.get(URI.parse(url))  
  refs = []
  page_content.scan(/\<a .*?cites=(.*?)" class="gsc_a_ac"\>(.*?)\<\/a\>/) do |ref|
    refs << ref
  end
  refs
end

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

def format_pub(pub, fields=nil, wrap_at=120)
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

def prettify(bib_in, bib_out, wrap_at=120, fields=nil)
  pubs = BibTeX.open(bib_in)

  bib_data = ""
  pubs.each do |pub|
    bib_data += format_pub(pub, fields, wrap_at)
  end

  File.open(bib_out, "w") {|f| f.write(bib_data) }
end

def get_venues(bib_in)
  pubs = BibTeX.open(bib_in)
  venues = []

  pubs.each do |pub|
    if pub.type.to_s == 'inproceedings'
      if pub.field? 'booktitle'
        venues << pub['booktitle'].strip
      else
        abort "#{pub.id} is a conference publication without a 'booktitle' field"
      end
    elsif pub.type.to_s == 'article'
      if pub.field? 'journal'
        venues << pub['journal'].strip
      else
        abort "#{pub.id} is a journal publication without a 'journal' field"
      end
    end
  end

  venues = venues.uniq
  venues.sort
end

def count(bib_in)
  pubs = BibTeX.open(bib_in)
  types = Hash.new

  pubs.each do |pub|
    type = pub.type.to_s
    types[type] = 0 unless types.key? type
    types[type] += 1
  end

  puts "Publication statistics"
  puts "----------------------"
  total = 0
  types.keys.sort.each do |type|
    count = types[type]
    puts "#{type}: #{count}"
    total += count
  end
  puts "----------------------"
  puts "Total: #{total}"
end

def get_keys(bib_in) 
  pubs = BibTeX.open(bib_in)
  keys = Array.new

  pubs.each do |pub|
    keys << pub.id
  end

  return keys
end
