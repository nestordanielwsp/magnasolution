/**
 * @author v.lugovksy
 * created on 16.12.2015
 */
(function () {
  'use strict';

  angular.module(appName +'.theme.components')
      .directive('contentTop', contentTop);

  /** @ngInject */
  function contentTop($location, $state) {
    return {
        restrict: 'E',
        scope: {
            titulo: '@'
        },
      templateUrl: locationTheme +'theme/components/contentTop/contentTop.html',
      link: function($scope) {
        $scope.$watch(function () {
            $scope.activePageTitle = $state.current.title; 
        });
      }
    };
  }

})();