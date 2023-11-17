require "http"
require "nokogiri"
require "csv"
require 'httparty'

desc "Scraping tyranids Data"

task({ :scrape_tyranids_data => :environment}) do

  url = 'https://wahapedia.ru/wh40k10ed/factions/tyranids/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/tyranids_stats.csv", "w") do |csv|
    csv << ["Model Name","Base Size", "Invurebale Save", "M", "T", "Sv", "W", "Ld", "OC"]  
    parsed_page.css('.dsOuterFrame').each do |frame|

      unitname = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      unitname = unitname.gsub("#{base}", "")
      invulerable = frame.at_css('.dsCharInvulBack')&.text&.strip|| '0'
      lore = frame.at_css('.tooltipstered')&.text&.strip||'records purged'
      
      frame.css(".dsProfileBaseWrap").each do |box|

        modelname = "#{box.at_css('.dsModelName')&.text&.strip || "#{unitname}"}"
        box.css(".dsProfileWrap").each do |profile|  
          #statline = String.new
          statline = Array.new
          statline << unitname
          statline << base
          statline << modelname
          statline << invulerable
          statline << lore
          #statline.concat("#{name}")
          profile.css(".dsCharFrameBack").each do |stat|
            x = stat.at_css('.dsCharValue')&.text&.strip
            statline << x.to_i
          end 
          csv << statline
        #m = profile.at_css('.dsCharName:contains("M") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
        #t = profile.at_css('.dsCharName:contains("T") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
        #sv = profile.at_css('.dsCharName:contains("Sv") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
        #w = profile.at_css('.dsCharName:contains("W") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
        #ld = profile.at_css('.dsCharName:contains("Ld") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'
        #oc = profile.at_css('.dsCharName:contains("OC") + .dsCharFrame .dsCharValue')&.text&.strip || 'N/A'

        #csv << [name, m, t, sv, w, ld, oc]
        end
      end

    end
  
  end
  CSV.open("lib/sample_data/tyranids_abilities.csv","w") do |csv|
    csv << ["Unit Name", "Name", "Description", "Aura", "Type" ]
    parsed_page.css('.dsOuterFrame').each do |box|
      name = box.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = box.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("#{base}", "")
      value = 1
      #Extracting Ability details
      abilities_list = Array.new
      abilities_list << name
      box.css('.dsAbility').each do |ability|
        if /CORE/.match(ability.text.strip) || /FACTION/.match(ability.text.strip)
           raw = ability.text.strip
           change1 = raw.gsub(":","*")
           change2 = change1.gsub(",","*")
           change3 =  change2.gsub("\"", "")
           thing = change3.split("*")
           abilities_list << thing
        elsif /This model is equipped with/.match(ability.text.strip)
        elsif /This model can be attached to the following unit/.match(ability.text.strip)
          guard = Array.new
            ability.css("ul").each do |bullet|
              bullet.css("li").each do |guardian|

              guard << guardian.text
              end
              
            end
            abilities_list << guard
            abilities_list << csv
        elsif /<td>/.match(ability.to_s)
          modelsize = Array.new
            ability.css("table").each do |table|
              table.css("tr").each do |row|
                raw = row.text.strip
                remove = raw.gsub("model","")
                removes = remove.gsub("s","")
                spilting = removes.split(" ")
                modelsize << spilting
              end
            end
            abilities_list << modelsize
          elsif /This model is equipped with:/.match(ability.to_s)
          elsif /model is equipped with/.match(ability.to_s)
          elsif /<b>/.match(ability.to_s)
            raw = ability.text.strip
            raw = raw.split(".")
            parsed = Array.new
            raw.each do |second|
              temp = second.split(":")
              #pp temp
              parsed << temp
            end
            pp parsed
            abilities_list << parsed


          elsif /<div class="dsLineHor">/.match(ability.to_s)
            raw = ability.text.strip
            raw = raw.split(".")
            parsed = Array.new
            raw.each do |second|
              temp = second.split(":")
              parsed << temp
            end

            abilities_list << parsed
        end

     
      end
        csv << abilities_list
    end
  end
  CSV.open("lib/sample_data/tyranids_weapons.csv", "w") do |csv|
    
    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("#{base}", "")
    # Extracting weapon details
      frame.css('.wTable').each do |table|
        table.css('tr').each do |row|
          next if row.at_css('.wTable_WEAPON') 
          if row.at_css('.wTable2_short')
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
end
desc "Scraping astra militarum Data"

