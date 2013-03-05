# -*- coding: utf-8 -*-
module DailymotionApi
  class Client
    API_URL = "https://api.dailymotion.com"

    attr_reader :video_id

    def initialize(params = {})
      @username = params[:username]
      @password = params[:password]
      @api_key = params[:api_key]
      @api_secret = params[:api_secret]
    end

    def request_access_token
      response = HTTMultiParty.post("#{API_URL}/oauth/token", body: {grant_type: "password", client_id: @api_key, client_secret: @api_secret, username: @username, password: @password})
      @access_token = response.parsed_response["access_token"]
    end

    def get_upload_url
      response = HTTMultiParty.get("#{API_URL}/file/upload?access_token=#{@access_token}")
      @upload_url = response.parsed_response["upload_url"]
    end

    def post_video(video)
      response = HTTMultiParty.post(@upload_url, body: {file: video})
      @uploaded_video_url = response.parsed_response["url"]
    end

    def create_video
      response = HTTMultiParty.post("#{API_URL}/me/videos", body: {access_token: @access_token, url: @uploaded_video_url})
      @video_id = response.parsed_response["id"]
    end

    def publish_video(data)
      HTTMultiParty.post("#{API_URL}/video/#{@video_id}", body: data.merge(access_token: @access_token, published: true))
    end

    def get_video(video_id, fields = "")
      return nil unless video_id

      response = HTTMultiParty.get("#{API_URL}/video/#{video_id}?fields=#{fields}")
      response.parsed_response
    end

    def video_url
      @video_url ||= get_video(@video_id, "url")["url"] rescue nil
    end
  end
end
