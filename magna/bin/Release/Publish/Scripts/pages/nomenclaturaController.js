(function () {
    'use strict';

    angular.module(appName)
        .controller('nomenclaturaController', nomenclaturaController);

    nomenclaturaController.$inject = ['$scope', '$http', '$rootScope'];

    function nomenclaturaController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.nomenclatura = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.menus = MenuInfo;

        //vm.MenuIds = [1, 2 ,4];
        //$rootScope.$broadcast('tituloPagina', { value: titulo });
        vm.nomenclaturas = [];
        vm.filtro = { NombreNomenclatura: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }
        var consultar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.nomenclaturas = response.d.Nomenclatura;
                        vm.nomenclaturas_ = angular.copy(vm.nomenclaturas);
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


        vm.Editar = function (item) {
            try {
                service.Execute("GetNomenclatura", item, function (response) {
                    vm.nomenclatura = response.d[0];                    
                    vm.viewDetail = true;
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }

                //if (!vm.nomenclatura.MenuPerfil || vm.nomenclatura.MenuPerfil.length === 0) {
                //    Ex.mensajes(Ex.GetResourceValue("msgSeleccionarAcceso"));
                //    return;
                //}

                var datos = vm.nomenclatura;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.NomenclaturaId) {
                        vm.nomenclatura.NomenclaturaId = response.d.NomenclaturaId;
                        vm.nomenclatura.Active = response.d.Active;
                    }
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, function (r) {
                        vm.clearFiltros(); vm.actualizar(); vm.viewDetail = false;
                    }, null);
                    Ex.load(false);
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.actualizar = function () {
            consultar();
        }
        vm.agregar = function () {
            vm.nomenclatura = {}
            vm.nomenclatura.NomenclaturaId = 0;
            vm.viewDetail = true;
        }

        init();


    }
})();