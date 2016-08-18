##
# Application controller
##
class V1ApiController < ActionController::Base
  before_action :parse_request, only: :create

  protected

  ##
  # Validate an argument is an integer and within defined limits
  ##
  def validate_int(num, min, max)
    begin
      num = Integer(num)
    # for catching nil
    rescue TypeError => e
      raise ArgumentError, e
    end

    not_between = (num < min) || (num > max)

    raise ArgumentError, t(:int_outside_limits) if not_between

    # rubocop:disable RedundantReturn
    return num
    # rubocop:enable RedundantReturn
  end

  ##
  # Render an error message as json
  ##
  def render_error(msg)
    error = { error: msg }
    render(json: error.to_json, status: :bad_request)
  end

  ##
  # Check request IP address matches a whitelisted IP
  #
  # @todo implement this
  ##
  def check_ip
    # @todo disable in development as well
    logger.debug(request.remote_ip) unless Rails.env.test?
  end

  ##
  #
  ##
  def set_json
    request.format = :json
  end

  private

  ##
  # Attempt to parse the request body
  ##
  def parse_request
    body = request.body.read
    render_error(t(:base_api_missing_body)) && return if body.blank?

    logger.debug(body)

    begin
      @json = JSON.parse(body)
    rescue JSON::ParserError => e
      render_error(t(:base_api_json_parse_error, msg: e.message)) && return
    end
  end
end