task({ :scrape_astra_militarum_data => :environment}) do

  url = 'https://wahapedia.ru/wh40k10ed/factions/astra-militarum/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/astra_militarum_stats.csv", "w") do |csv|
    csv << ["Name", "M", "T", "Sv", "W", "Ld", "OC"] 
    parsed_page.css('.dsOuterFrame').each do |frame|

      unitname = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      unitname = unitname.gsub("#{base}", "")
      base = base.gsub("⌀","")
      invulerable = frame.at_css('.dsCharInvulBack')&.text&.strip|| '0'
      lore = frame.at_css('.tooltipstered')&.text&.strip||'records purged'
      
      frame.css(".dsProfileBaseWrap").each do |box|

        modelname = "#{box.at_css('.dsModelName')&.text&.strip || "#{unitname}"}"
        box.css(".dsProfileWrap").each do |profile|  
          #statline = String.new
          statline = Array.new
          statline << unitname
          statline << base
          statline << modelname
          statline << invulerable
          statline << lore
          #statline.concat("#{name}")
          profile.css(".dsCharFrameBack").each do |stat|
            x = stat.at_css('.dsCharValue')&.text&.strip
            statline << x.to_i
          end 
          csv << statline
        end
      end

    end
  end
  CSV.open("lib/sample_data/astra_militarum_abilities.csv","w") do |csv|
    csv << ["Unit Name", "Name", "Description", "Aura", "Cost", "Bodygaurd", "Wargear" ]
    parsed_page.css('.dsOuterFrame').each do |box|
      name = box.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = box.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("#{base}", "")
      base = base.gsub("⌀", "")
      #Extracting Ability details
      abilities_list = Array.new
      wargear = Array.new
      orders =  Array.new
      abilities_list << name
      box.css('.dsAbility').each do |ability|
        if /CORE/.match(ability.text.strip) || /FACTION/.match(ability.text.strip)
           raw = ability.text.strip
           change1 = raw.gsub(":","*")
           change2 = change1.gsub(",","*")
           change3 =  change2.gsub("\"", "")
           thing = change3.split("*")
           stuff = Array.new
           thing.each do |x|
           stuff << x
           end
           abilities_list << stuff
          elsif /This unit’s OFFICER/.match(ability.to_s)
            puts ability.text.strip
          elsif /Medi-pack/.match(ability.text.strip) || /Regimental Standard/.match(ability.text.strip) ||/Command Rod/.match(ability.text.strip)|| /Master Vox/.match(ability.text.strip)
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change3 =  change1.gsub("\"", "")
            thing = change3.split("*")
            stuff = Array.new
            thing.each do |x|
            wargear << x
            end

        elsif /This model is equipped with/.match(ability.text.strip)
        elsif /is equipped with/.match(ability.to_s)
        elsif /<b>/.match(ability.to_s)
          raw = ability.text.strip
          raw = raw.split(".")
          parsed = Array.new
          raw.each do |second|
            temp = second.split(":")
            #pp temp
            parsed << temp
          end
          abilities_list << parsed
        elsif /This model can be attached to the following unit/.match(ability.text.strip)
          guard = Array.new
            ability.css("ul").each do |bullet|
              bullet.css("li").each do |guardian|

              guard << guardian.text
              end
              
            end
            abilities_list << guard
          elsif /<td>/.match(ability.to_s)
          modelsize = Array.new
            ability.css("table").each do |table|
              table.css("tr").each do |row|
                raw = row.text.strip
                remove = raw.gsub("model","")
                removes = remove.gsub("s","")
                spilting = removes.split(" ")
                modelsize << spilting
              end
            end
            
            abilities_list << modelsize

        end
     
      end
      #pp wargear
      #pp orders
      abilities_list << wargear
        csv << abilities_list
    end
  end
  CSV.open("lib/sample_data/astra_militarum_weapons.csv", "w") do |csv|

    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
    name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
    
    # Extracting weapon details
      frame.css('.wTable').each do |table|
        table.css('tr').each do |row|
          next if row.at_css('.wTable_WEAPON') 
          if row.at_css('.wTable2_short')
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
  
end


desc "Scraping necrons Data"

task({ :scrape_necrons_data => :environment}) do

  url = 'https://wahapedia.ru/wh40k10ed/factions/necrons/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/necrons_stats.csv", "w") do |csv|
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

  CSV.open("lib/sample_data/necrons_weapons.csv", "w") do |csv|

    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
    name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'

    # Extracting weapon details
      frame.css('.wTable').each do |table|
        table.css('tr').each do |row|
          next if row.at_css('.wTable_WEAPON') 
          if row.at_css('.wTable2_short')
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
end
