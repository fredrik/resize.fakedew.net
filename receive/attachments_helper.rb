require 'json'

# accepted attachement content-types
DESIRABLE_CONTENT_TYPES = [
  'image/png',
  'image/jpeg'
]


def parse_attached_images(attachments_data)
  # parse the json structure and filter out any non-image attachments.
  # returns a list of hashes, one hash for each image. as defined by the
  # the Mailgun API, they are keyed by url, name, size and content-type.
  attachments = JSON.parse(attachments_data)
  attachments.select { |a|
    DESIRABLE_CONTENT_TYPES.include?(a['content-type'])
  }
end
