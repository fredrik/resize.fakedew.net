# hello, this is our gallery app

require 'sinatra'

require '../schema'


get '/' do
  @images = Image.all(:order => [ :id.desc ], :limit => 5)
  erb :index
end


# naughty way of serving files
get '/images/:image' do
  # TODO: how expose `DATA_PATH`?
  full_path = File.join(DATA_PATH, params[:image])
  send_file(full_path, :disposition => 'inline')
end
