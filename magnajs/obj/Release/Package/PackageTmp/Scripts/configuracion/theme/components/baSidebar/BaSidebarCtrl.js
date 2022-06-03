 
(function () {
  'use strict';

  angular.module('app.theme.components')
    .controller('BaSidebarCtrl', BaSidebarCtrl);

  /** @ngInject */
  function BaSidebarCtrl($scope, baSidebarService) {

      //$scope.menuItems = baSidebarService.getMenuItems();
      $scope.menuItems = appMenu;
    $scope.defaultSidebarState = $scope.menuItems[0].stateRef;

    $scope.hoverItem = function ($event) {
      $scope.showHoverElem = true;
      $scope.hoverElemHeight =  $event.currentTarget.clientHeight;
      var menuTopValue = 66;
      $scope.hoverElemTop = $event.currentTarget.getBoundingClientRect().top - menuTopValue;
    };

    $scope.$on('$stateChangeSuccess', function () {
      if (baSidebarService.canSidebarBeHidden()) {
        baSidebarService.setMenuCollapsed(true);
      }
    });
  }
})();