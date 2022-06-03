
(function () {
    'use strict';

    angular.module(appName)
        .controller('cuentaContableController', cuentaContableController);

    cuentaContableController.$inject = ['$scope', '$http', '$rootScope'];

    function cuentaContableController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.cuentasContables = [];
        vm.isValid = true;
        vm.rubros = RubroInfo;
        vm.filtro = { NombreCuentaContable: null };
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        };
        var consultar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.cuentasContables = response.d.CuentaContable;
                        vm.cuentasContables_ = angular.copy(vm.cuentasContables);
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

        vm.descargar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Exportar', datos, function (response, isInvalid) {
                    if (isInvalid) {
                        return;
                    }
                    window.location = "DownLoadPage.aspx";
                    setTimeout(function () {
                        Ex.load(false);
                    }, 1000);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.Editar = function (item) {
            vm.cuentaContable = angular.copy(item);
            vm.viewDetail = true;
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.cuentaContable;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.CuentaContableId) {
                        vm.cuentaContable.CuentaContableId = response.d.CuentaContableId;
                        vm.cuentaContable.Active = response.d.Active;
                    }
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, function (r) {
                        vm.openFilterAdvance = false; vm.clearFiltros(); vm.actualizar(); vm.viewDetail = false;
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
            vm.cuentaContable = {}
            vm.cuentaContable.CuentaContableId = 0;
            vm.viewDetail = true;
        }

        init();


    }
})();