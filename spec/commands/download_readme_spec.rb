require 'rails_helper'

RSpec.describe DownloadReadme, type: :command do
  let(:logger) { instance_double(Logger) }
  let(:subject) { described_class.new(logger: logger) }

  before do
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
  end

  describe '#call' do
    describe 'success' do
      it 'downloads the README file' do
        VCR.use_cassette('readme') do
          expect { subject.call }.to change(RepositoryReadme, :count).by(1)
        end
      end
    end

    describe 'readme for the day already exists' do
      let!(:repository_for_today) { FactoryBot.create(:repository_readme, fetched_at: Time.current) }

      it 'does not create a new record' do
        expect { subject.call }.not_to change(RepositoryReadme, :count)
        expect(logger).to have_received(:info).with("Already up to date")
      end
    end

    describe 'failure' do
      it 'logs an error message' do
        response = instance_double(Faraday::Response, status: 404, reason_phrase: "Not Found", body: "")
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)

        subject.call

        expect(logger).to have_received(:error).with("Failed to fetch README: HTTP 404 Not Found")
      end
    end
  end
end
