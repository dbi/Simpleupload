require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'json'

# upload with:
# curl -v -F "data=@/path/to/filename"  http://localhost:9292/upload

get '/' do
  content_type :json
  { :files => Dir.glob('files/**/*.*') }.to_json
end

post '/upload' do
  userdir = File.join("files")
  FileUtils.mkdir_p(userdir)
  filename = File.join(userdir, "#{rand(32**8).to_s(32)}-#{params[:data][:filename]}")
  
  File.open(filename, 'wb') do |file|
    file.write(params[:data][:tempfile].read)
  end
end
