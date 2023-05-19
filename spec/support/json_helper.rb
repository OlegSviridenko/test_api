module JsonHelpers
  def json_response
    @json ||= JSON.parse(response.body)&.to_h&.with_indifferent_access
  end
end

RSpec.configure do |config|
  config.include JsonHelpers, type: :request
end
