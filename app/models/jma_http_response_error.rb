class JmaHttpResponseError < StandardError
  def initialize( message = I18n.t( 'errors.messages.http_response_error' ) )
    super( message )
  end
end
