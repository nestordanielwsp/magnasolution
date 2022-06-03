/**
 * @author v.lugovksy
 * created on 16.12.2015
 */
(function () {
  'use strict';

  angular.module(appName +'.theme.components')
      .directive('msgCenter', msgCenter);

  /** @ngInject */
  function msgCenter() {
    return {
      restrict: 'E',
      templateUrl: locationTheme +'theme/components/msgCenter/msgCenter.html',
      controller: 'MsgCenterCtrl'
    };
  }

})();