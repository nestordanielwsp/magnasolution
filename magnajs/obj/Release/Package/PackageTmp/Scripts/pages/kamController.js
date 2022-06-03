
(function () {
    'use strict';

    angular.module(appName)
        .controller('kamController', kamController);

    kamController.$inject = ['$scope', '$http', '$rootScope'];

    function kamController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || ''; 
        vm.vendedores = [];
        vm.clientes = [];
        vm.kams = [];
        vm.kam = {Clientes_:[]}
        vm.isValid = true;
        vm.filtro = { NombreVendedor: null }
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }
        var consultar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {}; 
                datos.Clientes = _.map(vm.filtro.Clientes_, function (e) { return e.ClienteId }).join(',');
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.kams = response.d.Kam;
                        vm.vendedores = response.d.Vendedor; 
                        vm.clientes = response.d.Cliente;
                        _.each(vm.kams, function (k) {
                            if (k.Clientes && k.Clientes!="")
                                k['ClientesView'] = angular.copy(k.Clientes).split(',');
                            k['VendedorIdOrigin'] = angular.copy(k.VendedorId);
                        })
                        vm.kams_ = angular.copy(vm.kams);

                        _.each(vm.vendedores, function (v) {
                            v.disabled = false
                            if(_.find(vm.kams, function (k) { return k.VendedorId == v.VendedorId }))v.disabled=true
                        })
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
                var datos = vm.filtro  || {};
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
            vm.kam = angular.copy(item);
            vm.kam['Clientes_'] = [];
            var split = angular.copy(item).Clientes.split(',');
            var splitIds = angular.copy(item).ClientesId.split(',');

            for (var i = 0; i<split.length;i++){
                vm.kam.Clientes_.push({ NombreCliente: split[i], ClienteId: splitIds[i]})
            }
            _.each(vm.clientes, function (c) {
                c.selected = false;
                var find = _.find(vm.kam.Clientes_, function (cl) { return cl.ClienteId == c.ClienteId });
                if(find)
                c.selected = true;
            })
            _.each(vm.vendedores, function (c) {
                c.selected = false;
                if (c.VendedorId ==vm.kam.VendedorId)
                    c.selected = true;
            })

            vm.viewDetail = true;
        }

      
        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                var datos = vm.kam; 
                datos.Clientes = _.map(vm.kam.Clientes_, function (e) { return e.ClienteId }).join(',')
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.KamId) {
                        vm.kam.KamId = response.d.KamId;
                        vm.kam.Active = response.d.Active;
                        vm.kam['VendedorIdOrigin'] = angular.copy(vm.kam.VendedorId);
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
            vm.kam = { Clientes_: [] }
            vm.kam.KamId = 0;
            vm.viewDetail = true;
        }

        init();

 
       
        vm.addClient = function (item) {
            vm.kam.Clientes_.push(item)
        };

        vm.removeCliente = function (item) {
            var idx = vm.kam.Clientes_.indexOf(item);
            vm.kam.Clientes_.splice(idx, 1);
        };

    } 
})();