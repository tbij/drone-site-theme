"use strict";

function DroneData(queryFromInput, queryToInput, queryLocationInput) {

  var droneData = {};
  var queryFrom = queryFromInput;
  var queryTo = queryToInput;
  var queryLocation = queryLocationInput;
  var injuryChartData;
  var strikeChartData;
  var casualtyChartData;

  var ableToCall =  function() {
    return queryFrom && queryTo && queryLocation;
  };
  var doAjaxCall = function(successCallback) {
    $.ajax({
      url: "/summaries.json?location=" + queryLocation + "&from=" + queryFrom + "&to=" + queryTo
    }).done(function(data) {
       droneData = data.droneData;
       strikeChartData = getStrikeDataset(droneData.strikeData);
       injuryChartData = getInjuryDataset(droneData.injuryData);
       casualtyChartData = getCasualtyDataset(droneData.casualtyData);
       successCallback(strikeChartData, injuryChartData, casualtyChartData, droneData);
    });
  };

  var getStrikeDataset =  function(strikeData) {
   var strikesDatasetSetup = TBIJDRONECHART_CONSTANTS.strikesDatasetOptions;
   strikesDatasetSetup.data = strikeData.values;
   var data = {
        labels: strikeData.labels,
        datasets: [ strikesDatasetSetup ]
   };
   return data;
  };

  var getCasualtyDataset = function(casualtyData) {
    var data = {
        labels: casualtyData.labels,
        datasets: [{
            label: 'Minimum',
            backgroundColor: "#cc4242",
            data:  casualtyData.minumums,
        }, {
            label: 'Maximum',
            backgroundColor: "#9e6969",
            data: casualtyData.maximums
        }]
    };
    return data;
  };

  var getInjuryDataset = function(injuryData) {
    var data = {
        labels: injuryData.labels,
        datasets: [{
            label: 'Minimum',
            backgroundColor: "#cc4242",
            data: injuryData.minumums
        }, {
            label: 'Maximum',
            backgroundColor: "#9e6969",
            data: injuryData.maximums
        }]
    };
    return data;
  };

  return {
    droneData: droneData,
    ableToCall: ableToCall,
    doAjaxCall: doAjaxCall
  };
}

function ChartHandler(params) {

  var showStrikes = params.show_strikes,
  showCasualties = params.show_casualties,
  showInjuries =  params.show_injuries;
  var droneData;
  var dateDisplayString = 'Woof Woof';

  var callback = function(strikeChartData, injuryChartData, casualtyChartData, rawDroneData) {

    if (strikeChartData !== undefined && strikeChartData.labels.length) {
      dateDisplayString = getFormattedDates(strikeChartData.labels[0], strikeChartData.labels[strikeChartData.labels.length - 1]);
    }

    var dateDisplay = document.querySelectorAll("li[name='dates'")[0];
    dateDisplay.innerHTML = dateDisplayString;

    droneData = rawDroneData;

    if (showStrikes) {
      setUpStrikeChart(strikeChartData);
      $('#strikes_chart').removeClass('hide2');
    }
    if (showCasualties) {
      setUpCasualtyChart(casualtyChartData);
      $('#casualties_chart').removeClass('hide2');
    }
    if (showInjuries) {
      setUpInjuryChart(injuryChartData);
      $('#injuries_chart').removeClass('hide2');
    }
    setUpMap(rawDroneData.mappingData);

    $('#intro_data,#provinces_section,.data-results').removeClass('hide2');
  };

  var getFormattedDates =  function(from, to) {
    var toDate = new Date();
    if (to != 'now' && to != 'Now') {
      toDate = new Date(to);
    }
    var fromDate = new Date(from);
    return getDateString(fromDate) + ' - ' + getDateString(toDate);
  };

  var getDateString = function(date) {
    return TBIJ_SEARCHCRITERIA.searchCriteria.monthNames[date.getMonth()] + ' ' + date.getFullYear();
  };

  var setUpCasualtyChart = function(casualtyDataset) {
    var ctx = document.getElementById("casualty-report");
    var myBarChart = new Chart(ctx, {
      type: 'horizontalBar',
      data: casualtyDataset,
      options: TBIJDRONECHART_CONSTANTS.casualtyReportOptions
    });
    var reportedValues = document.getElementById("reported_values");
    var minimum = droneData.casualtyData.minumums[0];
    var maximum = droneData.casualtyData.maximums[0];
    reportedValues.innerHTML = minimum + '-' + maximum;
  };

  var setUpStrikeChart = function(strikeData) {
    var ctx = document.getElementById("strikes-report");
    var myLineChart = new Chart(ctx, {
      type: 'line',
      data: strikeData,
      options: TBIJDRONECHART_CONSTANTS.strikeReportOptions
    });
    var strikesValue = document.getElementById("strikes_value");
    var totalStrikes = droneData.strikeData.values.reduce(function(a, b) {
      return a + b;
    }, 0);
    strikesValue.innerHTML = totalStrikes;
  };

  var setUpInjuryChart = function(injuryData) {
    var injuredValues = document.getElementById("injured_values");
    var minimum = droneData.injuryData.minumums[0];
    var maximum = droneData.injuryData.maximums[0];
    injuredValues.innerHTML = minimum + '-' + maximum;
    var ctx = document.getElementById("injury-report");
    var myBarChart = new Chart(ctx, {
      type: 'horizontalBar',
      data: injuryData,
      options: TBIJDRONECHART_CONSTANTS.casualtyReportOptions
    });
  };

  var setUpMap = function(mappingData) {
    var provincesMap = L.map('provinces_map').setView(mappingData.geographicCentre, 7);
    L.tileLayer('http://korona.geog.uni-heidelberg.de/tiles/roadsg/x={x}&y={y}&z={z}', {
      maxZoom: 19,
      attribution: 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(provincesMap);

    for(var i = 0; i < mappingData.locations.length; i++) {
      var location = mappingData.locations[i];
      L.circle([location.latitude, location.longitude], location.count * 1000, {color: getColourCircle(location.count)}).addTo(provincesMap);
    }
  };

  var getColourCircle = function(count) {
    return count > 50   ? '#FC4E2A' :
           count > 20   ? '#E31A1C' :
           count > 10   ? '#BD0026' :
                          '#800026';
  };

  var updateLocations = function(paramsLocation) {
    var displayLocation = paramsLocation[0].toUpperCase() + paramsLocation.substr(1);
    var locations = document.getElementsByName('selectedLocation');
    for(var x = 0; x < locations.length; x++) {
      locations[x].innerHTML = displayLocation;
    }
  };

  return {
    callback: callback,
    updateLocations: updateLocations
  };
}

$(document).ready(function() {
  if (document.getElementById("strikes-report")) {

    var params = URI.parseQuery(window.location.search);
    var queryParamsLocation = params.location;
    var tdd = new DroneData(params.from, params.to, queryParamsLocation);
    var tdc = new ChartHandler(params);

    if (tdd.ableToCall()) {
      tdd.doAjaxCall(tdc.callback);
    }

    if (queryParamsLocation) {
      tdc.updateLocations(queryParamsLocation);
    }
    return({ tdd: tdd, tdc: tdc});
  }
});
