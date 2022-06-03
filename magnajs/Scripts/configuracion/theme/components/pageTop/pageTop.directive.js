 
(function () {
  'use strict';

  angular.module('app.theme.components')
      .directive('pageTop', pageTop);

  /** @ngInject */
  function pageTop() {
    return {
        restrict: 'E',
        scope: {
            titulo:'@'
        },
        templateUrl: locationTheme + 'theme/components/pageTop/pageTop.html',
        link: function ($scope) { 
        }
    };
  }

})();