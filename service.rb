require 'sinatra'
require 'mongoid'
require './models'

configure do
  Mongoid::Config.load!('mongoid.yml')
end

before do
  if (key = params.delete('key')) &&  user = User.where(unique_key: key).first
    Thread.current[:current_account] = user.account
  else
    halt 401
  end
end

get '/schema' do
  if schema = Setup::Schema.where(library_id: params[:library_id], uri: params[:uri]).first
    schema.cenit_ref_schema(service_url: request.base_url)
  else
    halt 404
  end
end