require 'bundler/setup'
require './examples/api'
# add the basic authentication to warden
require './lib/authentication/basic_auth'
require 'goliath'

class Application < Goliath::API
  use Rack::Session::Cookie, secret: 'my app secret'
  use Warden::Manager do |manager|
    manager.default_strategies :basic
    #manager.failure_app = lambda{ |env| puts env['warden.options'];  [401, {}, []] }
    #manager.intercept_401 = false
  end

  def response(env)
    env['warden'].authenticate!(:basic)
    ::Examples::API.call(env)
  end
end
