require "http"
require "nokogiri"
require "csv"
desc "Scraping Unit Data"

task({ :scrape_unit_data => :environment}) do
url = "https://wahapedia.ru/wh40k10ed/factions/tyranids/datasheets.html"
webpage = HTTP.get(url)
parsed_page = Nokogiri::HTML( webpage.body.to_s )
total = parsed_page.css(".dsBannerWrap")
#div_links = parsed_page.css("div").css("a").children
#links.each do |link|
 # p link.text
  
#end
CSV.open("lib/sample_data/unit_data.csv", "a+") do |csv|
  total.each do |unit|
    csv << [unit]
  end
end
end
