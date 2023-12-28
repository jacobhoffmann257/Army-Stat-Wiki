desc "tyranid data"
  namespace :slurp do
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

    end
    task tyranid_weapons: :environment do
      csv_weapon = File.read(Rails.root.join("lib", "sample_data", "tyranids_weapons.csv"))
      csv = CSV.parse(csv_weapon, :headers => true, :encoding => "ISO-8859-1")
      
        csv.each do |row|
          #need to change this when i fix scrap for militarum
          unit = Unit.where(name: row["Name"]).last
          weapon = Weapon.new
          #Checks if there is a -
          profile_name = String.new
          if row["Weapon Name"].include?("*")
            holder = row["Weapon Name"].split("*")
            weapon.name = holder[0]
            profile_name = holder[1]
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
          puts equipment.weapon_id.to_s
          puts equipment.unit_id.to_s
          if equipment.valid?
            equipment.save
            puts "#{unit.name} now has #{weapon.name} as equipment"
          else
            puts "#{unit.name} already has #{weapon.name} as equipment"
          end
        end
  end
  task tyranid_abilities: :environment do 
    csv_ability = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities.csv"))
    csv = CSV.parse(csv_ability, :headers => true, :encoding => "ISO-8859-1")
    
    csv.each do |row|
      name = row["Unit_Name"]
      #puts name
      unit = Unit.where(id: Model.where(name: row["Unit_Name"]).first.unit_id).last
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
      #end of size
    end
  end
end
end
