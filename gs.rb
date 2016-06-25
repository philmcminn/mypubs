require 'net/http'
require 'uri'

def scrape_google_scholar_cites(user, page_size=1000)
  url = "https://scholar.google.co.uk/citations?user=#{user}&pagesize=#{page_size}"
  page_content = Net::HTTP.get(URI.parse(url))
  page_content.scan(/\<a .*?cites=(.*?)" class="gsc_a_ac"\>(.*?)\<\/a\>/)
end

refs = scrape_google_scholar_cites(ARGV[0])
csv = ''
refs.each do |ref|
  csv += "#{ref[0]},#{ref[1]}\n"
end
date_time_now = Time.now.strftime("%Y-%m-%d %H-%M")
file_name = "./cites/#{date_time_now}.csv"
File.write(file_name, csv)