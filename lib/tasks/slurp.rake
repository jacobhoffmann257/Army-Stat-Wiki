
namespace :slurp do
  desc "tyranid name"
  task tyranid_name: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Tyranids2"
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
      m.name = row["Model_name"]
      m.invulnerable_save = row["Invurebale_Save"]
      m.leadership = row["Ld"]
      m.movement = ["M"]
      m.objective_control = ["OC"]
      m.save_value = row["Sv"]
      m.toughness = row["T"]
      m.wounds = row["W"]
      m.unit_id = Unit.where(name: u.name).first.id
      puts m.unit_id
      m.save
    end
  end
  desc "Tyranid stats"
  task tyranid_stats: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    f = Faction.new
    f.name = "Tyranids1"
    f.save
    csv.each do |row|
      u = Unit.new
      m = Model.new
      u.name = row["Model_Name"]
      u.faction_id = 10
      u.base_size = row["Base_Size"]
      u.save
      m.name = row["Unit_Name"]
      m.invulnerable_save = row["Invurebale_Save"]
      m.movement = row["M"]
      m.toughness = row["T"]
      m.save_value = row["Sv"]
      m.wounds = row["W"]
      m.leadership = row["Ld"]
      m.objective_control = row["Oc"]
      m.unit_id = Unit.where(name: u.name).first.id
      m.save
     # u.save
      #puts u.name + "  " + u.base_size
    end
  end
  desc "Tyranid stats"
  task tyranid_abilities: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      name = row["Unit_Name"]
      u = Unit.new
      u = Unit.where(name: name).first #gets the unit based on the name
      raw_sizes = row["Cost"]
      sizes = JSON.parse(raw_sizes)
      puts u.name
      #pp Array(sizes)
    end
  end

end
