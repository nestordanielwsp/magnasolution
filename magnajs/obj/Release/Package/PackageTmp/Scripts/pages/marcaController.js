
(function () {
    'use strict';

    angular.module(appName)
        .controller('marcaController', marcaController);

    marcaController.$inject = ['$scope', '$http', 'util', '$rootScope'];

    function marcaController($scope, $http, util, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.marcas = [];
        vm.isValid = true;
        vm.filtro = { NombreMarca: null };
        vm.gerentes = GerenteInfo;

        $scope.canales = CanalInfo;

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
                        vm.marcas = response.d.Marcas;
                        vm.marcas_ = angular.copy(vm.marcas);

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
            //vm.marca = angular.copy(item);

            try {
                vm.marca = angular.copy(item);

                Ex.load(true);
                var datos = { LineaCodigo: vm.marca.LineaCodigo };
                service.Execute('GetMarcalCanalByLineaCodigo', datos, function (response) {
                    if (response.d) {

                        vm.marca.Canales = response.d;
                    }
                    Ex.load(false);
                    vm.viewDetail = true;
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

            //vm.marca.Canales = item.CanalesIDs.split(",");

            //vm.viewDetail = true;
        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                } else if (vm.marca.Canales.length == 0) {
                    vm.isValid = false;
                    Ex.mensajes(Ex.GetResourceValue('lblAtLeastOneCanal'), 5);
                    return;
                }

                vm.marca.canalesIDs = _.pluck(vm.marca.Canales, "id").join(",");

                var datos = vm.marca;
                
                service.Execute("ValidarCanalesPorLineaCodigo", datos, function (response, isInvalid) {

                    if (response.d[0].MensajeValidacion) {
                        Ex.mensajes(response.d[0].MensajeValidacion, 2, null, null, null, function () {
                            guardarMarca(datos);
                        }, function () { }, null);
                    }
                    else {
                        guardarMarca(datos);
                    }

                });


            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        var guardarMarca = function (datos) {
            service.Execute("Guardar", datos, function (response, isInvalid) {
                if (isInvalid) {
                    req.form.isValid = false;
                    return;
                }
                if (response.d.MarcaId) {
                    vm.marca.MarcaId = response.d.MarcaId;
                    vm.marca.Active = response.d.Active;
                }
                Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, function (r) {
                    vm.openFilterAdvance = false; vm.clearFiltros(); vm.actualizar(); vm.viewDetail = false;
                }, null);
                Ex.load(false);
            });
        }

        vm.actualizar = function () {
            consultar();
        }

        vm.agregar = function () {
            vm.marca = { EsNuevo: true, Canales: [] }
            vm.viewDetail = true;
        }

        var setSubcuenta = function (item) {
            //var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
            //subcuentas.push(marca.SubcuentaContable);
            //$scope.marcasSeleccionadas.push(marca);
            //$scope.activity.Subcuenta = subcuentas.join(",");
            //$scope.SuperFiltro.Marcas = _.pluck($scope.activity.Marcas, 'id').join(",");

            //$scope.fileParametersPromocion.Marca = marca.NombreMarca;
            //$scope.fileParametersEstructuraComercial.Marca = marca.NombreMarca;
            var x = 1;
        }

        var removeSubcuenta = function (item) {
            //var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
            //var index = _.indexOf(subcuentas, marca.SubcuentaContable);
            //var indexMarca = _.indexOf($scope.marcasSeleccionadas, marca.SubcuentaContable);
            //subcuentas.splice(index, 1);
            //$scope.marcasSeleccionadas.splice(index, 1);
            //$scope.activity.Subcuenta = subcuentas.join(",");
            //$scope.SuperFiltro.Marcas = _.pluck($scope.activity.Marcas, 'id').join(",");
            //$scope.SetValuesMarca();
            var x = 1;
        };
        $scope.canalesSeleccionados = [];
        $scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");
        $scope.multiselectEventos = {
            onItemSelect: setSubcuenta,
            onItemDeselect: removeSubcuenta,
            onDeselectAll: function () {
                //$scope.activity.Subcuenta = "";
                //subcuentas = [];
                $scope.canalesSeleccionados = [];
                //$scope.SuperFiltro.Marcas = [];
                //$scope.SetValuesMarca();
            }
        };

        $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

        init();


    }
})();