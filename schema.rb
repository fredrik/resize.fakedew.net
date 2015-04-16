require 'data_mapper'
require 'dm-postgres-adapter'


DATABASE_URL = ENV.fetch('DATABASE_URL')
DATA_PATH    = ENV.fetch('RESIZE_DATA_PATH', '/data/resize')

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DATABASE_URL)


class Image
  include DataMapper::Resource

  property :id,           Serial
  property :sender,       String
  property :filename,     String
  property :content_type, String
  property :created_at,   EpochTime

  # TODO: width and height as properties?
  # currently all images are assumed 400x300

  # TODO: more of a presentation layer issue?
  def image_url
    "/images/#{filename}"
  end
end

DataMapper.finalize
Image.auto_upgrade!
