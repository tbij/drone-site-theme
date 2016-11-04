class SpreadsheetsController < ApplicationController
  def create
    Dotenv.load
    SpreadsheetJob.delete_and_import_everything

    # Sort geocoding
    Location.not_geocoded.find_each(batch_size: 100) do |obj|
      obj.geocode; obj.save
      sleep(0.25.to_f)
    end

    redirect_to root_path
  end
end