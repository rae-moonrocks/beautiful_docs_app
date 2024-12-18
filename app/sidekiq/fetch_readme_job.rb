class FetchReadmeJob
  include Sidekiq::Job

  def perform(*args)
    DownloadReadme.new.call
  end
end
