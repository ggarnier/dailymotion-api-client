# DailyMotion API Ruby Client

Client for DailyMotion API (http://www.dailymotion.com/doc/api/graph-api.html) written in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'dailymotion-api-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dailymotion-api-client

## Usage

### Publishing a video

    # Create an instance of DailymotionApi::Client
    client = DailymotionApi::Client.new(username: "username", password: "password", api_key: "key", api_secret: "secret")
    # Request an access token
    client.request_access_token
    # Request an upload url
    client.get_upload_url
    # Post your video
    client.post_video(File.new("my_video.mp4"))
    # Create a video
    client.create_video
    # Update video data an publish it
    client.publish_video(title: "my video", channel: "shortfilms", tags: "my_tag")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
