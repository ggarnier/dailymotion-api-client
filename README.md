# DailyMotion API Ruby Client

[![Build Status](https://travis-ci.org/ggarnier/dailymotion-api-client.svg)](https://travis-ci.org/ggarnier/dailymotion-api-client)

Client for DailyMotion API (http://www.dailymotion.com/doc/api/graph-api.html) written in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'dailymotion-api-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dailymotion-api-client

## Usage

To use this client, you need to register an account at Dailymotion and [create an API key](http://www.dailymotion.com/settings/developer/new). You need an API key and API secret.

```ruby
# Create an instance of DailymotionApi::Client
client = DailymotionApi::Client.new(username: "username", password: "password", api_key: "key", api_secret: "secret")
```

### Publishing a video

```ruby
# Request an access token
client.request_access_token

# Request an upload url
client.get_upload_url

# Post your video
client.post_video(File.new("my_video.mp4"))

# Create a video
client.create_video

# Update video metadata an publish it
client.publish_video(title: "my video", channel: "shortfilms", tags: "my_tag")
```

### Getting info about a published video

```ruby
# Get specific fields for a video with id "video_id"
client.get_video("video_id", "url,title")
=> {"url"=>"http://www.dailymotion.com/video/video_id_my-video_shortfilms", "title"=>"my video"}
```

### Getting info about authenticated user

```ruby
client.request_access_token

client.get_information_user_authenticated
=> {"id"=>"owner_id", "screenname"=>"username"}

client.get_information_user_authenticated("screenname")
=> {"screenname"=>"username"}
```

### Getting a list of videos published by authenticated user

```ruby
client.request_access_token

client.get_videos_user_authenticated
=> {"page"=>1, "limit"=>10, "explicit"=>false, "total"=>1, "has_more"=>false, "list"=>[{"id"=>"video_id", "title"=>"my video", "channel"=>"shortfilms", "owner"=>"owner_id"}]}

client.get_videos_user_authenticated("url")
 => {"page"=>1, "limit"=>10, "explicit"=>false, "total"=>1, "has_more"=>false, "list"=>[{"url"=>"http://www.dailymotion.com/video/video_id_my-video_shortfilms"}]}
```

### Deleting a video

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
