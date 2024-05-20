require "http"
require "nokogiri"
require "csv"
require 'httparty'

desc "Scraping tyranids Data"

task({ :scrape_tyranids_data => :environment}) do
  legendsArray = Array.new
  url = 'https://wahapedia.ru/wh40k10ed/factions/tyranids/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/tyranids_stats.csv", "w") do |csv|
    csv << ["Unit_Name","Base_Size","Model_Name","Invurebale_Save","Desc","M","T","Sv","W","Ld","OC"] 
    #finds all Legends units and stores them in an array to be checked for later
    parsed_page.css('.sLegendary').each do |unit|
      unitname = unit.at_css('.dsH2Header')&.text&.strip || 'Unknown'
      base = unit.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
      unitname = unitname.gsub("#{base}", "")
      unitname = unitname.gsub("’","'")
      if unitname.length > 0
        legendsArray.push(unitname)
      else
      end
    end
    #end of Legends check
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
          #statline = String.new
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
          #checking against legends array before adding
          isLegends = false
            legendsArray.each do |check|
              if unitname === check
                isLegends = true
              end
            end
            if isLegends ===false 
              puts unitname
              csv << statline
            end
            #end Legends check
        end
      end

    end
  
  end
  CSV.open("lib/sample_data/tyranids_abilities.csv","w") do |csv|
    csv << ["Unit_Name", "Weapon_Ability","Core", "Faction", "Standard", "Wargear", "Cost", "Bodygaurd" ]
    parsed_page.css('.dsOuterFrame').each do |box|

      #Extracting Ability details
        name = box.at_css('.dsH2Header')&.text&.strip || 'Unknown'
        base = box.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
        name = name.gsub("#{base}", "")
        name = name.gsub("’","'")
        base = base.gsub("⌀", "")
        abilities_list = Array.new
        abilities_list << name
        box.css('.dsAbility').each do |ability|
          
          if /CORE/.match(ability.text.strip)
            #gets core and faction 
            if !abilities_list[1]
              abilities_list << ["Weapon", "*"]
            end
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            abilities_list << thing
          elsif /FACTION/.match(ability.text.strip)

            if !abilities_list[2]
              abilities_list << ["Weapon", "*"]
              abilities_list << ["CORE", "*"]
            end
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
          elsif /<td>/.match(ability.to_s)
            #model size and cost
            if !abilities_list[5]
              abilities_list << [["Wargear", "*"]]
            end
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
            elsif /This unit can be led by the following unit/.match(ability.to_s)
            elsif /<b>/.match(ability.to_s)
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
                #puts final_ability
                holder_aray << final_ability
              end
              abilities_list << holder_aray
            
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
                    #checking against legends array before adding
                    isLegends = false
                    legendsArray.each do |check|
                      if name === check
                        isLegends = true
                      end
                    end
                    if isLegends ===false 
                      puts name
                      csv << abilities_list
                    end
                    #end Legends check
         
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
        #checking against legends array before adding
        isLegends = false
        legendsArray.each do |check|
          if name === check
            isLegends = true
          end
        end
        if isLegends ===false 
          puts name
          csv << keyword_list
        end
        #end Legends check
        
      end
    end
  end
