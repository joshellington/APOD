require 'rubygems'
require 'sinatra'
require './config/init'

#
# Before any route is run
before do
  @path = request.env['SCRIPT_NAME']
end

#
# Routes

match '/' do
  @post = Post.get
  
  puts @post.inspect
  erb :index
end

match '/:id/?' do
  Post.get(params[:id]).to_json
end