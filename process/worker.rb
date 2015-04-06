require 'resque'
require 'rmagick'


class SomeJob
  @queue = :some

  def self.perform(params)
    # pick up an image, resize and  and store it.
    puts 'yep'
    f = open('/tmp/x', 'a')
    f.write "#{Time.now} => yeah\n"
    f.close
  end

end



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

    resize(params['image'])

    return true
  end
end





WIDTH = 400
HEIGHT = 300
def resize(path)
  target = '/tmp/yeah.png'

  i = Magick::Image.read(path).first
  puts i
  i.resize_to_fill(WIDTH, HEIGHT).write(target)
end
