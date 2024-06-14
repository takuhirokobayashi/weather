class InvalidMeasurementCsvFileError < StandardError
  def initialize( message = I18n.t( 'errors.messages.invalid_measurement_csv_file_error' ) )
    super( message )
  end
end
