(function () {
    'use strict';

    angular.module(appName)
        .controller('descuentoContractualController', descuentoContractualController);

    descuentoContractualController.$inject = ['$scope', '$http', '$rootScope'];

    function descuentoContractualController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.descuentosContractuales = [];
        vm.tipoDescuentos = [];
        vm.cuentasContables = CuentaContableInfo;
        vm.tiposDescuentoContractual = [];
        vm.notasdeCredito = [];
        vm.marcas = [];
        vm.canales = [];
        vm.estatusDescuento = [];
        vm.isValid = true;
        vm.filtro = { Codigo: null }
        vm.loading = true;

        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }
        var consultar = function (filtros) {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.descuentosContractuales = response.d.DescuentoContractual;
                        vm.descuentosContractuales_ = angular.copy(response.d.DescuentoContractual);
                        vm.tipoDescuentos = response.d.TipoDescuento;
                        vm.tiposDescuentoContractual = response.d.TipoDescuentoContractual;
                        vm.marcas = response.d.Marca;
                        vm.canales = response.d.Canal;
                        vm.estatusDescuento = response.d.EstatusDescuento;

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
                    }, 100);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        //vm.Editar = function (item) {
        //    vm.descuentoContractual = angular.copy(item);
        //    vm.descuentoContractual.Fecha = { StartDate: item.VigenciaInicio, EndDate: item.VigenciaFin }
        //    vm.clienteSeleccionado = { ClienteId: item.ClienteId, Cliente: item.NombreCliente, Active: true };
        //    vm.viewDetail = true;
        //}

        vm.Editar = function (item) {
            try {
                Ex.load(true);
                $Ex.Execute("GetDescuento", item, function (response) {
                    vm.descuentoContractual = response.d;
                    vm.notasdeCredito_ = response.d.NotasCredito;
                    vm.descuentoContractual.Fecha = { StartDate: response.d.VigenciaInicio, EndDate: response.d.VigenciaFin }
                    vm.clienteSeleccionado = { ClienteId: item.ClienteId, Cliente: item.NombreCliente, Active: true };
                    $scope.validarTipoDescuento(false);
                    vm.viewDetail = true;

                    $scope.changeTipoDescuento(); // dal
                });

            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        $scope.changeTipoDescuento = function() {
            var tipoDescuento = _.find(vm.tipoDescuentos, { TipoDescuentoId: vm.descuentoContractual.TipoDescuentoId });

            vm.descuentoContractual.TipoDescuentoContractualId = tipoDescuento.TipoDescuentoContractualId;


            $scope.esProntoPago = vm.descuentoContractual.TipoDescuentoId === 2;// dalmaguer
        };

        vm.EditarNC = function () {
            debugger;
        }

        vm.guardar = function () {
            try {


                if (vm.descuentoContractual.TipoDescuentoId != 2) {
                    vm.descuentoContractual.DiasProntoPago = 0;// dal
                }
                else {
                    if (vm.descuentoContractual.DiasProntoPago == undefined || vm.descuentoContractual.DiasProntoPago == '' ||
                        vm.descuentoContractual.DiasProntoPago <= 0) {
                        Ex.mensajes(Ex.GetResourceValue("msgErrorDiasProntoPago"), 4);
                        return;// dal
                    }
                }

                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }                

                if (vm.descuentoContractual.TipoDescuentoContractualId == 1 && vm.descuentoContractual.Monto > 100) {
                    Ex.mensajes(Ex.GetResourceValue("msgErrorPorcentajeMayor"), 4);
                    return;
                }

                vm.descuentoContractual.VigenciaInicio = vm.descuentoContractual.Fecha ?
                    vm.descuentoContractual.Fecha.StartDate : "";
                vm.descuentoContractual.VigenciaFin = vm.descuentoContractual.Fecha ?
                    vm.descuentoContractual.Fecha.EndDate : "";

                var datos = vm.descuentoContractual;

                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.DescuentoContractualId) {
                        vm.descuentoContractual.DescuentoContractualId = response.d.DescuentoContractualId;
                        vm.descuentoContractual.Active = response.d.Active;
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
            vm.descuentoContractual = { Fecha: null };
            vm.descuentoContractual.DescuentoContractualId = 0;
            vm.viewDetail = true;
            $scope.esPorMonto = false
            $scope.esProntoPago = false// dal
        }

        init();

        $scope.validarTipoDescuento = function (esCambioOpcion) {
            $scope.esPorMonto = vm.descuentoContractual.TipoDescuentoContractualId === 2;

            vm.descuentoContractual.EsMontoFijo = $scope.esPorMonto && (esCambioOpcion || vm.descuentoContractual.EsMontoFijo);
        }

        vm.autoCompleteOptions = {
            idProp: "ClienteId",
            displayProp: "Cliente",
            methodName: "ConsultarClientes"
        };

        vm.getOrdenes = function (val, val2) {
            console.log(val, val2)
        }

    }
})();