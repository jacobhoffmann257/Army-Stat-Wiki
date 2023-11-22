
namespace :slurp do
  desc "tyranid weapons"
  task tyranid_weapons: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_weapons2.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      model = Model.where(name: row["Name"]).first
      csv_weapon = Weapon.new
      csv_weapon.name = row["Weapon_Name"]
      if row["Range"] === "Melee"
        csv_weapon.range = 0
      else
        csv_weapon.range = row["Range"].to_i
      end
      #csv_weapon has been read
      csv_profile = Profile.new
      csv_profile.armor_piercing = row["AP"].to_i
      csv_profile.attacks  = row["A"].to_i
      csv_profile.damage = row["d"].to_i
      if row["Profile"]
        csv_profile.name = row["Profile"]
      else
        csv_profile.name = row["Weapon_Name"]
      end
      csv_profile.skill = row["BS/WS"].to_i
      csv_profile.strength = row["S"].to_i
      #csv_profile has been read
      if Weapon.where(name: csv_weapon.name, range: csv_weapon.range).last
        if Profile.where(armor_piercing: csv_profile.armor_piercing, damage: csv_profile.damage, name: csv_profile.name, skill: csv_profile.skill, strength: csv_profile.strength).last
          weapon = Weapon.where(name: csv_weapon.name).last
          if Equipment.where(model_id: model.id, weapon_id: weapon.id).last
            puts "#{model.name} already has this #{weapon.name} equipment" 
          else
            equipment = Equipment.new
            equipment.weapon_id = weapon.id
            equipment.model_id = model.id
            equipment.save
          end
        else
        csv_weapon.save
        weapon = Weapon.where("created_at").last
        csv_profile.weapon_id = weapon.id
        csv_profile.save
        profile = Profile.where("created_at").last
        equipment = Equipment.new
        equipment.model_id = model.id
        equipment.weapon_id = weapon.id
        equipment.save
        puts "New weapons profile for #{model.name} added"
        end
      else
        csv_weapon.save
        weapon = Weapon.where("created_at").last
        csv_profile.weapon_id = weapon.id
        csv_profile.save
        profile = Profile.where("created_at").last
        equipment = Equipment.new
        equipment.model_id = model.id
        equipment.weapon_id = weapon.id
        equipment.save
      end
    end
  end
  desc "tyranid name/stats"
  task tyranid_stats: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats2.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Tyranids"
    f.save
    csv.each do |row|
      #Adding unit
      u = Unit.new
      u.name = row["Unit_Name"]
      u.faction_id = f.id
      u.base_size = row["Base_Size"]
      u.save
      #Adding Models
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
      m.save
    end
  end
  
  desc "tyranid abilities"
  task tyranid_abilities: :environment do
    require "csv"
    require "json"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities2.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      #Core Abilities
      name = row["Unit_Name"]
      unit = Unit.where(name: name).first
      core = JSON.parse(row["Core"])
      puts core
      core.each do |ability|
        if ability === "CORE"
          puts ability
        else
          if Ability.where(name: ability).last
            a = Ability.where(name: ability).last
            u = UnitAbility.new
            u.ability_id = a.id
            u.unit_id = unit.id
            u.save
            puts ability
            #puts u.valid?
            #puts u.errors.full_messages
          else
            u = UnitAbility.new
            a = Ability.new
            a.name = ability
            a.classification = core
            a.save
            new_ability = Ability.where("created_at").last
            
            u.unit_id = unit.id
            u.ability_id = Ability.where(name: ability).last.id
            u.save
          end
        end
      end
      #next Faction
      faction = JSON.parse(row["Faction"])
      faction.each do |ability|
        if ability === "FACTION"
        else
          if Ability.where(name: ability).last
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
            new_ability = Ability.where("created_at").last
            
            u.unit_id = unit.id
            u.ability_id = Ability.where(name: ability).last.id
            u.save
          end
        end
      end
      #standard abilities
      standard = JSON.parse(row["Standard"])
      standard.each do |ability|
        if Ability.where(name:  ability[0]).last
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
          new_ability = Ability.where("created_at").last
          
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
      #Wargear, needs to be changed for other factions
      if row["Wargear"]
        wargear = JSON.parse(row["Wargear"])
        if Ability.where(name:  wargear[0]).last
          a = Ability.where(name: wargear[0]).last
          u = UnitAbility.new
          u.ability_id = a.id
          u.unit_id = unit.id
          u.save
        else
          u = UnitAbility.new
          a = Ability.new
          a.name = wargear[0]
          a.description = wargear[1]
          a.classification = "wargear"
          a.save
          new_ability = Ability.where("created_at").last
          
          u.unit_id = unit.id
          u.ability_id = Ability.where(name: wargear[0]).last.id
          u.save
        end
      end
    end
  end

end
