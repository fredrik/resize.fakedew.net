require 'resque'
require 'rmagick'
require 'securerandom'

require '../schema'


def log(message)
  puts "#{Time.now} #{message}"
end

class ResizeJob
  @queue = :resize

  def self.perform(params)
    unless params.key?('image')
      raise 'missing argument :image'
    end

    log "about to process #{params['image']}"

    filename = SecureRandom.hex
    full_path = File.join(DATA_PATH, filename)

    # TODO: failure handling
    resize(params['image'], full_path)

    # TODO: failure handling
    Image.create(
      sender: nil, # TODO
      filename: filename,
      created_at: Time.now
    )

    log("wrote resized image to #{full_path}")

    true
  end
end


WIDTH = 400
HEIGHT = 300
def resize(source, target)
  Magick::Image.read(source).first
               .resize_to_fill(WIDTH, HEIGHT)
               .write(target)
end
