=begin
*******
This job is currently NOT used.
*******)
=end

require 'csv'

data = []
csv_text = File.read('./assets/csv/Overall MHI.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  # data = [{"Month"=>"Aug 2017", "Team"=>"FIN - Assets", "Overall MHI Score"=>"3.19"}, ...]
  mhi = row[2].to_f

  if mhi <= 2.6
  	color = 'dark-red'
  elsif mhi >=2.61 and mhi <= 2.80
  	color = 'red'
  elsif mhi >= 2.81 and mhi <= 2.99
  	color = 'orange' 
  elsif mhi >= 3.00 and mhi <= 3.15
  	color = 'yellow'
  elsif mhi >= 3.16 and mhi <= 3.39
  	color = 'light-yellow'
  elsif mhi >= 3.40 and mhi <= 3.49
  	color = 'light-green'
  elsif mhi >= 3.50 and mhi <= 3.59
  	color = 'green'
  else
  	color = 'dark-green'
  end

  hash = {"Month" => row[0], "Team" => row[1], "Overall MHI Score" => mhi, "Color" => color}
  data << hash
end

data.sort_by! { |team| -team["Overall MHI Score"] }

send_event('teams', { items: data})
