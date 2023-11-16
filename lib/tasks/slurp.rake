
namespace :slurp do
  desc "TODO"
  task transactions: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    puts csv_text
  end

end
