
SCHEDULER.every '60m', :first_in => 0 do |job|

  # Get Sprint
  
  # !!!!!!!!!!
  # CHANGE this date to start of release
  sprint1A = DateTime.new(2018,1,29).to_time.to_f
  # !!!!!!!!!!

  today = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0, 0).to_time.to_f

  diff_sprints = ((today - sprint1A) / 1209600).floor
  diff_sprints = diff_sprints - (diff_sprints / 13).floor * 13

  sprint = ((diff_sprints / 2).floor + 1).to_s + (diff_sprints % 2 == 0 ? "A" : "B")
  
  # Get Drop
  today = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 0, 0, 0)

  if (today.saturday?) then
    today = today.to_date.next_day
  end

  upcoming_friday = today - today.wday + 5

  first_friday = DateTime.new(upcoming_friday.year, 1, 1)

  while (first_friday.wday != 5) 
    first_friday = first_friday.to_date + 1
  end

  week_num = ((upcoming_friday.to_time - first_friday.to_time).to_f / 604800).ceil

  drop = upcoming_friday.year.to_s + "." + (week_num < 9 ? "0" : "") + (week_num + 1).to_s

  # Get Dev Drop

  friday_drop = upcoming_friday

  if (friday_drop.to_time.to_f - Time.now.to_f <= 259200) # within 3 days
    # Get next friday
    friday_drop = upcoming_friday + 1
    if (friday_drop.saturday?) then
      friday_drop = friday_drop.to_date.next_day
    end

    friday_drop = friday_drop - friday_drop.wday + 5
  end

  first_friday = DateTime.new(friday_drop.year, 1, 1)

  while (first_friday.wday != 5) 
    first_friday = first_friday.to_date + 1
  end

  week_num = ((friday_drop.to_time - first_friday.to_time).to_f / 604800).ceil

  dev_drop = friday_drop.year.to_s + "." + (week_num < 9 ? "0" : "") + (week_num + 1).to_s

  # Create map and send to dashboard
  schedule = {"sprint" => sprint, "drop" => drop, "dev_drop" => dev_drop}
  puts schedule



  send_event('patch_stocks', schedule)
end
