
namespace :slurp do
  desc "astra militarum data"
  task astra_militarum_data: :environment do 
    require "csv"
    require "json"
    #Stats
    csv_data = File.read(Rails.root.join("lib", "sample_data", "astra-militarum_stats.csv"))
    csv = CSV.parse(csv_data, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Astra Militarum"
    f.icon = "astra_militarum_icon.png"
    if Faction.where(name: f.name).last
    else
    f.save
    end
    csv.each do |row|
      #Reading unit from csv
      u = Unit.new
      u.name = row["Unit_Name"]
      u.faction_id = f.id
      u.base_size = row["Base_Size"]
      u.role = row["type"]
      if File.file?("app/assets/images/#{u.name.downcase.gsub(" ","_")}.jpeg")
        puts "Found image of #{u.name.downcase}"
        u.picture = "#{u.name.downcase.gsub(" ", "_")}.jpeg"
      else
        u.picture = f.icon
      end
      #checking if unit exists
      if Unit.where(name: u.name, faction_id: u.faction_id, base_size: u.base_size).last
        unit = Unit.where(name: u.name, faction_id: u.faction_id, base_size: u.base_size).last
        m = Model.new
        m.name = row["Model_Name"]
        m.invulnerable_save = row["Invurebale_Save"]
        m.leadership = row["Ld"]
        m.movement = row["M"]
        m.objective_control = row["OC"]
        m.save_value = row["Sv"]
        m.toughness = row["T"]
        m.wounds = row["W"]
        m.unit_id = Unit.where(name: u.name).first.id
        #Checking if model exists in database
        if Model.where(name: m.name, invulnerable_save: m.invulnerable_save, leadership: m.leadership, movement: m.movement, objective_control: m.objective_control, save_value: m.save_value, toughness: m.toughness, wounds: m.wounds, unit_id: m.unit_id).last
        else
          m.save
        end
      else
        u.save
        #Reading Model from csv
        m = Model.new
        m.name = row["Model_Name"]
        m.invulnerable_save = row["Invurebale_Save"]
        m.leadership = row["Ld"]
        m.movement = row["M"]
        m.objective_control = row["OC"]
        m.save_value = row["Sv"]
        m.toughness = row["T"]
        m.wounds = row["W"]
        m.unit_id = Unit.where(name: u.name).first.id
        #Checking if model exists in database
        if Model.where(name: m.name, invulnerable_save: m.invulnerable_save, leadership: m.leadership, movement: m.movement, objective_control: m.objective_control, save_value: m.save_value, toughness: m.toughness, wounds: m.wounds, unit_id: m.unit_id).last
        else
          m.save
        end
      end
    end
    #Weapons
    csv_weapon = File.read(Rails.root.join("lib", "sample_data", "astra-militarum_weapons.csv"))
    csv = CSV.parse(csv_weapon, :headers => true, :encoding => "ISO-8859-1")
    
      csv.each do |row|
        unit = Unit.where(name: row["Unit_Name"]).last
        puts unit.name
        model = Model.where(name: row["Name"], unit_id: unit.id).first
        puts row["Weapon Name"]
        puts model.id
        csv_weapon = Weapon.new
        #Checks if there is a -
        profile = String.new
        if row["Weapon Name"].include?("*")
          holder = row["Weapon Name"].split("*")
          csv_weapon.name = holder[0]
          profile = holder[1]
          puts csv_weapon.name
          puts profile
        else
          csv_weapon.name = row["Weapon Name"] 
        end
        if row["Range"] === "Melee"
          csv_weapon.range = 0
        else
          csv_weapon.range = row["Range"].to_i
        end
        #csv_weapon has been read
        csv_profile = Profile.new
        csv_profile.armor_piercing = row["AP"].to_i
        csv_profile.attacks  = row["A"]
        csv_profile.damage = row["D"]
        if profile.length != 0
          puts "hi"
          csv_profile.name = profile
        else
          csv_profile.name = row["Weapon Name"]
        end
        csv_profile.skill = row["BS/WS"].to_i
        csv_profile.strength = row["S"].to_i
        #csv_profile has been read
        if Weapon.where(name: csv_weapon.name, range: csv_weapon.range).last
          weapon = Weapon.where(name: csv_weapon.name, range: csv_weapon.range).last
          #checks if the profile exists in the database
          if Profile.where(armor_piercing: csv_profile.armor_piercing, damage: csv_profile.damage, name: csv_profile.name, skill: csv_profile.skill, strength: csv_profile.strength,weapon_id: weapon.id).last

            if Equipment.where(model_id: model.id, weapon_id: weapon.id).last
              puts "#{model.name} already has this #{weapon.name} equipment" 
            else
              equipment = Equipment.new
              equipment.weapon_id = weapon.id
              equipment.model_id = model.id
              equipment.save
            end
          else
            #checks if any equipment match the unit and weapon
            if  Equipment.where(weapon_id: weapon.id, model_id: model.id).last
              puts " allready has this equipment"
              csv_profile.weapon_id = weapon.id
              csv_profile.save
            else
              csv_weapon.save
              weapon = Weapon.all.last
              csv_profile.weapon_id = weapon.id
              csv_profile.save
              profile = Profile.all.last
              equipment = Equipment.new
              equipment.model_id = model.id
              equipment.weapon_id = weapon.id
              equipment.save
              puts "New weapons profile for #{model.name} added"
            end
          end
        else
          csv_weapon.save
          weapon = Weapon.all.last
          csv_profile.weapon_id = weapon.id
          csv_profile.save
          profile = Profile.all.last
          equipment = Equipment.new
          #puts model.id
          equipment.model_id = model.id
          equipment.weapon_id = weapon.id
          equipment.save
        end
      end
      #Doing the Abilities
      csv_ability = File.read(Rails.root.join("lib", "sample_data", "astra-militarum_abilities.csv"))
      csv = CSV.parse(csv_ability, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        name = row["Unit_Name"]
        unit = Unit.where(name: name).last
        core = JSON.parse(row["Core"])
        core.each do |ability|
          #Core abilities
          if ability === "CORE"|| ability === "*" || ability === "core"||ability === "Core"
          else
            #puts name
            #puts ability
            if Ability.where(name: ability).last
              #Checks if the ability exists if it does it makes a new point to the unit
              a = Ability.where(name: ability).last
              u = UnitAbility.new
              u.ability_id = a.id
              u.unit_id = unit.id
              u.save
            else
              #Ability doesn't exist so it make a new ability and pointer
              u = UnitAbility.new
              a = Ability.new
              a.name = ability
              a.classification = "core"
              a.save
              new_ability = Ability.all.last
              u.unit_id = unit.id
              u.ability_id = Ability.where(name: ability).last.id
              u.save
            end
          end
        end
          #Faction abilities
          faction = JSON.parse(row["Faction"])
          faction.each do |ability|
            if ability === "Faction"|| ability === "*" || ability === "FACTION"
            else
              if Ability.where(name: ability).last
                #checks if the ability exists
                a = Ability.where(name: ability).last
                u = UnitAbility.new
                u.ability_id = a.id
                u.unit_id = unit.id
                u.save
              else
                u = UnitAbility.new
                a = Ability.new
                a.name = ability
                a.classification = "faction"
                a.save
                new_ability = Ability.all.last

                u.unit_id = unit.id
                #puts a.name
                u.ability_id = Ability.where(name: ability).last.id
                u.save
              end
            end
          end
          #Standard abilities
          standard = Array.new
          puts row["Standard"]
          faction = JSON.parse(row["Faction"])
          standard = JSON.parse(row["Standard"])
          standard.each do |ability|
            if Ability.where(name:  ability[0], description: ability[1]).last
              #Checks if the ability exists
              a = Ability.where(name: ability).last
              u = UnitAbility.new
              u.ability_id = a.id
              u.unit_id = unit.id
              u.save
            else
              u = UnitAbility.new
              a = Ability.new
              a.name = ability[0]
              a.description = ability[1]
              a.classification = "standard"
              a.save
              new_ability = Ability.all.last
              
              u.unit_id = unit.id
              u.ability_id = Ability.where(name: ability).last.id
              u.save
            end
          end
          cost = JSON.parse(row["Cost"])
          unit.models_per_unit = cost[0][0]
          unit.max_size = cost.length()
          unit.cost = cost[0][1]
          unit.save
          #Wargear
          wargear = JSON.parse(row["Wargear"])
            wargear.each do |gear|
              
              if gear[0] === "Wargear"
              else
                ability = Ability.new
                ability.name = gear[0]
                ability.description = gear[1]
                ability.classification = "wargear"
                if Ability.where(name:  ability.name, description: ability.description).last
                  #Checks if the wargear exists
                  a = Ability.where(name: ability.name).last
                  u = UnitAbility.new
                  u.ability_id = a.id
                  u.unit_id = unit.id
                  u.save
                  #puts ability.name
                else
                  u = UnitAbility.new
                  ability.save
                  new_ability = Ability.all.last
                  u.unit_id = unit.id
                  u.ability_id = new_ability.id
                  u.save
                end
              end
            end
          #Bodygaurds
        
      end
      #Keywords
  end
  desc "tyranid data"
  task tyranid_data: :environment do 
    require "csv"
    require "json"
    #Stats
    csv_data = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_data, :headers => true, :encoding => "ISO-8859-1")
    user = User.new
    user.email = "jake@email.com"
    user.admin = true
    user.password = "password"
    user.save
    f = Faction.new
    f.name = "Tyranids"
    f.icon = "tyranids_icon.png"
    puts f.valid?
    f.save
    csv.each do |row|
      #Reading unit from csv
      u = Unit.new
      u.name = row["Unit_Name"]
      u.faction_id = f.id
      u.base_size = row["Base_Size"]    
      u.role =row["type"]
      
      if File.file?("app/assets/images/#{u.name.downcase.gsub(" ","_")}.jpeg")
        puts "Found image of #{u.name.downcase}"
        u.picture = "#{u.name.downcase.gsub(" ","_")}.jpeg"
      else
        u.picture = f.icon
      end
      #checking if unit exists
      #all check
      if u.valid?
        u.save
        puts "New unit added with name #{u.name}"
      else
        u = Unit.where(name: u.name).first
        puts "The unit #{u.name} already exists"
      end
      m = Model.new
        m.name = row["Model_Name"]
        m.invulnerable_save = row["Invurebale_Save"]
        m.leadership = row["Ld"]
        m.movement = row["M"]
        m.objective_control = row["OC"]
        m.save_value = row["Sv"]
        m.toughness = row["T"]
        m.wounds = row["W"]
    
        m.unit_id = Unit.where(name: u.name).first.id
        #new model check
        if m.valid?
          m.save
          puts "New model added with the name #{m.name}"
        else
          m = Model.where(name: m.name, unit_id: m.unit_id).last
          puts "The model #{m.name} already exists"
        end
    end
    #Weapons
    csv_weapon = File.read(Rails.root.join("lib", "sample_data", "tyranids_weapons.csv"))
    csv = CSV.parse(csv_weapon, :headers => true, :encoding => "ISO-8859-1")
    
      csv.each do |row|
        #need to change this when i fix scrap for militarum
        unit = Unit.where(id: Model.where(name: row["Name"]).first.unit).last
        weapon = Weapon.new
        #Checks if there is a -
        profile_name = String.new
        if row["Weapon Name"].include?("*")
          holder = row["Weapon Name"].split("*")
          weapon.name = holder[0]
          profile = holder[1]
        else
          weapon.name = row["Weapon Name"] 
        end
        if row["Range"] === "Melee"
          weapon.range = 0
        else
          weapon.range = row["Range"].to_i
        end
        #csv_weapon has been read
        profile = Profile.new
        profile.armor_piercing = row["AP"].to_i
        profile.attacks  = row["A"]
        profile.damage = row["D"]
        if profile_name.length != 0
          profile.name = profile_name
        else
          profile.name = row["Weapon Name"]
        end
        profile.skill = row["BS/WS"].to_i
        weapon.skill = row["BS/WS"].to_i
        profile.strength = row["S"].to_i
        #csv_profile has been read
        #checking validity of the weapon
        if weapon.valid?
          weapon.save
          puts "The weapon #{weapon.name} has been added"
        else 
          weapon = Weapon.where(name: weapon.name, range: weapon.range, skill: weapon.skill).last
          puts "The weapon #{weapon.name} already exists"
        end
        profile.weapon_id = weapon.id
        if profile.valid?
          puts "The profile #{profile.name} has been added"
          profile.save
        else
          profile = Profile.where(name: profile.name, weapon: profile.weapon_id).last
          puts "The profile #{profile.name} already exists"
        end
        equipment = Equipment.new
        equipment.weapon_id = weapon.id
        equipment.unit_id = unit.id
        if equipment.valid?
          equipment.save
          puts "#{unit.name} now has #{weapon.name} as equipment"
        else
          puts "#{unit.name} already has #{weapon.name} as equipment"
        end
      end
      #Doing the Abilities
      csv_ability = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities.csv"))
      csv = CSV.parse(csv_ability, :headers => true, :encoding => "ISO-8859-1")
      csv.each do |row|
        name = row["Unit_Name"]
        unit = Unit.where(name: name).last
        core = JSON.parse(row["Core"])
        core.each do |csv_ability|
          #Core abilities
          #Checking for empty values
          if csv_ability === "CORE"||csv_ability ==="*"
          else
            ability = Ability.new
            ability.name = csv_ability
            ability.classification = "CORE"
            #Checking validity of ability
            if ability.valid?
              ability.save
              puts "#{ability.name} has been added"
            else
              ability = Ability.where(name: ability.name).last
              puts "#{ability.name} already exists"
            end
            unit_ability = UnitAbility.new
            unit_ability.unit_id = unit.id
            unit_ability.ability_id = ability.id
            #Checking that the unit has the ability
            if unit_ability.valid?
              unit_ability.save
              puts "#{unit.name} now has the ability #{ability.name}"
            else
              puts "#{unit.name} already has the ability #{ability.name}" 
            end
          end
        end
        #end of core
        #start of faction
        core = JSON.parse(row["Faction"])
        core.each do |csv_ability|
          if csv_ability === "FACTION"||csv_ability ==="*"
          else
            ability = Ability.new
            ability.name = csv_ability
            ability.classification = "FACTION"
            #Checking validity of ability
            if ability.valid?
              ability.save
              puts "#{ability.name} has been added"
            else
              ability = Ability.where(name: ability.name).last
              puts "#{ability.name} already exists"
            end
            unit_ability = UnitAbility.new
            unit_ability.unit_id = unit.id
            unit_ability.ability_id = ability.id
            #Checking that the unit has the ability
            if unit_ability.valid?
              unit_ability.save
              puts "#{unit.name} now has the ability #{ability.name}"
            else
              puts "#{unit.name} already has the ability #{ability.name}" 
            end
          end
        end
        #end of faction
        #start of Standard
        core = JSON.parse(row["Standard"])
        core.each do |csv_ability|
          ability = Ability.new
          ability.classification = "STANDARD"
          ability.name = csv_ability[0]
          ability.description = csv_ability[1]
          puts ability.name
          puts ability.description
          if ability.valid?
            ability.save
            puts "#{ability.name} has been added"
          else
            puts "#{ability.name} already exists"
            ability = Ability.where(name: ability.name).last
          end
          unit_ability = UnitAbility.new
          unit_ability.unit_id = unit.id
          unit_ability.ability_id = ability.id
          if unit_ability.valid?
            unit_ability.save
            puts "#{unit.name} now has the #{ability.name} ability"
          else
            puts "#{unit.name} already has the #{ability.name} ability"
          end
        end
        #end of standard
        #start of wargear
        core = JSON.parse(row["Wargear"])
        core.each do |csv_ability|
          #removing empty values
          if csv_ability[0]=== "Wargear"
          else
            ability = Ability.new
            ability.name = csv_ability[0]
            ability.description = csv_ability[1]
            ability.classification = "WARGEAR"
            if ability.valid?
              ability.save
              puts "#{ability.name} ability has been add"
            else
              puts "#{ability} already exists"
              ability = Ability.where(name: ability.name).last
            end
            unit_ability = UnitAbility.new
            unit_ability.unit_id = unit.id
            unit_ability.ability_id = ability.id
            if unit_ability.valid?
              unit_ability.save
              puts "#{unit.name} now has the wargear #{ability.name}"
            else
              puts "#{unit.name} already has #{ability.name} wargear"
            end
          end
        end
        #end of wargear
        #start of size
          cost = JSON.parse(row["Cost"])
          unit.models_per_unit = cost[0][0]
          unit.max_size = cost.length()
          unit.cost = cost[0][1]
          unit.save
        #old
          
        
      end
    end
      #Keywords
  end
  
