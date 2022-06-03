
(function () {
    'use strict';

    angular.module(appName)
        .controller('evidenciasController', canalController);

    canalController.$inject = ['$scope', '$http', 'enums', 'util', '$timeout'];

    function canalController($scope, $http, enums, util, $timeout) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.isValid = true;
        $scope.modalForm = {};
        $scope.evidencia = [];
        vm.tipoEvidencias = [];

        $scope.fileOptionsDetalle = {
            url: "../Codes/UploadFile.ashx",
            autoUpload: true,
            validExtensions: Ex.GetResourceValue('validExtensions'),
            maxFilesize: Ex.GetResourceValue('maxFileSize'),
            puedeEliminar: true
        };

        $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };


        var consultar = function () {
            try {
                vm.tipoApoyo = [];
                vm.tipoApoyo_ = [];
                // Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.tipoApoyo = response.d.TipoApoyo;
                        vm.tipoApoyo_ = angular.copy(vm.tipoApoyo);
                    }
                    Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.consultar = function () {
            consultar();
        };

        var tipoApoyoSeleccionada = {};
        $scope.openModalNotas = function (tipoApoyo) {

            try {
                tipoApoyoSeleccionada = tipoApoyo;

                $scope.evidencia = {
                    TipoApoyoId: tipoApoyo.TipoApoyoId,
                    NombreTipoEvidencia: tipoApoyo.NombreTipoEvidencia,
                    NombreTipoApoyo: tipoApoyo.NombreTipoApoyo
                };


                $scope.tituloModal = "Evidencias (Tipo de Apoyo)";
                $scope.tituloDetalle = "Detalle";
                $scope.tituloEvidencias = "Evidencias";
                $scope.tituloDescripcion = "Descripción";

                vm.tipoApoyoEvidencia = [];
                vm.tipoApoyoEvidencia_ = [];
                //Ex.load(true);
                var datos = { TipoApoyoId: tipoApoyo.TipoApoyoId };
                service.Execute('ConsultarEvidencia', datos, function (response) {
                    if (response.d) {
                        vm.tipoApoyoEvidencia = response.d.TipoApoyoEvidencia;
                        vm.tipoApoyoEvidencia_ = angular.copy(vm.tipoApoyoEvidencia);
                    }
                    //Ex.load(false);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                // Ex.load(false);
            }

            Ex.load(false);
            $scope.modalNotas.open();
        };

        $scope.setParametrosArchivo = function (response, item) {
            item.UID = response.UID;
            item.RutaArchivo = response.RutaArchivo;
            item.EsArchivoNuevo = response.EsNuevo;
        };

        $scope.abrirDocumento = function (item) {
            $Ex.Execute("AbrirDocumento", item, function (response, isInvalid) {
                if (response.d) {
                    window.location = "DownLoadPage.aspx?d=" + getRandom();
                }
                else {
                    Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                }
            });
        };

        //var devolucioncausalSeleccionada = [];        
        $scope.guardar = function (forma) {
            $scope.submitted = true;
          
            // Ex.load(true);
            $Ex.Execute("Guardar", vm.tipoApoyoEvidencia, function (response, isInvalid) {
                Ex.load(false);
                if (response.d == 0) {
                    Ex.mensajes("Se deben cargar todos los archivos marcados como **Requerido**");
                } else {

                    $scope.modalNotas.close();
                }
            });


        };




        var init = function () {
            vm.tipoEvidencias = TipoEvidenciaInfo;
            vm.consultar();
        }


        init();
    }
})();