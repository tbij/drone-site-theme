"use strict";

var TBIJDRONECHART_CONSTANTS = TBIJDRONECHART_CONSTANTS || {};

TBIJDRONECHART_CONSTANTS = {
  strikesDefault: 600,
  reportedValues: '500-600',
  provincesTargetedValue: 3,
  strikesDatasetOptions:  {
                label: "Strikes",
                fill: false,
                lineTension: 0.1,
                backgroundColor: "rgba(75,192,192,0.4)",
                borderColor: "rgba(75,192,192,1)",
                borderCapStyle: 'butt',
                borderDash: [],
                borderDashOffset: 0.0,
                borderJoinStyle: 'miter',
                pointBorderColor: "rgba(75,192,192,1)",
                pointBackgroundColor: "#fff",
                pointBorderWidth: 1,
                pointHoverRadius: 5,
                pointHoverBackgroundColor: "rgba(75,192,192,1)",
                pointHoverBorderColor: "rgba(220,220,220,1)",
                pointHoverBorderWidth: 2,
                pointRadius: 1,
                pointHitRadius: 10,
                spanGaps: false,
  },
  casualtyReportOptions: {
    legend: {
      display: true,
      position: 'bottom',

    },
    title: {
      display: false
    },
    scales: {
      xAxes: [{
        stacked: false,
        gridLines: {
          display : false
        },
        ticks: {
          beginAtZero:true
        }
      }],
      yAxes: [{
        stacked: true,
        gridLines: {
          display : false
        }
      }],
    } // End of Scales
  }, // End of options
  strikeReportOptions: {

    legend: {display: false },
    title: { display: false },
    scales: {
      xAxes: [{
        gridLines: {
          display : false
        }
      }],
    } // End of Scales
  }
};