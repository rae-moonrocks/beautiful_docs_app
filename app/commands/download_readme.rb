class DownloadReadme
  def initialize(logger: Rails.logger)
    @owner = "matheusfelipeog"
    @repo = "beautiful-docs"
    @logger = logger
  end

  def call
    return logger.info "Already up to date" if repository_for_today?

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
      RepositoryReadme.create!(content: response.body, fetched_at: Time.current)
      logger.info "README.md has been saved successfully!"
    else
      logger.error "Failed to fetch README: HTTP #{response.status} #{response.reason_phrase}"
    end
  end

  private
  attr_reader :owner, :repo, :logger

  def url
    URI("https://api.github.com/repos/#{owner}/#{repo}/readme")
  end

  def repository_for_today?
    RepositoryReadme.where("fetched_at >= ?", Time.current.beginning_of_day).first
  end
end
