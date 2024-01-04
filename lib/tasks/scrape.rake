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
    csv << ["Unit_Name","Base_Size","Model_Name","Invurebale_Save","Desc","M","T","Sv","W","Ld","OC"] 
    parsed_page.css('.dsOuterFrame').each do |frame|

      unitname = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      unitname = unitname.gsub("#{base}", "")
      unitname = unitname.gsub("’","'")
      base = base.gsub("⌀", "")
      invulerable = frame.at_css('.dsCharInvulBack')&.text&.strip|| '0'
      lore = frame.at_css('.tooltipstered')&.text&.strip||'records purged'
      
      frame.css(".dsProfileBaseWrap").each do |box|

        modelname = "#{box.at_css('.dsModelName')&.text&.strip || "#{unitname}"}"
        modelname = modelname.gsub("’","'")
        box.css(".dsProfileWrap").each do |profile|  
          statline = Array.new
          statline << unitname
          statline << base
          statline << modelname
          statline << invulerable
          statline << lore
          profile.css(".dsCharFrameBack").each do |stat|
            x = stat.at_css('.dsCharValue')&.text&.strip
            statline << x.to_i
          end 
          csv << statline
        end
      end

    end
  
  end
  CSV.open("lib/sample_data/tyranids_abilities.csv","w") do |csv|
    csv << ["Unit_Name","Core", "Faction", "Standard", "Wargear", "Cost", "Bodygaurd" ]
    parsed_page.css('.dsOuterFrame').each do |outerbox|
      name = outerbox.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = outerbox.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("#{base}", "")
      name = name.gsub("’","'")
      name = name.gsub("‘","'")
      base = base.gsub("⌀", "")
      abilities_list = Array.new
      # this pulls out the right column to parse
      outerbox.css('.dsRightСol').each do |box| # is iterating throught this twice tdk why
        #Extracting Ability details
        #Array that will be added to the csv
        if abilities_list.length === 0
         abilities_list << name
        end
        #Arrays that will hold the info and be put into abilties_list
        core_abilities = Array.new
        faction_abilities = Array.new
        standard_abilities = Array.new
        wargear_abilities = Array.new
        bodyguard_abilities = Array.new
        size_abilities = Array.new
        box.css('.dsAbility').each do |ability|
          if /CORE/.match(ability.text.strip)
            #gets core and faction 
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            core_abilities << thing
          elsif /FACTION/.match(ability.text.strip)
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            faction_abilities << thing
          elsif /This model is equipped with/.match(ability.to_s)
          elsif /is equipped with/.match(ability.to_s)
          elsif /This model can be attached to the following unit/.match(ability.text.strip)
            guard = Array.new
              ability.css("ul").each do |bullet|
                bullet.css("li").each do |guardian|

                guard << guardian.text
                end
                
              end
              bodyguard_abilities << guard
          elsif /<td>/.match(ability.to_s)
            #model size and cost
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
              size_abilities << modelsize
            elsif /This unit can be led by the following unit/.match(ability.to_s)
            elsif /<b>/.match(ability.to_s) # need to add something to check for wargear
              #this gets the  ability name
              holder_aray = Array.new
              abilitity_names = Array.new
              ability.css('b').each do |b|
                abilitity_names.push(b.text.strip)
                
              end
              raw = ability.text.strip
              raw = raw.gsub("TYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDS","Tyranids")
              raw = raw.gsub("’","'")
              raw =raw.gsub("\’","\'")
              abilitity_names.each do |abilname|
                if abilitity_names[0] != abilname
                  raw = raw.gsub(abilname, "*")
                else
                  raw = raw.gsub(abilname, "")
                end
              end
              ability_array = raw.split("*")
              if /<i>/.match(ability.to_s) 
                ability.css("i").each do |i|
                  raw = i.text.strip
                  raw = raw.gsub("’","'")
                  ability_array << raw
                end
              end
              abilitity_names.each do |abilname|
                final_ability = Array.new
                pos = abilitity_names.find_index{|x| x === abilname}
                final_ability << abilname
                final_ability << ability_array[pos]
                holder_aray << final_ability
              end
              if /Medi-pack/.match(ability.to_s)||/Regimental Standard/.match(ability.to_s)||/Command Rod/.match(ability.to_s)||/Master Vox/.match(ability.to_s)
                if !wargear_abilities[1]
                  wargear_abilities << holder_aray
                end
              else
              standard_abilities << holder_aray
              end
            end

      
        end
          #checks if the unit has an ability and if it does it adds it to the csv if it doesn't it adds a dummy value to maintain form
          if abilities_list.length === 1
            if core_abilities.length != 0
              abilities_list << core_abilities
            else
              abilities_list << ["CORE", "*"]
            end
            if faction_abilities.length != 0
              abilities_list << faction_abilities
            else
              abilities_list << ["FACTION","*"]
            end
            if standard_abilities.length != 0
              abilities_list << standard_abilities
            else
              abilities_list << ["STANDARD", "*"]
            end
            if wargear_abilities.length != 0
              abilities_list << wargear_abilities
            else
              abilities_list << ["WARGEAR","*"]
            end
            if size_abilities.length != 0
              abilities_list  << size_abilities
            else
              abilities_list << ["NA","NA"]
            end
            if bodyguard_abilities.length != 0
              abilities_list << bodyguard_abilities
            else
              abilities_list << ["BODYGUARD","NA"]
            end
          end

      end
      if abilities_list[2]
        csv << abilities_list
      end
    end
  end
  CSV.open("lib/sample_data/tyranids_weapons.csv", "w") do |csv|
    
    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("’","'")
      name = name.gsub("#{base}", "")
      base = base.gsub("⌀", "")
    # Extracting weapon details
      frame.css('.wTable').each do |table|
        table.css('tr').each do |row|
          next if row.at_css('.wTable_WEAPON') 
          if row.at_css('.wTable2_short')
            weapon_name = row.at_css('td:nth-child(2)')&.text&.strip || 'N/A'
            weapon_name = weapon_name.gsub("’","'")
            weapon_name = weapon_name.gsub("–","*")
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
  CSV.open("lib/sample_data/tyranids_keywords.csv", "w") do |csv|
    csv << ["Name", "Keyword"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("’","'")
      name = name.gsub("#{base}", "")
      base = base.gsub("⌀", "")
      keyword_list = Array.new
      keyword_list << name
      key_word_array = Array.new

      frame.css('.dsLeftСolKW').each do |key|
        raw = key.text.strip
        raw = raw.gsub("KEYWORDS: ","")
        key_array = Array.new
        key_array = raw.split(",")
       
        key_array.each do |keyword|
          key_word_array.push(keyword)

        end
        keyword_list << key_word_array
        csv << keyword_list
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
    csv << ["Unit_Name","Base_Size","Model_Name","Invurebale_Save","Desc","M","T","Sv","W","Ld","OC"]  
    parsed_page.css('.dsOuterFrame').each do |frame|

      unitname = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      unitname = unitname.gsub("#{base}", "")
      unitname = unitname.gsub("’","'")
      unitname = unitname.gsub("‘","'")
      base = base.gsub("⌀", "")
      invulerable = frame.at_css('.dsCharInvulBack')&.text&.strip|| '0'
      lore = frame.at_css('.tooltipstered')&.text&.strip||'records purged'
      
      frame.css(".dsProfileBaseWrap").each do |box|

        modelname = "#{box.at_css('.dsModelName')&.text&.strip || "#{unitname}"}"
        modelname = modelname.gsub("’","'")
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
    csv << ["Unit_Name","Core", "Faction", "Standard", "Wargear", "Cost", "Bodygaurd" ]
    parsed_page.css('.dsOuterFrame').each do |outerbox|
      name = outerbox.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = outerbox.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("#{base}", "")
      name = name.gsub("’","'")
      name = name.gsub("‘","'")
      base = base.gsub("⌀", "")
      abilities_list = Array.new
      # this pulls out the right column to parse
      outerbox.css('.dsRightСol').each do |box| # is iterating throught this twice tdk why
        #Extracting Ability details
        #Array that will be added to the csv
        if abilities_list.length === 0
         abilities_list << name
        end
        #Arrays that will hold the info and be put into abilties_list
        core_abilities = Array.new
        faction_abilities = Array.new
        standard_abilities = Array.new
        wargear_abilities = Array.new
        bodyguard_abilities = Array.new
        size_abilities = Array.new
        box.css('.dsAbility').each do |ability|
          if /CORE/.match(ability.text.strip)
            #gets core and faction 
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            core_abilities << thing
          elsif /FACTION/.match(ability.text.strip)
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            faction_abilities << thing
          elsif /This model is equipped with/.match(ability.to_s)
          elsif /is equipped with/.match(ability.to_s)
          elsif /This model can be attached to the following unit/.match(ability.text.strip)
            guard = Array.new
              ability.css("ul").each do |bullet|
                bullet.css("li").each do |guardian|

                guard << guardian.text
                end
                
              end
              bodyguard_abilities << guard
          elsif /<td>/.match(ability.to_s)
            #model size and cost
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
              size_abilities << modelsize
            elsif /This unit can be led by the following unit/.match(ability.to_s)
            elsif /<b>/.match(ability.to_s) # need to add something to check for wargear
              #this gets the  ability name
              holder_aray = Array.new
              abilitity_names = Array.new
              ability.css('b').each do |b|
                abilitity_names.push(b.text.strip)
                
              end
              raw = ability.text.strip
              raw = raw.gsub("TYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDSTYRANIDS","Tyranids")
              raw = raw.gsub("’","'")
              raw =raw.gsub("\’","\'")
              abilitity_names.each do |abilname|
                if abilitity_names[0] != abilname
                  raw = raw.gsub(abilname, "*")
                else
                  raw = raw.gsub(abilname, "")
                end
              end
              ability_array = raw.split("*")
              if /<i>/.match(ability.to_s) 
                ability.css("i").each do |i|
                  raw = i.text.strip
                  raw = raw.gsub("’","'")
                  ability_array << raw
                end
              end
              abilitity_names.each do |abilname|
                final_ability = Array.new
                pos = abilitity_names.find_index{|x| x === abilname}
                final_ability << abilname
                final_ability << ability_array[pos]
                holder_aray << final_ability
              end
              if /Medi-pack/.match(ability.to_s)||/Regimental Standard/.match(ability.to_s)||/Command Rod/.match(ability.to_s)||/Master Vox/.match(ability.to_s)
                if !wargear_abilities[1]
                  wargear_abilities << holder_aray
                end
              else
              standard_abilities << holder_aray
              end
            end

      
        end
          #checks if the unit has an ability and if it does it adds it to the csv if it doesn't it adds a dummy value to maintain form
          if abilities_list.length === 1
            if core_abilities.length != 0
              abilities_list << core_abilities
            else
              abilities_list << ["CORE", "*"]
            end
            if faction_abilities.length != 0
              abilities_list << faction_abilities
            else
              abilities_list << ["FACTION","*"]
            end
            if standard_abilities.length != 0
              abilities_list << standard_abilities
            else
              abilities_list << ["STANDARD", "*"]
            end
            if wargear_abilities.length != 0
              abilities_list << wargear_abilities
            else
              abilities_list << ["WARGEAR","*"]
            end
            if size_abilities.length != 0
              abilities_list  << size_abilities
            else
              abilities_list << ["NA","NA"]
            end
            if bodyguard_abilities.length != 0
              abilities_list << bodyguard_abilities
            else
              abilities_list << ["BODYGUARD","NA"]
            end
          end

      end
      if abilities_list[2]
        csv << abilities_list
      end
    end
  end
  CSV.open("lib/sample_data/astra_militarum_weapons.csv", "w") do |csv|
    
    csv << ["Name", "Weapon Name", "Range", "A", "BS/WS", "S", "AP", "D"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("’","'")
      name = name.gsub("‘","'")
      name = name.gsub("#{base}", "")
      base = base.gsub("⌀", "")
    # Extracting weapon details
      frame.css('.wTable').each do |table|
        table.css('tr').each do |row|
          next if row.at_css('.wTable_WEAPON') 
          if row.at_css('.wTable2_short')
            weapon_name = row.at_css('td:nth-child(2)')&.text&.strip || 'N/A'
            weapon_name = weapon_name.gsub("’","'")
            weapon_name = weapon_name.gsub("–","*")
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
  CSV.open("lib/sample_data/astra_keywords.csv", "w") do |csv|
    csv << ["Name", "Keyword"] 

    parsed_page.css('.dsOuterFrame').each do |frame|
      name = frame.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = frame.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      name = name.gsub("’","'")
      name = name.gsub("#{base}", "")
      base = base.gsub("⌀", "")
      keyword_list = Array.new
      keyword_list << name
      key_word_array = Array.new

      frame.css('.dsLeftСolKW').each do |key|
        raw = key.text.strip
        raw = raw.gsub("KEYWORDS: ","")
        key_array = Array.new
        key_array = raw.split(",")
       
        key_array.each do |keyword|
          key_word_array.push(keyword)

        end
        keyword_list << key_word_array
        csv << keyword_list
      end
    end
  end
end
