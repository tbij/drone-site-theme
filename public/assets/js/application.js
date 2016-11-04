jQuery(function ($) {

"use strict";

// Create global namespace to put stuff

var TBIJDRONES = TBIJDRONES || {};

var headerElem = $('header[role="banner"]'),
    articleHeaderElem = $('article header'),
    windowHeight,
    headerHeight,
    articleHeaderHeight;

// Initialiser

TBIJDRONES.initialiser = {

  getHeights: function() {
    windowHeight = $(window).height();
    headerHeight = $(headerElem).height();
    articleHeaderHeight = $(articleHeaderElem).outerHeight(true);
  },

  mainElem: function() {
    if($('body').is('.category, .single-post') && $('nav[role="navigation"] h2').css('position') === 'absolute') { // This could be better
      var subNavHeight = $(headerElem).find('nav[role="navigation"] ul ul').height();
      headerHeight = headerHeight + subNavHeight;
    }

    $('main[role="main"]').css('margin-top',(headerHeight));
  },

  siteAsideElem: function() {
    if($('nav[role="navigation"] h2').css('position') === 'absolute') {
      $('body').removeClass('nav-open'); // Could this be better positioned?
      $('aside.site-related').css('margin-top',(articleHeaderHeight));
    } else {
      $('aside.site-related').css('margin-top',0);
    }
  },

  mobileNav: function() {
    $('nav[role="navigation"] h2').on('click', 'a', function(e) {
      e.preventDefault();
      $('body').toggleClass('nav-open');
      $(this).toggleClass('icon-menu icon-times');
    });
  },
};

// Resize

TBIJDRONES.dom = {
  resizeUpdate: function() {},
};

// Call functions

$(document).ready(function() {  
  var tdi = TBIJDRONES.initialiser;

  tdi.getHeights();
  tdi.mainElem();
  tdi.siteAsideElem();
  tdi.mobileNav();
});

$(window).resize(function() {
  var dom = TBIJDRONES.dom,
      tdi = TBIJDRONES.initialiser;

  tdi.getHeights();
  tdi.mainElem();
  tdi.siteAsideElem();

  dom.resizeUpdate();
});

});