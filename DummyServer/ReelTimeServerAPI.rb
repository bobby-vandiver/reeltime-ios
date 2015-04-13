require 'rubygems'
require 'sinatra'
require 'sinatra/json'

helpers do
    def listReels
        list = []
        page = params[:page].to_i

        logger.info("page: #{page}")

        if page == 1 or page == 2
            count = 20
            initial = (page * count)

            (0..count).each { |num|
                i = initial + num + 100
                list << {
                    :reel_id => i,
                    :name => "reel#{i}",
                    :audience_size => 3,
                    :video_count => 4,
                    :owner => {
                        :username => "user#{i * 2}",
                        :display_name => "display#{i * 2}",
                        :follower_count => 1,
                        :followee_count => 2,
                        :reel_count => 3,
                        :audience_membership_count => 4
                    }
                }
            }
        end

        json :reels => list
    end

    def listVideos
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
end

get '/api/reels' do
    listReels
end

get '/api/reels/:reel_id/videos' do
    listVideos
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
            list << { :username => "user#{i}", :display_name => "display#{i}", :follower_count => 1, :followee_count => 2, :reel_count => 3, :audience_membership_count => 4 }
        }
    end

    json :users => list
end

get '/api/users/:username' do
    username = params[:username]
    map = { :username => "#{username}", :display_name => "display #{username}", :follower_count => 1, :followee_count => 2, :reel_count => 3, :audience_membership_count => 4 }
    json map
end

get '/api/users/:username/reels' do
    listReels
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
    listVideos
end

