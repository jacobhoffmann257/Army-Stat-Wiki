
namespace :slurp do
  desc "tyranid stats"
  task tyranid_stats: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      u = Unit.new
      m = Model.new
      u.name = row["Model_Name"]
      u.faction_id = 1
      u.base_size = row["Base_Size"]
      #u.save
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
  desc "Tyranid Weapons"
  task tyranid_weapons: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      u = Unit.new
      m = Model.new
      u.name = row["Model_Name"]
      u.faction_id = 1
      u.base_size = row["Base_Size"]
      #u.save
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

end
