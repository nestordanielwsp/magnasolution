
(function () {
    'use strict';

    angular.module(appName)
        .controller('productoController', productoController);

    productoController.$inject = ['$scope', '$http', '$rootScope'];

    function productoController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.productos = [];
        vm.isValid = true;
        vm.marcas = []; 
        vm.filtro = { NombreProducto: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }
        vm.loading = true;
        var consultar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.productos = response.d.Producto;
                        vm.productos_ = angular.copy(vm.productos);
                        vm.marcas = response.d.Marca;  
                    }
                    Ex.load(false);
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
            vm.producto = angular.copy(item);
            vm.viewDetail = true;
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.producto;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.ProductoId) {
                        vm.producto.ProductoId = response.d.ProductoId;
                        vm.producto.Active = response.d.Active;
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
            vm.viewDetail = false;
            vm.loading = true; 
               consultar(); 
        }
        vm.agregar = function () {
            vm.producto = { EsNuevo: true }
            vm.viewDetail = true;
        }

        init();


    } 
})();