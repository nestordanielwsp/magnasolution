
(function () {
    'use strict';

    angular.module(appName)
        .controller('configuracionGeneralController', configuracionGeneralController);

    configuracionGeneralController.$inject = ['$scope', '$http', '$rootScope'];

    function configuracionGeneralController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.configuracionGeneral = []; 
        vm.isValid = true;

        var consultar = function (filtros) {
            try {
                Ex.load(true);
                var datos = filtros || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.configuracionGeneral = response.d.ConfiguracionGeneral[0]; 
                    }
                    Ex.load(false)
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        var init = function () {
            consultar();
        }

        
       

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.configuracionGeneral;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.ConfiguracionGeneralId) {
                        vm.configuracionGeneral.ConfiguracionGeneralId = response.d.ConfiguracionGeneralId;
                        vm.configuracionGeneral.Active = response.d.Active;
                    }
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, null, null);
                    Ex.load(false);
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.actualizar = function () {
            vm.filtro = '';
            consultar();
        }

        

        init();


    } 
})();