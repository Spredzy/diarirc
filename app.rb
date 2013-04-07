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
  redirect "/chan/#{chann.server}/#{chann.name}"

end

get '/chan/:server/:chan' do

  channel = diarirc.find(params[:server], params[:chan])

  if channel.is_a? Channel
    erb :chan, :locals => {:channel => channel}
  else
    redirect '/'
  end

end

get '/list/chan' do

  erb :list_chan, :locals => {:channels => diarirc.channels}

end