end
desc "Scraping astra militarum Data"
task({ :scrape_astra_militarum_data => :environment}) do
  legendsArray = Array.new
  url = 'https://wahapedia.ru/wh40k10ed/factions/astra-militarum/datasheets.html'
  page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(page)

  CSV.open("lib/sample_data/astra-militarum_stats.csv", "w") do |csv|
    csv << ["Unit_Name","Base_Size","Model_Name","Invurebale_Save","Desc","M","T","Sv","W","Ld","OC"]  
        #finds all Legends units and stores them in an array to be checked for later
        parsed_page.css('.sLegendary').each do |unit|
          unitname = unit.at_css('.dsH2Header')&.text&.strip || 'Unknown'
          base = unit.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
          unitname = unitname.gsub("#{base}", "")
          unitname = unitname.gsub("’","'")
          if unitname.length > 0
            legendsArray.push(unitname)
          else
          end
        end
        #end of Legends check
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
          profile.css(".dsCharFrameBack").each do |stat|
            x = stat.at_css('.dsCharValue')&.text&.strip
            statline << x.to_i
          end 
          #checking against legends array before adding
          isLegends = false
          legendsArray.each do |check|
            if unitname === check
              isLegends = true
            end
          end
          if isLegends ===false 
            puts unitname
            csv << statline
          end
          #end Legends check
        end
      end

    end
  
  end
  CSV.open("lib/sample_data/astra-militarum_abilities.csv","w") do |csv|
    csv << ["Unit_Name", "Weapon_Ability","Core", "Faction", "Standard", "Wargear", "Cost", "Bodygaurd" ]
    parsed_page.css('.dsOuterFrame').each do |box|

      #Extracting Ability details
        name = box.at_css('.dsH2Header')&.text&.strip || 'Unknown'
        base = box.at_css('.ShowBaseSize')&.text&.strip ||'Unknown'
        name = name.gsub("#{base}", "")
        name = name.gsub("’","'")
        name = name.gsub("‘","'")
        base = base.gsub("⌀", "")
        abilities_list = Array.new
        abilities_list << name
        wargear_abilities = Array.new
        box.css('.dsAbility').each do |ability|
          if /CORE/.match(ability.text.strip)
            #gets core and faction 
            if !abilities_list[1]
              abilities_list << ["Weapon", "*"]
            end
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            abilities_list << thing
          elsif /FACTION/.match(ability.text.strip)

            if !abilities_list[2]
              abilities_list << ["Weapon", "*"]
              abilities_list << ["CORE", "*"]
            end
            raw = ability.text.strip
            change1 = raw.gsub(":","*")
            change2 = change1.gsub(",","*")
            change3 =  change2.gsub("\"", "")
            thing = change3.split("*")
            abilities_list << thing
          elsif /This model is equipped with/.match(ability.to_s)
          elsif /is equipped with/.match(ability.to_s)
          elsif /This model can be attached to the following unit/.match(ability.text.strip)
            guard = Array.new
              ability.css("ul").each do |bullet|
                bullet.css("li").each do |guardian|

                guard << guardian.text
                end
                
              end
              abilities_list << guard
          elsif /<td>/.match(ability.to_s)
            #model size and cost
            if !abilities_list[5]
              if wargear_abilities.length != 0
                puts wargear_abilities
                abilities_list << wargear_abilities
              else
                puts wargear_abilities
                abilities_list << [["Wargear", "*"]]
              end
            end
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
            elsif /This unit can be led by the following unit/.match(ability.to_s)
            elsif /<b>/.match(ability.to_s) # need to add something to check for wargear
              #this gets the  ability name
              if !abilities_list[3]
                abilities_list << [["Faction","*"]]
              end
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
                #puts final_ability
                holder_aray << final_ability
              end
              if /Medi-pack/.match(ability.to_s)||/Regimental Standard/.match(ability.to_s)||/Command Rod/.match(ability.to_s)||/Master Vox/.match(ability.to_s)
                wargear_abilities << holder_aray
              else
              abilities_list << holder_aray
              end
            end

      
        end
          #checks if it is the first or second col
          #checking against legends array before adding
          isLegends = false
          legendsArray.each do |check|
            if name === check
              isLegends = true
            end
          end
          if isLegends ===false 
            puts name
            csv << abilities_list
          end
          #end Legends check
    end
  end
  CSV.open("lib/sample_data/astra-militarum_weapons.csv", "w") do |csv|
    
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
          #checking against legends array before adding
          isLegends = false
          legendsArray.each do |check|
            if name === check
              isLegends = true
            end
          end
          if isLegends ===false 
            puts name
            csv << [name, weapon_name, range, a, bs_ws, s, ap, d]
          end
          #end Legends check
            
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
        #checking against legends array before adding
        isLegends = false
        legendsArray.each do |check|
          if name === check
            isLegends = true
          end
        end
        if isLegends ===false 
          puts name
          csv << keyword_list
        end
        #end Legends check
        
      end
    end
  end
end
desc "old"



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
