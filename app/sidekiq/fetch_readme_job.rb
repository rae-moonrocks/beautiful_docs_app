class FetchReadmeJob
  include Sidekiq::Job

  def perform(*args)
    DownloadReadme.new(logger: Sidekiq.logger).call
  end
end
