
(function () {
    'use strict';

    angular.module(appName)
        .controller('regionController', regionController);

    regionController.$inject = ['$scope', '$http', 'util'];

    function regionController($scope, $http, util) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.regiones = [];
        vm.jacs = JacInfo;
        vm.analistasCartera = AnalistaInfo;
        vm.jefesCartera = JefeCarteraInfo;
        vm.isValid = true;
        vm.filtro = { NombreRegion: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }

        $scope.analistaOptions = util.getOptionsMultiselect("UsuarioId", "NombreUsuario");
        $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

        var consultar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.regiones = response.d.Region;
                        vm.regiones_ = angular.copy(vm.regiones); 
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
            try {
                service.Execute("GetRegion", item, function (response) {
                    vm.region = response.d;
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
                var datos = vm.region;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.RegionId) {
                        vm.region.RegionId = response.d.RegionId;
                        vm.region.Active = response.d.Active;
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
            vm.region = { Analistas: [] };
            vm.region.RegionId = 0;
            vm.viewDetail = true;
        }

        init();


    } 
})();