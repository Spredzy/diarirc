require 'rubygems'


require 'net/http'
require 'uri'
require 'JSON'

require 'diarirc/message'


class Channel

  attr_reader :name, :server, :messages, :logs, :indices, :creation_date

  def initialize(name, server = 'freenode', creation_date = Time.now.to_i)
    @name = name
    @server = server
    @messages = []
    @logs = []
    @indices = []
    @creation_date = creation_date
    _load
  end

  def to_s
    @name
  end

  private
  def _load
    _load_indices
    _load_messages
    _load_logs
  end

  private
  def _load_indices

    uri = URI.parse("http://192.168.1.197:9200/_cluster/state")
    res = Net::HTTP.get_response(uri)
    cluster_state = JSON.parse(res.body)
    cluster_state['metadata']['indices'].each do |key, value|
      @indices.push key if key =~ /#{@server}-#{@name}.*/
    end

  end

  private
  def _load_messages

    @indices.each do |index|
      idx = ElasticSearch::Index.new(index, 'http://192.168.1.197:9200/')

      query = {
        :query => {
          :field => {
            :nick => '*',
          }
        }
      }

      msgs = idx.search(:message, query)['hits']['hits']

      msgs.each do |msg|
        nick = msg['_source']['nick']
        message = msg['_source']['message']
        date = msg['_source']['post_date']
        @messages.push Message.new(nick, message, date)
      end
      @messages.sort! {|x,y| x.date <=> y.date }

    end

    pp @messages

  end

  private
  def _load_logs

  end

end
