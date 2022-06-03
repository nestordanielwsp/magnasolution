(function () {
    'use strict';

    angular.module(appName)
        .controller('inicioController', inicioController);

    inicioController.$inject = ['$scope', '$http', '$rootScope'];

    function inicioController($scope, $http, $rootScope) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.titulo = Ex.GetResourceValue("Titulo") || '';       
        vm.isValid = true;
        vm.principal = [];


        $scope.fileOptionsDetalle = {
            url: "../Codes/UploadFile.ashx",
            autoUpload: true,
            validExtensions: Ex.GetResourceValue('validExtensions'),
            maxFilesize: Ex.GetResourceValue('maxFileSize'),
            puedeEliminar: true
        };


        $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };



        $scope.openDocumento = function (info) {
            try {
                $scope.evidenciaAbierta = true;
                $Ex.Execute("OpenDocumento", info, function (response, isInvalid) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                    else {
                        Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                    }
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
            }
        };


        $scope.setParametrosArchivo = function (response, item) {
            item.UID = response.UID;
            item.RutaArchivo = response.RutaArchivo;
            item.EsArchivoNuevo = response.EsNuevo;
        };


        vm.consultar = function () {
            try {
                Ex.load(true);
                var datos = {};
                service.Execute('GetInformacion', datos, function (response) {
                    if (response.d) {                        
                        vm.principal = response.d.InformacionPrincipal;
                        vm.principal_ = angular.copy(vm.principal);
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
            vm.consultar();
        }


        init();


    }
})();