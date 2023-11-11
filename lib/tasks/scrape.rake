require "http"
require "nokogiri"
require "csv"
require 'httparty'

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



desc "Scraping tyranids Data"

task({ :scrape_tyranids_data => :environment}) do

  url = 'https://wahapedia.ru/wh40k10ed/factions/tyranids/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/tyranids_stats.csv", "w") do |csv|
    csv << ["Name", "M", "T", "Sv", "W", "Ld", "OC"] 
    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'

      m = frame.at_css('.dsCharName:contains("M") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
      t = frame.at_css('.dsCharName:contains("T") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
      sv = frame.at_css('.dsCharName:contains("Sv") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
      w = frame.at_css('.dsCharName:contains("W") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
      ld = frame.at_css('.dsCharName:contains("Ld") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
      oc = frame.at_css('.dsCharName:contains("OC") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'

      csv << [name, m, t, sv, w, ld, oc]
    end
  end

  CSV.open("lib/sample_data/tyranids_weapons.csv", "w") do |csv|

    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"]  # Headers for the CSV

  parsed_page.css('.dsOuterFrame').each do |frame|
    name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'

    # Extracting weapon details
    frame.css('.wTable').each do |table|
      table.css('tr').each do |row|
        next if row.at_css('.wTable_WEAPON')  # Skip header rows

        weapon_name = row.at_css('td:nth-child(2)')&.text&.strip || 'N/A'
        range = row.at_css('td:nth-child(3) .ct')&.text&.strip || 'N/A'
        a = row.at_css('td:nth-child(4) .ct')&.text&.strip || 'N/A'
        bs_ws = row.at_css('td:nth-child(5) .ct')&.text&.strip || 'N/A'
        s = row.at_css('td:nth-child(6) .ct')&.text&.strip || 'N/A'
        ap = row.at_css('td:nth-child(7) .ct')&.text&.strip || 'N/A'
        d = row.at_css('td:nth-child(8) .ct')&.text&.strip || 'N/A'

        csv << [name, weapon_name, range, a, bs_ws, s, ap, d]
      end
    end
  end
    
  end
end
