require 'sinatra'
require 'resque'

require_relative '../process/worker'


# accepted attachement content-types
DESIRABLE_CONTENT_TYPES = [
  'image/png',
  'image/jpeg'
]

# set up worker queue
Resque.redis = Redis.new


get '/' do
  'OK'
end

post '/resize/notify' do
  # receives a 'store' notification from Mailgun.
  # enqueue a set of ResizeJob workers, one for each image attachment.

  # return a 200 OK to indicate success,
  # return a 406 Not Acceptable to reject the message,
  # or any other status code to have Mailgun retry the notifiation later.
  # see https://documentation.mailgun.com/user_manual.html#routes for more.

  log("incoming from #{params['sender']}")

  begin
    sender = params.fetch('sender')
    attachments = parse_attached_images(params.fetch('attachments'))
  rescue => e
    log("bad request, rejecting: #{e}")
    return 406  # reject
  end

  begin
    attachments.each do |attachment|
      log("posting job: #{attachment}")
      Resque.enqueue(ResizeJob, sender, attachment)
    end
  rescue => e
    log("ERROR: #{e}")
    return 500  # please retry
  end

  200 # ok
end


def parse_attached_images(attachments_data)
  # parse the json structure and filter out any non-image attachments.
  # returns a list of hashes, one hash for each image. as defined by the
  # the Mailgun API, they are keyed by url, name, size and content-type.
  attachments = JSON.parse(attachments_data)
  attachments.select { |a|
    DESIRABLE_CONTENT_TYPES.include?(a['content-type'])
  }
end

def log(message)
  puts "#{Time.now} #{message}"
end
