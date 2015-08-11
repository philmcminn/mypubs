require 'bibtex'
require_relative 'my_bibtex.rb'

def author_html(pub)

  num_authors = pub.authors.count
    i = 0
    author_html = ''

    pub.authors.each do |author|
      i += 1
      if i > 1
        if i == num_authors
          author_html += ' and '
        else
          author_html += ', '
        end
      end

      author.convert!(:latex)
      author_html += author.first + ' ' + author.last
    end

    author_html + '.'
end

def title_html(pub)
  title_html = pub.title
  if pub.field?('url')
    url = pub['url'].sub('http://philmcminn.staff.shef.ac.uk', '')
    title_html = '<a href="' + url + '>' + title_html + '</a>'
  end

  '"' + title_html + '"' + '.'
end

def where_html(pub)
  case pub.type
    when :article
      return pub['journal'].to_s
    when :inproceedings
      return 'Proceedings of the ' + pub['booktitle'].to_s
    else
      return ''
  end
end

def pubs_html(pubs)
  html = "<ul>\n"
  pubs.each do |pub|

    author = author_html(pub)
    title = title_html(pub)
    where = where_html(pub)
    year = pub['year'].to_s
    if where.include?(year)
      year = ''
    else
      year = ", #{year}"
    end

    html += "  <li>\n" +
            "    #{author}<br/> \n" +
            "    #{title}<br />\n" +
            "    #{where}#{year}\n" +
            "  </li>\n"
  end

  html += "</ul>\n"
end

pubs = BibTeX.open('../bibtex/mcminn.bib')
puts pubs_html(pubs)