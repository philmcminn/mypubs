#!/usr/bin/ruby
#
# minimize.rb
#
# Strips out bibtex attributes that biblatex cannot handle very well.
#
# The script assumes that all extraneous attributes appear at the end
# of the entry, so deletes everything from the first attribute to the
# end of the entry. It is assumed the entry ends with a solo close
# brace '}'.

IN_FILE = 'mcminn.bib'
OUT_FILE = 'mcminn.min.bib'

remove = %w(doi gsid url abstract)

out = ''
pause = false

File.readlines(IN_FILE).each do |line|

  trimmed = line.strip

  if pause
  	pause = false if trimmed == '}'
  else
  	pause = true if trimmed.start_with?(*remove)
  end
  
  out += line if !pause
end

File.open(OUT_FILE, "w") {|f| f.write(out) }
