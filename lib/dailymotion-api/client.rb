# frozen_string_literal: true

module DailymotionApi
  class Error < StandardError; end

  class Client
    require "httmultiparty"
    require "net/http/post/multipart"

    API_URL = "https://api.dailymotion.com"

    attr_reader :video_id

    def initialize(params = {})
      @username = params[:username]
      @password = params[:password]
      @api_key = params[:api_key]
      @api_secret = params[:api_secret]
    end

    def request_access_token
      response = HTTMultiParty.post("#{API_URL}/oauth/token", body: request_access_token_params)
      @access_token = response.parsed_response["access_token"]
    end

    def request_access_token_manage_videos_scope
      response = HTTMultiParty.post("#{API_URL}/oauth/token", body: request_access_token_params.merge(scope: "manage_videos"))
      @access_token = response.parsed_response["access_token"]
    end

    def generate_upload_url
      response = HTTMultiParty.get("#{API_URL}/file/upload?access_token=#{@access_token}")
      @upload_url = response.parsed_response["upload_url"]
    end

    def post_video(video)
      url = URI.parse(@upload_url)
      response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |https|
        request = Net::HTTP::Post::Multipart.new(@upload_url, file: UploadIO.new(video, "video/mp4"))
        https.request(request)
      end
      @uploaded_video_url = JSON.parse(response.body)["url"]
    end

    def create_video
      response = HTTMultiParty.post("#{API_URL}/me/videos", body: { access_token: @access_token, url: @uploaded_video_url })
      @video_id = response.parsed_response["id"]
    end

    def publish_video(metadata)
      HTTMultiParty.post("#{API_URL}/video/#{@video_id}", body: metadata.merge(access_token: @access_token, published: true))
    end

    def get_video(video_id, fields = "")
      return nil unless video_id

      url = "#{API_URL}/video/#{video_id}"
      url += "?fields=#{fields}" unless fields.empty?

      response = HTTMultiParty.get(url)
      response.parsed_response
    end

    def video_url
      @video_url ||=  begin
                        get_video(@video_id, "url")["url"]
                      rescue StandardError
                        nil
                      end
    end

    def get_authenticated_user_videos(fields = "")
      response =  if fields.empty?
        HTTMultiParty.get("#{API_URL}/me/videos", headers: { "Authorization" => "Bearer #{@access_token}" })
      else
        HTTMultiParty.get("#{API_URL}/me/videos?fields=#{fields}", headers: { "Authorization" => "Bearer #{@access_token}" })
      end

      response.parsed_response
    end

    def get_authenticated_user_info(fields = "")
      response =  if fields.empty?
        HTTMultiParty.get("#{API_URL}/me/", headers: { "Authorization" => "Bearer #{@access_token}" })
      else
        HTTMultiParty.get("#{API_URL}/me?fields=#{fields}", headers: { "Authorization" => "Bearer #{@access_token}" })
      end

      response.parsed_response
    end

    def delete_video(video_id)
      # It's required to get an access token with manage_videos scope
      return nil unless video_id

      response = HTTMultiParty.delete("#{API_URL}/me/videos/#{video_id}", headers: { "Authorization" => "Bearer #{@access_token}" })
      response.parsed_response
    end

    private
      def request_access_token_params
        { grant_type: "password", client_id: @api_key, client_secret: @api_secret, username: @username, password: @password }
      end
  end
end
