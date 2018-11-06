require 'csv'

# Handles data for both birthdays and anniversaries

SCHEDULER.every '60m', :first_in => 0 do |job|

	#worker_list_aniv = []
	#worker_list_bday = []
	worker_list = []
	csv_text = File.read('./assets/csv/6210-floor1-birthdays.csv')
	csv = CSV.parse(csv_text, :headers => false)
	csv.each do |row|

		# For this worker, get anniversary and birthday
		worker = row[0]     									# Alex Guo

		if (row[1] !=  ' --') then
			aniv = DateTime.strptime(row[1], ' %m/%d/%Y').to_date   # 2017-09-11
			aniv_year = aniv.year
	  
		    # Find days left until anniversary
		    aniv = Date.new(Date.today.year, aniv.month, aniv.day)
		    aniv = aniv.next_year if Date.today - 1 >= aniv
		    days_until_aniv = (aniv - Date.today).to_i

		    # Find number year anniversary
		    num_year_aniv = (aniv.year - aniv_year).to_i
		else
			# temp until I can find all bdays and anniversaries
			days_until_aniv = 999

		end

		

	    #Find bday and days left until birthday
	    bday = DateTime.strptime(row[2], ' %m/%d').to_date 		# 08/27
	    bday = Date.new(Date.today.year, bday.month, bday.day)
	    bday = bday.next_year if Date.today - 1 >= bday

	    days_until_bday = (bday - Date.today).to_i

	    # If anniversary or birthday is within N days, add to worker list
	    if (days_until_aniv <= 8) then
	    	hash = {"worker" => row[0], "date" => aniv, "num_years" => "(" + num_year_aniv.to_s + " yr)"}
	    	worker_list.push(hash)
	    end

	    if (days_until_bday <= 8) then
	    	hash = {"worker" => row[0], "date" => bday}
	    	worker_list.push(hash)
	    end

	end

	#puts worker_list

	sorted_dates = worker_list.sort_by { |hsh| hsh["date"] }	

	sorted_dates.each do |d|
		d['date'] = d['date'].month.to_s + "/" + d['date'].day.to_s
	end
	
	puts sorted_dates
	
	send_event('birthdays', { items: sorted_dates})
end
