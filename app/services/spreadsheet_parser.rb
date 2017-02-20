require 'csv'

class SpreadsheetParser

  DEFAULT_SCOPE = [
    'https://www.googleapis.com/auth/drive',
    'https://spreadsheets.google.com/feeds/'
  ]

  PAKISTAN_KEY = { key: '1NAfjFonM-Tn7fziqiv33HlGt09wgLZDSCP-BQaux51w', tab: 'Drone strikes data' }
  YEMEN_KEY = { key: '1lb1hEYJ_omI8lSe33izwS2a2lbiygs0hTp2Al_Kz5KQ', tab: 'All US actions' }
  AFGHANISTAN_KEY = { key: '1Q1eBZ275Znlpn05PnPO7Q1BkI3yJZbvB3JycywAmqWc', tab: 'Bureau data: US strikes' }
  SOMALIA_KEY = { key: '1-LT5TVBMy1Rj2WH30xQG9nqr8-RXFVvzJE_47NlpeSY', tab: 'All US actions' }

  REPLACEMENT_KEYS = [
    { old: :maximum_total_people_killed, new: :maximum_people_killed },
    { old: :minimum_total_people_killed, new: :minimum_people_killed },
    { old: :maximum_civilians_reported_killed, new: :maximum_civilians_killed },
    { old: :minimum_civilians_reported_killed, new: :minimum_civilians_killed },
    { old: :minimum_children_reported_killed, new: :minimum_children_killed },
    { old: :maximum_children_reported_killed, new: :maximum_children_killed },
    { old: :maximum_reported_injured, new: :maximum_people_injured },
    { old: :minimum_reported_injured, new: :minimum_people_injured },
  ]

  OTHER_KEYS = [
    :strike_id, :date, :index, :location]

  def initialize(private_key, client_email)
    replacement_keys = REPLACEMENT_KEYS.map { |h| h[:new] }
    @keep_keys = OTHER_KEYS.concat(replacement_keys)
    @private_key = private_key
    @client_email = client_email

    raise ArgumentError, "Missing environment variables" unless @private_key && @client_email
  end

  def filter_unused_keys(hash)
    hash.select {|k,v| @keep_keys.include?(k) }
  end

  def unescape(s)
    YAML.load(%Q(---\n"#{s}"\n))
  end

  def make_credentials

    begin
      signing_key = OpenSSL::PKey::RSA.new(@private_key)
    rescue
      signing_key = OpenSSL::PKey::RSA.new(unescape(@private_key))
    end

    credentials = Signet::OAuth2::Client.new(token_credential_uri: Google::Auth::ServiceAccountCredentials::TOKEN_CRED_URI,
      audience: Google::Auth::ServiceAccountCredentials::TOKEN_CRED_URI,
      scope: DEFAULT_SCOPE,
      issuer: @client_email,
      signing_key: signing_key)

    credentials

  end

  def get_worksheet(spreadsheet_info)
    session = GoogleDrive::Session.new(make_credentials)
    sheet = session.spreadsheet_by_key(spreadsheet_info[:key])
    sheet.worksheet_by_title(spreadsheet_info[:tab])
  end

  def get_array_of_hashes(spreadsheet_info)
    ws = get_worksheet(spreadsheet_info)
    puts "Processing #{spreadsheet_info.to_s}"

    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end

    worksheet_as_string = ws.export_as_string
    worksheet_as_string.gsub!("Confirmed/\n", "Confirmed/")
    worksheet_as_string.gsub!("Counter-\n", "Counter-")

    csv = CSV.new(worksheet_as_string, headers: true, header_converters: [:symbol], converters: [:all, :blank_to_nil])
    array = csv.to_a

    p "size of array #{array.count}"

    array_of_hashes = array.map do |row|
      hash = convert_to_tidied_replace_key(row)
      hash = create_location(hash)
      hash
    end

    array_of_hashes = array_of_hashes.delete_if { |row| row.key?(:us_confirmed) && row[:us_confirmed] == 0 }
    array_of_hashes = array_of_hashes.delete_if { |row| row.key?(:confirmedpossible_us_attack) && row[:confirmedpossible_us_attack] != 'Confirmed' }
    array_of_hashes = array_of_hashes.delete_if { |row| row.key?(:drone_strike) && row[:drone_strike] == 0  }

    new_array_of_hashes = array_of_hashes.map do |hash|
      hash = filter_unused_keys(hash)
      hash
    end

    p "size of array of hashes #{new_array_of_hashes.count}"
    new_array_of_hashes
  end

  def convert_to_tidied_replace_key(row)
    hash = row.to_hash
    REPLACEMENT_KEYS.each do |replacement_hash|
      hash[replacement_hash[:new]] = hash.delete replacement_hash[:old] if hash.key?(replacement_hash[:old])
    end
    hash
  end

  def create_location(hash)
    if hash.key?(:area)
      hash[:location] = hash[:location] + ', ' + hash[:area]
    elsif hash.key?(:province)
      hash[:location] = hash[:province]
    elsif hash.key?(:district)
      hash[:location] = hash[:district] + ', ' + hash[:province]
    end
    hash

  end
end
