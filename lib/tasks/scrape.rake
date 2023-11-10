require "http"
require "nokogiri"
require "csv"

desc "Scraping Unit Data"

task({ :scrape_unit_data => :environment}) do
  #Get List Of Slugs
  slugs = CSV.read('lib/sample_data/units.csv').map { |row| row.at(4) }

  #Get list of raw responses
  raw_responses = slugs.map { |slug| HTTP.get("https://wahapedia.ru/wh40k10ed/factions/tyranids/#{slug}") }

  documents = raw_responses.map { |response| Nokogiri::HTML(response.to_s) }

  units_data = documents.map do |doc|

    char_wraps = doc.css('.dsCharWrap')
    character_name = doc.css('.dsH2Header').text
    
    data = char_wraps.map do |wrap|
      
      stats = wrap.at('.dsCharName').text
      stats_points = wrap.at('.dsCharValue').text

      {
        character_name: character_name,
        stats: stats,
        stats_points:stats_points
      }
    end

    CSV.open("lib/sample_data/unit_data.csv", "a+") do |csv|

      existing = csv.entries
      data.each do |unit|
        unless existing.include?([unit[:character_name], unit[:stats], unit[:stats_points]])
          csv << [unit[:character_name], unit[:stats], unit[:stats_points]]
        end
      end
    end
  end
end
