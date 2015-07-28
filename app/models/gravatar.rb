class Gravatar
  attr_accessor :email

  def initialize(email)
    @email = email
  end

  def get_image(size = 200)
    if gravatar?
      URI.parse(image_url(size)).open
    else
      false
    end
  end

  private

    def image_url(size)
      gravatar_id = Digest::MD5::hexdigest(@email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png&?s=#{size}"
    end

    def gravatar?
      gravatar_check = "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(@email.downcase)}.png?d=404"
      uri = URI.parse(gravatar_check)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.code.to_i == 404 ? false : true
    end

end
