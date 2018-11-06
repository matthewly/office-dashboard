require 'mongo'


seed_data = [
  {
    "date" => "07/15",
    "from" => "847-773-5485",
    "message" => "test"
  }
]

# MongoDB - mLab
# username: {{username}}
# password: {{password}}

uri = "mongodb://"+username+":"+password+"@ds137581.mlab.com:37581/payroll-dashboard"
client = Mongo::Client.new(uri)
  
SCHEDULER.every '5m', :first_in => 0 do |job|
	
	db_announcements = client[:announcements]
	announcements_out = []

	cursor = db_announcements.find().skip(db_announcements.count() - 5)
	cursor.each {
		|doc| begin
			announcement = {
				"date" => doc['date'],
				"from" => doc['from'],
				"message" => doc['message']
			}

			announcements_out.push(announcement)
		end 
	}

	puts announcements_out

	send_event('announcements', items: announcements_out)

end


