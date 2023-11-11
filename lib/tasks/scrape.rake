require "http"
require "nokogiri"
require "csv"
desc "Scraping Unit Data"

task({ :scrape_unit_data => :environment}) do
     url = "https://wahapedia.ru/wh40k10ed/factions/tyranids/datasheets.html"
    webpage = HTTP.get(url)
    document = Nokogiri::HTML( webpage.body.to_s )
    raw_data = document.css(".dsBannerWrap")
    units_data = raw_data.each do |data|
      namebase = data.css('.dsH2Header').text
      pp namebase
      raw_name = namebase.to_s
      if data.css('.dsInvulWrap')
        raw_invul = data.css('.dsInvulWrap').text
        {
          name: raw_name,
          invul: raw_invul
        }
      else
        {
          name: raw_name
        }
      end
    end
    puts units_data[1].invul
    #CSV.open("lib/sample_data/unit_data.csv", "a+") do |csv|
     # units_data.each do |unit|
      #  csv << [unit]
      #end
    #end
end
