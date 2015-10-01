require 'net/http'
class Gravatar
  attr_accessor :email, :gravatar_id

  def initialize(email)
    @email = email
    @gravatar_id = Digest::MD5::hexdigest(@email).downcase
  end

  def get_image(size = 200)
    if gravatar?
      open(image_url(size))
    else
      false
    end
  end

  private

    def image_url(size)
      "http://gravatar.com/avatar/#{@gravatar_id}.png&?s=#{size}"
    end

    def gravatar?
      gravatar_check = "http://gravatar.com/avatar/#{@gravatar_id}.png?d=404"
      uri = URI.parse(gravatar_check)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.code.to_i == 200 ? true : false
    end

end
