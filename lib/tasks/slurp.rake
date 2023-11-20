
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
      m.save
    end
  end
  
  desc "tyranid name"
  task tyranid_abilities: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_abilities.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
    end
  end
end
