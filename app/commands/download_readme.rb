class DownloadReadme
  def initialize
    @owner = "matheusfelipeog"
    @repo = "beautiful-docs"
  end

  def call
    conn = Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded           # Encode request parameters
      faraday.response :logger               # Log the request/response
      faraday.adapter Faraday.default_adapter # Use the default adapter (Net::HTTP)
    end

    # Make the GET request
    response = conn.get do |req|
      req.headers["Accept"] = "application/vnd.github.v3.raw" # Request raw content
    end

    if response.status == 200
      return "Already up to date" if repository_for_today?

      RepositoryReadme.create!(content: response.body, fetched_at: Time.current)
      puts "README.md has been saved successfully!"
    else
      puts "Failed to fetch README: #{response.status} #{response.reason_phrase}"
    end
  end

  private
  attr_reader :owner, :repo

  def url
    URI("https://api.github.com/repos/#{owner}/#{repo}/readme")
  end

  def repository_for_today?
    RepositoryReadme.where("fetched_at >= ?", Time.current.beginning_of_day).first
  end
end
