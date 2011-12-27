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

match '/random/?' do
  Post.random(params[:latest]).to_json
end

match '/:id/?' do
  Post.get(params[:id], params[:latest]).to_json
end