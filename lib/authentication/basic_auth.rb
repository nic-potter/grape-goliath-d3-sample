require 'warden'

Warden::Strategies.add(:basic) do
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def valid?
    auth.provided? && auth.basic?
  end

  def login(username, password)
    puts "user: #{username}; pass: #{password}"
    if (username == 'nic') && (password == 'test123')
      return username
    end
  end

  def authenticate!
    if user = login(*auth.credentials)
      return success!(user)
    else
      custom!(unauthorized)
      throw(:warden, result: :custom)
    end
  end

  def unauthorized
    headers = {
      'Content-Type' => 'text/plain',
      'Content-Length' => '0',
      'WWW-Authenticate' => %(Basic realm="Warden Developer")
    }

    return [401, headers, []]
  end
end
