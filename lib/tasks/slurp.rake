
namespace :slurp do
  task tyranid_all: :environment do
  require_relative "tyranid.rake"
    rake tyranid_data
    rake tyranid_weapons
    rake tyranid_abilities
  end
end
