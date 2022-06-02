
(function () {
    'use strict';

    angular.module(appName)
        .controller('tipoDescuentoController', tipoDescuentoController);

    tipoDescuentoController.$inject = ['$scope', '$http', '$rootScope'];

    function tipoDescuentoController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.tipoDescuentos = []; 
        vm.isValid = true;
        vm.filtro = { NombreTipoDescuento: null }
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
                        vm.tipoDescuentos = response.d.TipoDescuento;
                        vm.tipoDescuentos_ = angular.copy(vm.tipoDescuentos);  
                        //vm.tiposDescuentoContractual = response.d.TipoDescuentoContractual;
                        vm.tiposDescuentoContractual = [{
                            TipoDescuentoContractualId: 1,
                            NombreTipoDescuentoContractual: 'Porcentaje'
                        }, {
                            TipoDescuentoContractualId: 2,
                            NombreTipoDescuentoContractual: 'Monto'
                        }];
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


        $scope.validarTipoDescuento = function (esCambioOpcion) {
            if (vm.tipoDescuento.TipoDescuentoContractualId === 2) {
                vm.tipoDescuento.AutocalculadoPorFacturas = false;
                vm.tipoDescuento.ReferenciaFactura = false;
                vm.desactivarReferenciaFactura = false;                
            } else {
                vm.tipoDescuento.AutocalculadoPorFacturas = true;
                vm.tipoDescuento.ReferenciaFactura = false;
                vm.desactivarReferenciaFactura = true;
            }
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
            vm.tipoDescuento = angular.copy(item);
            vm.viewDetail = true;
            if (vm.tipoDescuento.TipoDescuentoContractualId === 2) {
                vm.desactivarReferenciaFactura = false;
            } else {
                vm.desactivarReferenciaFactura = true;
            }
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.tipoDescuento;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.TipoDescuentoId) {
                        vm.tipoDescuento.TipoDescuentoId = response.d.TipoDescuentoId;
                        vm.tipoDescuento.Active = response.d.Active;
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
            vm.tipoDescuento = {}
            vm.tipoDescuento.TipoDescuentoId = 0;
            vm.viewDetail = true;
        }

        init();


    } 
})();