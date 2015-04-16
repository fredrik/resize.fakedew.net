present: bundle exec ruby present/app.rb -p 4000
process: cd process && INTERVAL=1 QUEUE=resize TERM_CHILD=1 bundle exec rake resque:work
receive: bundle exec ruby receive/app.rb -p 4200
