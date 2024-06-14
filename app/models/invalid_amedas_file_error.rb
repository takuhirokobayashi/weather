class InvalidAmedasFileError < StandardError
  def initialize( message = I18n.t( 'errors.messages.invalid_amedas_file_error' ) )
    super( message )
  end
end
