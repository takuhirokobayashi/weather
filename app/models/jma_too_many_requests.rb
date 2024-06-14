class JmaTooManyRequests < StandardError
  def initialize( message = I18n.t( 'errors.messages.too_many_requests' ) )
    super( message )
  end
end
