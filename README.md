== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version  
ruby 2.2.1p85

* Rails version  
Rails4.1.6

* Database creation  
rake db:migrate

* Database initialization  
wget -O ./temp.csv "http://k-db.com/futures/F101-0000?download=csv" && cat ./temp.csv | nkf -Lu -w8 > lib/futures.csv  
rails runner Candlestick::biteoff

* How to run the test suite  
rails s

