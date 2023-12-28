desc "astra militarum data"
namespace :slurp do
  task astra_militarum: :environment do 
    require "csv"
    require "json"
    #Stats
    csv_data = File.read(Rails.root.join("lib", "sample_data", "astra-militarum_stats2.csv"))
    csv = CSV.parse(csv_data, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Astra Militarum"
    f.icon = "astra_militarum_icon.png"
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
    #end of stats
    csv_weapon = File.read(Rails.root.join("lib", "sample_data", "astra-militarum_weapons2.csv"))
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
          profile_name = holder[1]
          puts profile_name
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
        if profile_name.length > 0
          profile.name = profile_name
          puts profile.name
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
          puts profile_name #"The profile #{profile.name} already exists"
        end
        equipment = Equipment.new
        equipment.weapon_id = weapon.id
        equipment.unit_id = unit.id
        puts unit.id
        puts equipment.weapon_id
        if equipment.valid?
          equipment.save
          puts "#{unit.name} now has #{weapon.name} as equipment"
        else
          puts "#{unit.name} already has #{weapon.name} as equipment"
        end
        
      end
      
    end
    #end of weapons

    
  end
