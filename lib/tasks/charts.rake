namespace :charts do
  desc "Load all the values from the lib/assets/values repertory"
  task load_values: :environment do
    filepath = Rails.root + "lib/assets/PX1.txt"
    Chart.load_single_value filepath
    filepath = Rails.root + "lib/assets/FR0000120073.txt"
    Chart.load_single_value filepath
    filepath = Rails.root + "lib/assets/FR0000131906.txt"
    Chart.load_single_value filepath
    filepath = Rails.root + "lib/assets/FR0011648971.txt"
    Chart.load_single_value filepath

  end

end
