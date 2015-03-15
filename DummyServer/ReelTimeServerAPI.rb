require 'sinatra'
require 'sinatra/json'

get '/api/reels' do
    json :reels =>[]
end

get '/api/users' do
    list = []
    page = params[:page].to_i

    logger.info("page: #{page}")

    if page == 1 or page == 2
        count = 20
        initial = (page * count)

        (0..count).each { |num|
            i = initial + num
            list << { :username => "user#{i}", :display_name => "display#{i}", :follower_count => 1, :followee_count => 2 }
        }
    end

    json :users => list
end

get '/api/videos' do
    json :videos => []
end
