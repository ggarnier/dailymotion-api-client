# -*- coding: utf-8 -*-
require "spec_helper"

describe DailymotionApi::Client do
  before do
    HTTMultiParty.stub(:get)
    HTTMultiParty.stub(:post)
  end

  let! :client do
    DailymotionApi::Client.new(username: "test", password: "12345", api_key: "key", api_secret: "secret")
  end

  describe "#request_access_token" do
    it "should do a request for an access token" do
      response = stub("response", parsed_response: {"access_token" => "token"})
      HTTMultiParty.should_receive(:post).with("https://api.dailymotion.com/oauth/token", body: {grant_type: "password", client_id: "key", client_secret: "secret", username: "test", password: "12345"}).and_return(response)

      client.request_access_token.should == "token"
    end
  end

  describe "#get_upload_url" do
    it "should request an upload url" do
      client.instance_variable_set(:@access_token, "token")
      response = stub("response", parsed_response: {"upload_url" => "upload_url"})
      HTTMultiParty.should_receive(:get).with("https://api.dailymotion.com/file/upload?access_token=token").and_return(response)

      client.get_upload_url.should == "upload_url"
    end
  end

  describe "#post_video" do
    it "should post the video" do
      client.instance_variable_set(:@upload_url, "upload_url")
      response = stub("response", parsed_response: {"url" => "video_url"})
      HTTMultiParty.should_receive(:post).with("upload_url", body: {file: "video_data"}).and_return(response)

      client.post_video("video_data").should == "video_url"
    end
  end

  describe "#create_video" do
    it "should post the video" do
      client.instance_variable_set(:@access_token, "token")
      client.instance_variable_set(:@video_url, "video_url")
      response = stub("response", parsed_response: {"id" => "video_id"})
      HTTMultiParty.should_receive(:post).with("https://api.dailymotion.com/me/videos", body: {access_token: "token", url: "video_url"}).and_return(response)

      client.create_video.should == "video_id"
    end
  end

  describe "#publish_video" do
    it "should publish the video" do
      client.instance_variable_set(:@access_token, "token")
      client.instance_variable_set(:@video_id, "video_id")
      HTTMultiParty.should_receive(:post).with("https://api.dailymotion.com/video/video_id", body: {access_token: "token", published: true, title: "video title", channel: "shortfilms", tags: "some_tag"})

      client.publish_video(title: "video title", channel: "shortfilms", tags: "some_tag")
    end
  end
end
