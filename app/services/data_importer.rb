class DataImporter

  def initialize(country, array_of_hashes)
    @country = country
    @array_of_hashes = array_of_hashes
  end

  def import_country
    @array_of_hashes.each do |hash|
      hash[:country_id] = @country.id

      location_description = hash[:location] + ", #{@country.name}"

      hash.delete(:location)

      location = Location.where(country: @country, description: location_description).first_or_create
      hash[:location_id] = location.id
      Strike.create(hash)

      ap hash
    end
  end

  def self.reset_strikes
    Strike.all.delete_all
  end

  def self.create_countries
    Country.where(name: 'Afghanistan', spreadsheet_key: SpreadsheetParser::AFGHANISTAN_KEY[:key], spreadsheet_tab: SpreadsheetParser::AFGHANISTAN_KEY[:tab]).first_or_create
    Country.where(name: 'Pakistan', spreadsheet_key: SpreadsheetParser::PAKISTAN_KEY[:key], spreadsheet_tab: SpreadsheetParser::PAKISTAN_KEY[:tab]).first_or_create
    Country.where(name: 'Somalia', spreadsheet_key: SpreadsheetParser::SOMALIA_KEY[:key], spreadsheet_tab: SpreadsheetParser::SOMALIA_KEY[:tab]).first_or_create
    Country.where(name: 'Yemen', spreadsheet_key: SpreadsheetParser::YEMEN_KEY[:key], spreadsheet_tab: SpreadsheetParser::YEMEN_KEY[:tab]).first_or_create
  end
end