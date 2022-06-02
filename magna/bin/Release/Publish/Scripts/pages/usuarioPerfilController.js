(function () {
    'use strict';

    angular.module(appName)
        .controller('usuarioPerfilController', usuarioPerfilController);

    usuarioPerfilController.$inject = ['$scope', '$http', '$rootScope'];

    function usuarioPerfilController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.perfil = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.menus = MenuInfo;

        //vm.MenuIds = [1, 2 ,4];
        //$rootScope.$broadcast('tituloPagina', { value: titulo });
        vm.perfiles = [];
        vm.filtro = { NombrePerfil: null }
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
                        vm.perfiles = response.d.Perfil;
                        vm.perfiles_ = angular.copy(vm.perfiles);
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
                service.Execute("GetPerfil", item, function (response) {
                    vm.perfil = response.d;
                    vm.perfil.MenuPerfil = [];
                    var totalMenus = vm.perfil.Menus.length;
                    for (var i = 0; i < totalMenus; i++) {
                        vm.perfil.MenuPerfil.push(vm.perfil.Menus[i].MenuId);
                    }
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

                if (!vm.perfil.MenuPerfil || vm.perfil.MenuPerfil.length === 0) {
                    Ex.mensajes(Ex.GetResourceValue("msgSeleccionarAcceso"));
                    return;
                }

                var datos = vm.perfil;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.PerfilId) {
                        vm.perfil.PerfilId = response.d.PerfilId;
                        vm.perfil.Active = response.d.Active;
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
            vm.perfil = {}
            vm.perfil.PerfilId = 0;
            vm.viewDetail = true;
        }

        init();


    }
})();