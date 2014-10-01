# -*- coding: utf-8 -*-
# myapp.rb
require 'sinatra'
require './location'
require './matsuya'

set :environment, :production

loc = Location.new

get '/' do
  @lon, @lat = loc.get
  @copyright = loc.copyright
  @stores = []
  erb :index
end

post '/' do
  @place = params[:placename]
  if loc.query(@place) 
    @lon, @lat = loc.get
    matsuya = Matsuya.new
    @stores = matsuya.query(@lon, @lat)
    @query_string = matsuya.query_string
  else
    @query_string = '地名検索に失敗しました。'
    @lon, @lat = loc.get
    @stores = []
  end
  erb :index
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
