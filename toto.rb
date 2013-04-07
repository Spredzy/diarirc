#!/usr/bin/ruby

require 'rubygems'
require 'elasticsearch'

index = 'chann'
url = 'http://192.168.1.197:9200'
es = ElasticSearch::Index.new(index, url)

a = ElasticSearch::Index.create(index, url);


