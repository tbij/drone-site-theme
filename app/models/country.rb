# == Schema Information
#
# Table name: countries
#
#  id              :integer          not null, primary key
#  name            :string
#  spreadsheet_key :string
#  spreadsheet_tab :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Country < ApplicationRecord

  has_many :strikes

  def details
    { key: spreadsheet_key, tab: spreadsheet_tab }
  end
end
