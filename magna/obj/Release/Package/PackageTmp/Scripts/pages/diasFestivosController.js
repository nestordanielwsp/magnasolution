
(function () {
    'use strict';

    angular.module(appName)
        .controller('diasFestivosController', canalController);

    canalController.$inject = ['$scope', '$http', 'util'];

    function canalController($scope, $http, util) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.diaFestivo = {};
        vm.centroCostos = [];
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        //$rootScope.$broadcast('tituloPagina', { value: titulo });
        vm.canales = [];
        vm.anios = [];
        vm.isValid = true;
        vm.filtro = { NombreCanal: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }
           
        var consultarCanales = function () {
            try {
                Ex.load(true);
                var datos =  vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.diasFestivos = response.d.DiasFestivos;
                        vm.diasFestivos_ = angular.copy(vm.DiasFestivos);
                        vm.anios = response.d.Anios;  
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
            consultarCanales();
        }

        vm.descargar = function (filtros) {
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
        
        vm.actualizar = function() {
            consultarCanales();
        };

        vm.Editar = function (item) {
            try {
                service.Execute("GetDiasFestivo", item, function (response) {
                    vm.diaFestivo = response.d;
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
                var datos = vm.diaFestivo;
                service.Execute("Guardar",
                    vm.diaFestivo,
                    function (response, isInvalid) {
                        if (isInvalid) {
                            req.form.isValid = false;
                            return;
                        }
                        if (response.d.Mensaje != '') {
                            Ex.mensajes(response.d.Mensaje);
                        }
                        else {
                            Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"),
                                1,
                                null,
                                null,
                                null,
                                function (r) {
                                    vm.openFilterAdvance = false;
                                    vm.clearFiltros();
                                    vm.actualizar();
                                    vm.viewDetail = false;
                                },
                                null);
                        }
                        Ex.load(false);
                    });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        init();
    } 
})();