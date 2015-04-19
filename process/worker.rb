require 'resque'
require 'resque/errors'
require 'securerandom'

require_relative '../schema'
require_relative './image_fetcher'
require_relative './resizer'


# used for HTTP basic auth when fetching attachments
MAILGUN_USER = ENV.fetch('MAILGUN_USER', '')
MAILGUN_PASSWORD = ENV.fetch('MAILGUN_PASSWORD', '')


class ResizeJob
  @queue = :resize

  def self.perform(sender, attachment)
    # go to work on an image:
    # fetch it, resize it, store it.

    log("got job: #{attachment}")

    filename = SecureRandom.hex
    target_path = File.join(DATA_PATH, filename)

    image = ImageFetcher.fetch(attachment['url'], MAILGUN_USER, MAILGUN_PASSWORD)
    resized_image = Resizer.resize(image)
    resized_image.write(target_path)

    Image.create(
      sender: sender,
      filename: filename,
      content_type: attachment['content-type'],
      created_at: Time.now
    )

    log("finished job.")

    true
  rescue Resque::TermException => e
    log "lots of bork right here: #{e}"
  end
end


def log(message)
  puts "#{Time.now} #{message}"
end
