require 'stock_quote'

SCHEDULER.every '5m', :first_in => 0 do |job|
  data = stock = StockQuote::Stock.quote("WDAY")
  puts "WDAY" + " = $" + data.latest_price.to_s + " (USD " + data.change.to_s + ")"

  if data.change.to_i <= 0
  	color = 'dark-red'
  	change = data.change.to_s << (" ↓")
  else
  	color = 'dark-green'
  	change = data.change.to_s << (" ↑")
  end

  wday_stock = {
  	'price' => data.latest_price,
  	'change' => change,
  	'color' => color
  }

  puts wday_stock.inspect

  send_event('stock', { stock_price: wday_stock })
end