"use strict";

// Create global namespace to put stuff

var TBIJ_SEARCHCRITERIA = TBIJ_SEARCHCRITERIA || {};

function SearchCriteria(params) {
  var from = Date.parse('Oct 2010'),
  to = new Date(),
  // default to false if not set
  show_strikes = params.show_strikes === 'on',
  show_casualties = params.show_casualties === 'on',
  show_injuries = params.show_injuries === 'on',
  selectLocation = 'choose',
  monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

  if (params.location) {
    selectLocation = params.location;
  }
  return ({ from: from, to: to, show_injuries: show_injuries, show_strikes: show_strikes, show_casualties: show_casualties, location: selectLocation, monthNames: monthNames});
}

function SearchFunction(searchCriteria) {

  // Don't allow search if location not selected
  $('section.data-tools button').click(function(event) {
    if ($("select[name='location']").val() == "choose") {
      event.preventDefault();
    }
  });

  var updateFromRequestParams = function() {

    var setSelectOption = function(searchCriteria, select_name) {
      if (searchCriteria[select_name]) {
        $('select[name=' + select_name + '] option[value="' + searchCriteria[select_name] + '"]').prop('selected', true);
      }
    };

    var setCheckBox = function(searchCriteria, checkbox_name) {
      if (searchCriteria[checkbox_name]) {
        $('input[name=' + checkbox_name + ']').prop('checked', true);
      }
    };

    setSelectOption(searchCriteria, 'location');
    setSelectOption(searchCriteria, 'from');
    setSelectOption(searchCriteria, 'to');
    setCheckBox(searchCriteria, 'show_injuries');
    setCheckBox(searchCriteria, 'show_strikes');
    setCheckBox(searchCriteria, 'show_casualties');
  };

  var setUpSelectBoxes =  function() {

    var setUpOptions = function(fromOrTo) {
      var monthNames = searchCriteria.monthNames;

      //Create array of options to be added
      var currentYear = new Date().getFullYear();
      var selectList = document.querySelectorAll('section.data-tools select[name=' + fromOrTo + ']')[0];
      // default
      var dayToUse = 1;

      for (var fullYear = 2010; fullYear <= currentYear; fullYear++) {
        //Create and append the options
        for (var monthIndex = 0; monthIndex < monthNames.length; monthIndex++) {
            var option = document.createElement("option");
            if (fromOrTo == 'to') {
              dayToUse = new Date(fullYear, monthIndex + 1, 0).getUTCDate();
            }
            option.setAttribute("value", fullYear + '-' + (parseInt(monthIndex)+1) + '-' + dayToUse);
            option.text = monthNames[monthIndex] + ' ' + fullYear;
            selectList.appendChild(option);
        }
      }
    };
    setUpOptions('from');
    setUpOptions('to');
  };
  setUpSelectBoxes();
  updateFromRequestParams();
}

$(document).ready(function() {
  if (document.querySelectorAll('section.data-tools')) {
    var params = URI.parseQuery(window.location.search);
    TBIJ_SEARCHCRITERIA.searchCriteria = new SearchCriteria(params);

    new SearchFunction(TBIJ_SEARCHCRITERIA.searchCriteria);
  }
});
