
Pre-requisites
- Install Ruby v2.2.1p85
- Install DevKit
- Update certificate by following instructions in: https://stackoverflow.com/questions/5720484/how-to-solve-certificate-verify-failed-on-windows
- 'gem install bundler'
- Install npm


Internal dashboard for work office monitors
- Developed using Ruby on Rails and NodeJS (Ruby on Rails renders the dashboard and NodeJS handles Twilio messaging)
- Upcoming birthdays and anniversaries pulled from CSV file daily
- Stock price pulls from Yahoo Finance API every 5 minutes
- Team performance metrics pulled from internal Workday API monthly
- Office announcements crowdsourced through mobile texting, managed by separate
integrations using NodeJS middleware, Twilio API, and MongoDB