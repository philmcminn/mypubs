#!/usr/local/bin/ruby
require 'net/http'
require 'uri'

def get_google_scholar_info(paper_title)
  enc_uri = URI.escape '/scholar?q="'+paper_title+'"&num=1'
  
  puts enc_uri

  Net::HTTP.start('scholar.google.com') do |http|
    req = Net::HTTP::Get.new(enc_uri)
    s = http.request(req).body
    puts s
    pos1 = s.index('Cited by ')
    if pos1
      pos2 = s.index('</a>', pos1+9)
      citation_num = Integer(s[pos1+9, pos2-pos1-9])
      pos3 = s.rindex('cites', pos1)
      pos4 = s.index('amp', pos3)
      citation_id = s[pos3+6, pos4-pos3-7]
  
      {gsid: citation_id, cites: citation_num}  
    end
  end
end

puts get_google_scholar_info 'Search‐based software test data generation: a survey'