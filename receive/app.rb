require 'sinatra'
require 'resque'

require_relative './attachments_helper'
require_relative '../process/resize_job'


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

  logger.info("incoming from #{params['sender']}")

  begin
    sender = params.fetch('sender')
    attachments = parse_attached_images(params.fetch('attachments'))
  rescue => e
    logger.info("bad request, rejecting: #{e}")
    return 406  # reject
  end

  begin
    attachments.each do |attachment|
      logger.info("posting job: #{attachment}")
      Resque.enqueue(ResizeJob, sender, attachment)
    end
  rescue => e
    logger.info("ERROR: #{e}")
    return 500  # please retry
  end

  200 # ok
end
