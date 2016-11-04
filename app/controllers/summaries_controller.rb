class SummariesController < ApplicationController

  # GET /summaries.json?location=yemen&from=2016-1-1&to=2016-12-25

  # This could do with some refactoring - but it *does* work
  def index
    return unless params.key?(:location)

    parse_params(params)

    @country = Country.where('LOWER(name) = :location', location: "#{@location.downcase}")
    summaries = Strike.where(country: @country, date: @from..@to)

    @strike_data = summaries.group_by_month.count.sort.to_h.map { |key, value| { key.strftime("%b %Y") => value }}
    @strike_data = @strike_data.reduce Hash.new, :merge

    set_up_mapping_data(summaries)
    set_up_max_mins(summaries)

    @summaries = summaries
  end

  private

  def parse_params(params)
    @location = params[:location]
    @from = Date.parse(params[:from])
    @to = Date.current

    unless (params[:to] == 'now')
      @to = Date.parse(params[:to])
    end
  end

  def set_up_max_mins(summaries)
    @minimum_people_killed = aggregate_date(summaries, 'minimum_people_killed')
    @maximum_people_killed = aggregate_date(summaries, 'maximum_people_killed')

    @minimum_civilians_killed = aggregate_date(summaries, 'minimum_civilians_killed')
    @maximum_civilians_killed = aggregate_date(summaries, 'maximum_civilians_killed')

    @minimum_children_killed = aggregate_date(summaries, 'minimum_children_killed')
    @maximum_children_killed = aggregate_date(summaries, 'maximum_children_killed')

    @minimum_people_injured = aggregate_date(summaries, 'minimum_people_injured')
    @maximum_people_injured = aggregate_date(summaries, 'maximum_people_injured')
  end

  def set_up_mapping_data(summaries)
    # Hash with id, count
    location_summaries_hash = summaries.group(:location_id).count

    locations = Location.find(location_summaries_hash.keys)
    locations.delete_if { |l| l.latitude.nil? }

    @locations_array = Array.new
    @geographic_centre = Geocoder::Calculations.geographic_center(locations)

    location_summaries_hash.each do |location_id, count|
      location = locations.select { |l| l.id == location_id }.first
      @locations_array << { description: location.description, count: count, latitude: location.latitude, longitude: location.longitude } unless location.nil?
    end
  end

  def aggregate_date(summaries, field)
    summaries.inject(0) { |running_total, strike| running_total + strike.send(field) }
  end

end
