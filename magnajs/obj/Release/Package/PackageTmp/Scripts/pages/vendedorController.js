
(function () {
    'use strict';

    angular.module(appName)
        .controller('vendedorController', vendedorController);

    vendedorController.$inject = ['$scope', '$http', '$rootScope'];

    function vendedorController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.vendedores = [];
        vm.jefes = [];
        vm.regiones = [];
        vm.isValid = true;
        vm.filtro = { NombreVendedor: null }
        vm.loading = true;

        vm.clearFiltros = function () {
            if(!vm.openFilterAdvance)
            vm.filtro = {} 
        }
        var consultar = function (filtros) {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.vendedores = response.d.Vendedor;
                        vm.vendedores_ = angular.copy(vm.vendedores);
                        vm.regiones = response.d.Region; 
                        vm.jefes = response.d.Jefe; 

                    }
                    Ex.load(false)
                    vm.loading = false;

                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
                vm.loading = false;

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
            vm.vendedor = angular.copy(item);
            vm.viewDetail = true;
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.vendedor;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.VendedorId) {
                        vm.vendedor.VendedorId = response.d.VendedorId;
                        vm.vendedor.Active = response.d.Active;
                    }
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null,null,null, function (r) {
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
            vm.loading = true;
            consultar();
        }

        vm.agregar = function () {
            vm.vendedor = {}
            vm.vendedor.VendedorId = 0;
            vm.viewDetail = true;
        }

        init();


    } 
})();