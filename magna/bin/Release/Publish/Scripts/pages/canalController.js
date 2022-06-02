
(function () {
    'use strict';

    angular.module(appName)
        .controller('canalController', canalController);

    canalController.$inject = ['$scope', '$http', 'util'];

    function canalController($scope, $http, util) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.centroCostos = [];
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        //$rootScope.$broadcast('tituloPagina', { value: titulo });
        vm.canales = [];
        vm.grupos = [];
        vm.isValid = true;
        vm.filtro = { NombreCanal: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }

        vm.gerentes = GerenteInfo;
        vm.gerentesMac = GerenteMacInfo;
        vm.coordinadoresMac = CoordinadorMacInfo;
        vm.gerentesCartera = GerenteCarteraInfo;
        vm.especialistaCC = EspecialistaCCInfo;

        $scope.coordinadorOptions = util.getOptionsMultiselect("UsuarioId", "NombreUsuario");
        $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

        var consultarCanales = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.canales = response.d.Canales;
                        vm.canales_ = angular.copy(vm.canales);
                        vm.grupos = response.d.Grupos;
                        vm.centroCostos = response.d.CentroCosto;
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
        vm.Editar = function (item) {
            try {
                service.Execute("GetCanal", item, function (response) {
                    vm.canal = response.d;
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
                var datos = vm.canal;
                service.Execute("Guardar",
                    vm.canal,
                    function (response, isInvalid) {
                        if (isInvalid) {
                            req.form.isValid = false;
                            return;
                        }
                        if (response.d.CanalId) {
                            vm.canal.CanalId = response.d.CanalId;
                            vm.canal.Active = response.d.Active;
                        }
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
                        Ex.load(false);
                    });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        vm.actualizar = function () {
            consultarCanales();
        };

        vm.agregar = function () {
            vm.canal = { Coordinadores: [] }
            vm.canal.CanalId = 0;
            vm.viewDetail = true;
        };


        //vm.hablitarObjetivoCobrabilidad = function() {
        //    vm.canal.ObjetivoCobrabilidad = null;
        //};

        init();
    }
})();