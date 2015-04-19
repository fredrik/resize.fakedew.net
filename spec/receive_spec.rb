ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'resque_spec'

# setup
ENV['DATABASE_URL'] = 'postgres://localhost/resize_test'
ENV['RESIZE_DATA_PATH'] = '/tmp/resize_test'

require_relative '../receive/app'
require_relative '../process/worker'


describe 'webhook app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('OK')
  end

  describe "incoming notifications" do
    it 'rejects bad requests' do
      post '/resize/notify', {}
      expect(last_response).to_not be_ok
      expect(last_response.status).to be(406)
    end

    it 'enqueues a ResizeJob' do
      sender = "fredrik@mollerstrand.se"
      attachment = {
        "size" => 1024,
        "url" => "https://mailgun.example.com/xyz",
        "name" => "kanagawa.jpg",
        "content-type" => "image/jpeg"
      }
      params = {
        'sender' => sender,
        'attachments' => "[#{JSON.dump(attachment)}]"
      }

      post '/resize/notify', params

      expect(last_response).to be_ok
      expect(ResizeJob).to have_queued(sender, attachment).in(:resize)
    end
  end
end
