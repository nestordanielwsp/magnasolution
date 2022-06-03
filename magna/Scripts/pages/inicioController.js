(function () {
    'use strict';

    angular.module(appName)
        .controller('inicioController', inicioController);

    inicioController.$inject = ['$scope', '$http', '$rootScope'];

    function inicioController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var ctrl = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.configuracionGeneral = [];
        vm.isValid = true;

        //var consultar = function (filtros) {
        //    try {
        //        Ex.load(true);
        //        var datos = filtros || {};
        //        service.Execute('Consultar', datos, function (response) {
        //            if (response.d) {
        //                vm.configuracionGeneral = response.d.ConfiguracionGeneral[0];
        //            }
        //            Ex.load(false)
        //        })
        //    }
        //    catch (ex) {
        //        Ex.mensajes(ex.message, 4);
        //        Ex.load(false);
        //    }
        //}
        var init = function () {
            //  consultar();
        }


        init();


    }
})();