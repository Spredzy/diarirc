$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "lib")))

require 'rubygems'
require 'sinatra'
require 'pp'

require 'diarirc'


diarirc = Diarirc.new('http://192.168.1.197:9200')

get '/' do
  erb :home
end

post '/chan' do

  chann = Channel.new(params[:chan])
  diarirc.add chann if !diarirc.include? chann
  redirect "/chan/#{chann.server}/#{chann.category}/#{chann.name}"

end

get '/chan/:server/:category/:chan' do

  channel = diarirc.find(params[:server], params[:category], params[:chan])

  if channel.is_a? Channel
    erb :chan, :locals => {:channel => channel}
  else
    redirect '/'
  end

end

get '/chan/:server/:category/:chan/log' do

  channel = diarirc.find(params[:server], params[:category], params[:chan])

  if channel.is_a? Channel
    erb :logs, :locals => {:channel => channel}
  else
    redirect '/'
  end

end

get '/list/chan' do

  erb :list_chan, :locals => {:channels => diarirc.channels}

end

get '/list/chan/:server' do

  erb :list_chan, :locals => {:channels => diarirc.server(params[:server])}

end

get '/list/chan/:server/:category' do

  erb :list_chan, :locals => {:channels => diarirc.category(params[:server], params[:category])}

end
