require_relative 'lib/my_bibtex'

BIB_FILE = 'mcminn.bib'
MOD_BIB_FILE = 'mcminn.mod.bib'
WRAP_AT = 80
REPOS_DIR = File.dirname(__FILE__) + '/../'

task :prettify do
  fields = %w(
    author
    title
    booktitle
    editor
    journal
    series
    volume
    number
    pages
    month
    year
    location
    publisher
    institution
    doi
    gsid
    gscites
    url
    jv
    abstract
    comment
    sponsor
  )
  prettify(BIB_FILE, MOD_BIB_FILE, WRAP_AT, fields)
end

task :accept_mods do
  `mv #{MOD_BIB_FILE} #{BIB_FILE}`
end

task :output_venues do
  get_venues(BIB_FILE).each do |venue|
    puts venue
  end
end

task :count do
  count(BIB_FILE)
end

task :update_repos do
  Dir.entries(REPOS_DIR).each do |entry|
    fully_qualifed = REPOS_DIR + entry
    if File.directory?(fully_qualifed) && entry != '.' && entry != '..'
      puts "Updating #{fully_qualifed}"
      `rpl "#{fully_qualifed}"`
    end
  end
end

task :checkout_repos do
  get_keys(BIB_FILE).each do |key|
    fully_qualifed = REPOS_DIR + key
    unless File.directory?(fully_qualifed)
      puts "Checking out #{key}"
      `git clone git@bitbucket.org:philmcminn-personal/#{key}.git`
    end
  end 
end