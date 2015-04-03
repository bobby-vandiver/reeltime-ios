require 'rubygems'
require 'sinatra'
require 'sinatra/json'

get '/api/reels' do
    list = []
    page = params[:page].to_i

    logger.info("page: #{page}")

    if page == 1 or page == 2
        count = 20
        initial = (page * count)

        (0..count).each { |num|
            i = initial + num + 100
            list << { :reel_id => i, :name => "reel#{i}", :audience_size => 3, :video_count => 4 }
        }
    end

    json :reels => list
end

get '/api/users' do
    list = []
    page = params[:page].to_i

    logger.info("page: #{page}")

    if page == 1 or page == 2
        count = 20
        initial = (page * count)

        (0..count).each { |num|
            i = initial + num + 200
            list << { :username => "user#{i}", :display_name => "display#{i}", :follower_count => 1, :followee_count => 2 }
        }
    end

    json :users => list
end

get '/api/videos/:video_id/thumbnail' do
    content_type 'image/png'

    if params['resolution'] == 'small'
        File.read(File.join('DummyServer', 'batman-75-quality.png'))
    elsif params['resolution'] == 'medium'
        File.read(File.join('DummyServer', 'batman-150-quality.png'))
    elsif params['resolution'] == 'large'
        File.read(File.join('DummyServer', 'batman-225-quality.png'))
    end
end

get '/api/videos' do
    list = []
    page = params[:page].to_i

    logger.info("page: #{page}")

    if page == 1 or page == 2
        count = 20
        initial = (page * count)

        (0..count).each { |num|
            i = initial + num + 300
            list << { :video_id => i, :title => "title#{i}" }
        }
    end

    json :videos => list
end

