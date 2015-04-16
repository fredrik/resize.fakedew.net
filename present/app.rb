# hello, this is our gallery app

require 'sinatra'

require_relative '../schema'


get '/' do
  @images = Image.all(:order => [ :id.desc ], :limit => 5)
  erb :index
end

# naughty way of serving files
# TODO: nginx or S3
get '/images/:image' do
  return 404 if params[:image].include?('..')
  full_path = File.join(DATA_PATH, params[:image])
  send_file(full_path, :disposition => 'inline')
end
