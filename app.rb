require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'json'

get '/' do
  content_type :json
  { :files => Dir.glob('files/**/*.*') }.to_json
end

# upload with:
# curl -v -F "data=@/path/to/filename"  http://localhost:4567/user/filename

post '/upload' do
  userdir = File.join("files")
  FileUtils.mkdir_p(userdir)
  filename = File.join(userdir, "#{(0...50).map{ ('a'..'z').to_a[rand(8)] }.join}-#{params[:data][:filename]}")
  
  datafile = params[:data]

  File.open(filename, 'wb') do |file|
    file.write(datafile[:tempfile].read)
  end
end

# max 20
# äldst föst
# tidsstämpel
