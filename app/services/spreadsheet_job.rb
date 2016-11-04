class SpreadsheetJob

  def self.delete_and_import_everything

    private_key = ENV[Google::Auth::CredentialsLoader::PRIVATE_KEY_VAR]
    client_email = ENV[Google::Auth::CredentialsLoader::CLIENT_EMAIL_VAR]

    raise ArgumentError, "Missing environment variables" unless private_key && client_email

    DataImporter.create_countries
    DataImporter.reset_strikes

    spreadsheet_parser = SpreadsheetParser.new(private_key, client_email)

    Country.all.each do |country|
      array_of_hashes = spreadsheet_parser.get_array_of_hashes(country.details)
      DataImporter.new(country, array_of_hashes).import_country
    end

  end

end