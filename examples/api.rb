require 'grape'
module Examples
  class API < ::Grape::API
    version 'v1', using: :path

    resource 'data' do
      params do
        optional :max, type: Integer, default: 1000
      end
      get '/:type' do
        header 'Access-Control-Allow-Origin', '*'
        Array.new(10).collect { |i| rand(params[:max]) }
      end
    end
  end
end
