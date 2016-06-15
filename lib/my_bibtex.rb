require 'bibtex'
require 'net/http'
require 'uri'

def scrape_google_scholar_info(paper_title)
  enc_uri = URI.escape '/scholar?q="'+paper_title+'"&num=1'

  Net::HTTP.start('scholar.google.com') do |http|
    req = Net::HTTP::Get.new(enc_uri)
    s = http.request(req).body
    pos1 = s.index('Cited by ')
    if pos1
      pos2 = s.index('</a>', pos1+9)
      citation_num = Integer(s[pos1+9, pos2-pos1-9])
      pos3 = s.rindex('cites', pos1)
      pos4 = s.index('amp', pos3)
      citation_id = s[pos3+6, pos4-pos3-7]

      {gsid: citation_id, gscites: citation_num}
    end
  end
end

def update_google_scholar_info(pub)
  info = scrape_google_scholar_info(pub.title)
  unless info.nil?
    pub['gsid'] = info[:gsid]
    pub['gscites'] = info[:gscites]
  end
end

def update_google_scholar_info_for_bib(bib, verbose=true)
  bib.each do |pub|
    print "#{pub.title}... "  if verbose
    info = scrape_google_scholar_info(pub.title)
    if info.nil?
      puts "NO DATA" if verbose
    else
      puts "cites: #{info[:gscites]}" if verbose
    end
    sleep(5)
  end
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