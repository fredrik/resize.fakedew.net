require 'data_mapper'

namespace :dm do
  namespace :auto do
    desc "Perform auto migration (reset your db data)"
    task :migrate do
      ::DataMapper.repository.auto_migrate!
      puts "<= dm:auto:migrate executed"
    end

    desc "Perform non destructive auto migration"
    task :upgrade do
      ::DataMapper.repository.auto_upgrade!
      puts "<= dm:auto:upgrade executed"
    end
  end
end
