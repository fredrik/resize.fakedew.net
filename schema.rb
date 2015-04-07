require 'data_mapper'
require 'dm-postgres-adapter'


DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://fredrik@localhost/resize_development')

# TO: config
DATA_PATH = ENV.fetch('RESIZE_DATA_PATH', '/data/resize')


class Image
  include DataMapper::Resource

  property :id,         Serial
  property :sender,     String
  property :filename,   String
  property :created_at, EpochTime

  # TODO: width and height as properties?
  # currently all images are assumed 400x300

  def image_url
    "/images/#{filename}"
  end
end

DataMapper.finalize

# but surely elsewhere?
Image.auto_upgrade!

