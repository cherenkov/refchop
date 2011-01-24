require 'rubygems'
require 'sinatra'

# reloader
require "sinatra/reloader" if development?

require 'net/http'
require 'uri'
require 'mime/types'


before do
  if request.fullpath == '/'
    halt 'Hello!<br><a href="https://github.com/cherenkov/refchop">https://github.com/cherenkov/refchop</a>'
  end
end

get '/*' do
  url = URI.parse(request.fullpath.gsub(/^\//,''))
  host = url.host
  path = url.path
  mime_type = MIME::Types.type_for(path)[0].to_s
  begin
    Net::HTTP.start(host, 80) {|http|
      content_type mime_type
      res = http.get(path, {'Referer'=>url.scheme + '://' + host + '/'})
      response.body = res.body
    }
  rescue => e
    p e
    halt "Error"
  end
end