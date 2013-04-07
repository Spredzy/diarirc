require 'rubygems'

require 'elasticsearch'
require 'diarirc/channel'
require 'pp'

class Diarirc

  attr_reader :es_server
  attr_accessor :channels

  def initialize(es_server)

    @es_server = es_server
    @channels = []

    # Find a way to execute this ONLY IF index does not exist yet 
    idx = ElasticSearch::Index.new(:channel, @es_server)
    doc = {:id => _generate_uuid, :name => 'root', :server => 'root', :creation_date => Time.now.to_i}
    idx.add(:channel, doc[:id], doc)

    _load

  end

  public
  def add(channel)
    idx = ElasticSearch::Index.new(:channel, @es_server)
    doc = {
      :id             => _generate_uuid,
      :name           => channel.name,
      :server         => channel.server,
      :creation_date  => channel.creation_date
    }
    idx.add(:channel, doc[:id], doc)
    self.channels.push channel
    pp 'BEING --'
    pp channels
    pp 'END ##'
    
  end

  # include is overwriten
  # to check only chan name
  # and server name matching
  public
  def include?(channel)

    @channels.each do |chan|
      return true if chan.name == channel.name and chan.server == channel.server
    end
    false

  end

  public
  def find(server, name)

    pp server
    pp name
    pp '###'

    @channels.each do |channel|
      pp channel.server
      pp channel.name
      pp '--'
      return channel if channel.name == name and channel.server == server
    end
    false

  end

  private
  def _load

    _load_chan

  end

  private
  def _load_chan

    idx = ElasticSearch::Index.new(:channel, @es_server)



    query = {
      :query => {
        :field => {
          :name => '*',
        }
      }
    }

    channs = idx.search(:channel, query)['hits']['hits']

    channs.each do |chan|
      name = chan['_source']['name']
      server = chan['_source']['server']
      creation_date = chan['_source']['creation_date']
      new_chan = Channel.new(name, server, creation_date)
      #pp chan
      @channels.push new_chan
    end

  end

  private
  def _generate_uuid
    o = [('a'..'z'),('A'..'Z'),(1..9)].map{|i| i.to_a}.flatten
    string = (0...22).map{ o[rand(o.length)] }.join
  end

end
