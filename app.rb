require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'json'
require 'thread'

get '/' do
  content_type :json
  { :files => Dir.glob('files/**/*.*') }.to_json
end

# upload with:
# curl -v -F "data=@/path/to/filename"  http://localhost:4567/user/filename

post '/upload' do
  userdir = File.join("files")
  FileUtils.mkdir_p(userdir)
  filename = File.join(userdir, "#{getNextFilename}.jpg")
  
  datafile = params[:data]

  File.open(filename, 'wb') do |file|
    file.write(datafile[:tempfile].read)
  end
end

@@semaphore = Mutex.new
@@nextFileIndex = -1
def getNextFilename
  @@semaphore.synchronize {
    @@nextFileIndex = ((@@nextFileIndex + 1) % 20)
  }
end

# max 20
# äldst föst
# tidsstämpel
