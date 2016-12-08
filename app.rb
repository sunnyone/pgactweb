#!/usr/bin/ruby

require 'sinatra'
require 'sequel'

DB = Sequel.postgres('dbname', { user: 'username' })

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  dataset = DB["select client_addr,backend_start,query_start,state_change,waiting,state,query from pg_stat_activity where datname = current_database() and query not like '%pg_stat_activity%' order by client_addr, backend_start;"]
  @table_data = dataset.map{|row| row.values.to_a }
  # @table_data.to_s
  erb :index
end
