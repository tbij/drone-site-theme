namespace :spreadsheet do
  task import: :environment do

    Dotenv.load

    SpreadsheetJob.delete_and_import_everything

  end
end


