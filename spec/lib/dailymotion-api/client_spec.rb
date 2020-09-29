# frozen_string_literal: true

require "spec_helper"

RSpec.describe DailymotionApi::Client do
  let! :client do
    DailymotionApi::Client.new(username: "test", password: "12345", api_key: "key", api_secret: "secret")
  end

  it "has a version number" do
    expect(DailymotionApi::VERSION).not_to be nil
    expect(DailymotionApi::VERSION).to eq "0.2.3"
  end

  describe "#request_access_token" do
    it "should do a request for an access token" do
      response = instance_double("response", parsed_response: { "access_token" => "token" })
      allow(HTTMultiParty).to receive(:post)
        .with("https://api.dailymotion.com/oauth/token",
          body: {
            grant_type: "password", client_id: "key", client_secret: "secret", username: "test", password: "12345"
          }
        ).and_return(response)

      expect(client.request_access_token).to eq "token"
    end
  end

  describe "#generate_upload_url" do
    it "should request an upload url" do
      client.instance_variable_set(:@access_token, "token")
      response = instance_double("response", parsed_response: { "upload_url" => "upload_url" })
      allow(HTTMultiParty).to receive(:get)
        .with("https://api.dailymotion.com/file/upload?access_token=token")
        .and_return(response)

      expect(client.generate_upload_url).to eq "upload_url"
    end
  end

  describe "#post_video" do
    it "should post the video" do
      client.instance_variable_set(:@upload_url, "upload_url")
      response = instance_double("response", parsed_response: "{\"url\":\"video_url\"}")
      allow(HTTMultiParty).to receive(:post)
        .with("upload_url", body: { file: "video_data" })
        .and_return(response)

      expect(client.post_video("video_data")).to eq "video_url"
    end
  end

  describe "#create_video" do
    it "should post the video" do
      client.instance_variable_set(:@access_token, "token")
      client.instance_variable_set(:@uploaded_video_url, "video_url")
      response = instance_double("response", parsed_response: { "id" => "video_id" })
      allow(HTTMultiParty).to receive(:post)
        .with("https://api.dailymotion.com/me/videos", body: { access_token: "token", url: "video_url" })
        .and_return(response)

      expect(client.create_video).to eq "video_id"
    end
  end

  describe "#publish_video" do
    it "should publish the video" do
      client.instance_variable_set(:@access_token, "token")
      client.instance_variable_set(:@video_id, "video_id")
      allow(HTTMultiParty).to receive(:post)
        .with("https://api.dailymotion.com/video/video_id",
          body: {
            access_token: "token", published: true, title: "video title", channel: "shortfilms", tags: "some_tag"
          }
        )

      client.publish_video(title: "video title", channel: "shortfilms", tags: "some_tag")
    end
  end

  describe "#get_video" do
    context "without parameters" do
      it "should return requested video metadata" do
        parsed_response = { "url" => "video_url", "channel" => "video_channel" }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/video/123?fields=url,channel")
          .and_return(response)

        expect(client.get_video("123", "url,channel")).to eq parsed_response
      end
    end

    context "with parameters" do
      it "should return basic video metadata" do
        parsed_response = { "id" => "video_id", "title" => "my video" }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/video/123")
          .and_return(response)

        expect(client.get_video("123")).to eq parsed_response
      end
    end
  end

  describe "#video_url" do
    context "when video_id is defined" do
      it "should return the video url" do
        client.instance_variable_set(:@video_id, "video_id")
        response = instance_double("response", parsed_response: { "url" => "url" })
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/video/video_id?fields=url")
          .and_return(response)

        expect(client.video_url).to eq "url"
      end
    end

    context "when video_id isn't defined" do
      it "should return nil" do
        expect(client.video_url).to be_nil
      end
    end

    describe "#request_access_token_manage_videos_scope" do
      it "should do a request for an access token with manage videos scrope" do
        response = instance_double("response", parsed_response: { "access_token" => "token" })
        allow(HTTMultiParty).to receive(:post)
          .with("https://api.dailymotion.com/oauth/token",
            body: {
              grant_type: "password", client_id: "key", client_secret: "secret",
              username: "test", password: "12345", scope: "manage_videos"
            }
          ).and_return(response)

        expect(client.request_access_token_manage_videos_scope).to eq "token"
      end
    end

    describe "#get_authenticated_user_info " do
      it "should return the information of an user authenticated with filters" do
        parsed_response = { "id" => "id", "screenname" => "screenname" }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/me?fields=id,screenname",
            headers: { "Authorization" => "Bearer #{@access_token}" }
          ).and_return(response)

        expect(client.get_authenticated_user_info("id,screenname")).to eq parsed_response
      end
    end

    describe "#get_authenticated_user_info" do
      it "should return the information of an user authenticated without filters" do
        parsed_response = { "id" => "id", "screenname" => "screenname" }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/me/", headers: { "Authorization" => "Bearer #{@access_token}" })
          .and_return(response)

        expect(client.get_authenticated_user_info).to eq parsed_response
      end
    end

    describe "#get_authenticated_user_videos" do
      it "should return the information of an user authenticated with filters" do
        parsed_response = {
          "page" => "1", "limit" => "10", "explicit" => "false", "total" => "1", "has_more" => "false",
          "list" => [{ "id" => "idvideo", "title" => "testvideo" }]
        }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
          .with("https://api.dailymotion.com/me/videos?fields=id,title",
            headers: {  "Authorization" => "Bearer #{@access_token}" }
          ).and_return(response)

        expect(client.get_authenticated_user_videos("id,title")).to eq parsed_response
      end
    end

    describe "#get_authenticated_user_videos" do
      it "should return the information of an user authenticated without filters" do
        parsed_response = {
          "page" => "1", "limit" => "10", "explicit" => "false", "total" => "1", "has_more" => "false",
          "list" => [{ "id" => "idvideo", "title" => "testvideo", "channel" => "sportTest", "owner" => "test" }]
        }
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:get)
        .with("https://api.dailymotion.com/me/videos",
          headers: { "Authorization" => "Bearer #{@access_token}" }
        ).and_return(response)

        expect(client.get_authenticated_user_videos).to eq parsed_response
      end
    end

    describe "#delete_video" do
      it "should delete a specific video" do
        parsed_response = {}
        response = instance_double("response", parsed_response: parsed_response)
        allow(HTTMultiParty).to receive(:delete)
        .with("https://api.dailymotion.com/me/videos/xxx",
          headers: { "Authorization" => "Bearer #{@access_token}" }
        ).and_return(response)

        expect(client.delete_video("xxx")).to eq parsed_response
      end
    end
  end
end
