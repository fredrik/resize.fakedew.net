# hello, this is our gallery app

require 'sinatra'
require 'data_mapper'
require 'dm-postgres-adapter'


DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://fredrik@localhost/resize_development')


class Image
  include DataMapper::Resource

  property :id,         Serial
  property :path,       String
  property :sender,     String
  property :created_at, EpochTime
end

DataMapper.finalize

# but surely elsewhere?
Image.auto_upgrade!


get '/' do
  @images = Image.all(:order => [ :id.desc ], :limit => 5)
  erb :index
end
