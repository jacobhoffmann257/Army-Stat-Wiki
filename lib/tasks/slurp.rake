
namespace :slurp do
  desc "TODO"
  task transactions: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "sample_data", "tyranids_stats.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    puts csv
  end

end
