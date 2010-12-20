require 'rubygems'
require 'sinatra'

# reloader
require "sinatra/base"
require "sinatra/reloader" if development?

require 'net/http'
require 'base64'
require 'uri'
require 'mime/types'


before do
  if request.fullpath == '/'
    halt 'Hello!'
  end
end

get '/*' do
  img_url = URI.parse(request.fullpath.gsub(/^\//,''))
  img_host = img_url.host
  img_path = img_url.path
  mime_type = MIME::Types.type_for(img_path)[0].to_s
  begin
    Net::HTTP.start(img_host, 80) {|http|
      content_type mime_type
      res = http.get(img_path)
      response.body = res.body
    }
  rescue => e
    p e
    halt "Error"
  end
end