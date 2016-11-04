class Chart < ApplicationRecord
  
  # the cache key for the mixed values
  MIX = "mix"
  
  # ISIN code of some values
  CAC40   = 'FR0003500008'
  AI      = 'FR0000120073'
  RENAULT = 'FR0000131906'
  QUANTUM = 'FR0011648971'
  
  # CAC40
  # Load the date/value keypair into the cache
  # Each line indicates : 
  # l'identifiant de la valeur, la date, le cours d'ouverture, le plus haut, le plus bas, le cours de clôture et le volume de titres échangés. 
  def self.load_single_value(filepath)
    all_values = []
    isin = 0
    File.open(filepath).each_line do |line|
      values = line.split(';')
      all_values << [Date.strptime(values[1], '%d/%m/%Y'), values[2].to_f, values[3].to_f, values[4].to_f, values[5].to_f, values[6].to_i]
      isin = values[0]
    end
    Rails.cache.write(isin, all_values)
    
    return Rails.cache.fetch(isin)
  end
  
  # Combine the cac 40 graph with the other values
  def self.make_combined
    cac = Rails.cache.fetch(Chart::CAC40)
    
    hashes = []
    values = [Chart::CAC40, Chart::AI, Chart::RENAULT, Chart::QUANTUM]
    values.each do |isin|
      vals = Rails.cache.fetch(isin).last(230)
      first_val = vals[0][4] / 100
      h = {}
      vals.each do |val|
        date = val[0]
        # Normalize so it starts at 100
        val[4] /= first_val
        h[date] = {isin => val}
      end
      hashes << h
    end
    
    mix = hashes.shift
    while !hashes.empty? do
      mix = mix.merge!(hashes.shift){ |key,a,b| a.merge(b) }
    end
    Rails.cache.write(Chart::MIX, mix)
    
    return Rails.cache.fetch(Chart::MIX)
  end
  
  def self.make_px1_graph
    self.make_combined
    # TODO : reload the cache ?
    return unless Rails.cache.exist?(Chart::MIX)
    
    # The list of values we want
    isines = [Chart::CAC40, Chart::AI, Chart::RENAULT, Chart::QUANTUM]
    
    graph_data = []
    Rails.cache.fetch(Chart::MIX).each do |key,values|
      line = [key]
      isines.each do |isin|
        value = nil
        value = values[isin][4] if values[isin]
        line << value
      end
      graph_data << line
    end
    return graph_data
  end
end
