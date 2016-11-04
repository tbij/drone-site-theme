json.set! :droneData do
  json.set! :strikeData do
    json.set! :labels, @strike_data.keys
    json.set! :values, @strike_data.values
  end

  json.set! :casualtyData do
    json.set! :labels, ["Total", "Civilians", "Children"]
    json.set! :minumums, [@minimum_people_killed, @minimum_civilians_killed, @minimum_children_killed]
    json.set! :maximums, [@maximum_people_killed, @maximum_civilians_killed, @maximum_children_killed]

  end

  json.set! :injuryData do
    json.set! :labels, ["Injured"]
    json.set! :minumums, [@minimum_people_injured]
    json.set! :maximums, [@maximum_people_injured]
  end

  json.set! :mappingData do
    json.set! :locations, @locations_array
    json.set! :geographicCentre, @geographic_centre
  end
end


# var EXAMPLE_DATA = {
#   strikeData: {
#     labels: ["January 2012", "February 2012", "March 2012", "April 2012", "May 2012", "June 2012", "July 2012"],
#     values: [65, 59, 80, 81, 56, 55, 40]
#   },
#   casualtyData: {
#     labels: ["Total", "Civilians", "Children"],
#     minumums: [550, 400, 300],
#     maximums: [600, 420, 350]
#   }
# };