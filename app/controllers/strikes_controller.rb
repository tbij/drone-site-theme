class StrikesController < ApplicationController
  before_action :set_strike, only: [:show]

  # GET /strikes
  # GET /strikes.json

  # GET /strikes.json?location=yemen&from=2016-1-1&to=2016-12-25

  def index
    if params.key?(:location)
      @location = params[:location]
      @from = Date.parse(params[:from])
      @to = Date.parse(params[:to])
      @country = Country.where('LOWER(name) = :location', location: "#{@location.downcase}")
      @strikes = Strike.where(country: @country, date: @from..@to)
    else
      @strikes = Strike.all
    end
  end

  # GET /strikes/1
  # GET /strikes/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strike
      @strike = Strike.find(params[:id])
    end
end
