require 'rails_helper'

RSpec.describe FetchReadmeJob, type: :job do
  it 'enqueues a job' do
    expect { FetchReadmeJob.perform_async }.to enqueue_sidekiq_job
  end

  describe '#perform' do
    it 'calls DownloadReadme with the Sidekiq logger' do
      logger_double = double('logger')
      allow(Sidekiq).to receive(:logger).and_return(logger_double)
      download_readme_instance = instance_double(DownloadReadme)

      expect(DownloadReadme).to receive(:new).with(logger: logger_double).and_return(download_readme_instance)
      expect(download_readme_instance).to receive(:call)

      FetchReadmeJob.new.perform
    end
  end
end
