require 'rmagick'

WIDTH = 400
HEIGHT = 300

class Resizer
  def self.resize(image_blob)
    Magick::Image.from_blob(image_blob).first
                 .resize_to_fill(WIDTH-20, HEIGHT-20)
                 .border(10, 10, '#000000')
  end
end
