# Wrapper class for TxtLocal service
require 'net/https'

class TxtLocal::BaseService

  class BadRequest < StandardError; end

  protected

  def handle_response(&block)
    response = block.call
    response = JSON.parse(response.body)
    raise BadRequest.new(response['errors'].first) if response['status'] == 'failure'

    response
  end
end
