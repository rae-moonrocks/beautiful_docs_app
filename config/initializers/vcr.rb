if Rails.env.development? || Rails.env.test?
  require "vcr"
  VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :faraday
    config.allow_http_connections_when_no_cassette = true
    config.debug_logger = File.open("log/vcr.log", "w")
  end
end
