class FetchReadmeJob
  include Sidekiq::Job

  def perform
    DownloadReadme.new(logger: Sidekiq.logger).call
  end
end
